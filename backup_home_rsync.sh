#!/bin/bash

LOG_ENABLED=true

INPUT_FOLDER="/home/$USER"
BACKUP_FOLDER="/media/$USER/backup"
LOG_FOLDER="$PWD"

CURRENT_DIRECTORY="$PWD"

cd "$INPUT_FOLDER" ||
if [ $? -eq 1 ]; then
  echo "KO - Errore: $INPUT_FOLDER non esistente: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
  exit 1
fi

cd "$BACKUP_FOLDER" ||
if [ $? -eq 1 ]; then
  echo "KO - Errore: $BACKUP_FOLDER non esistente: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
  exit 1
fi

# Ritorno nella directory dello script
cd "$CURRENT_DIRECTORY" ||

# -v    --verbose
# -h    --human-readable
# -r    --recursive
# -a    --archive             crea un archivio dei file, compresi gli attributi dei file
# -i    --itemize-changes     restituisce in output la lista dei cambiamenti
#       --delete              cancella files estranei dalla cartella di destinazione

#RSYNC_COMMAND=$(rsync -vhrai  --exclude={'.cache/*','.local/share/Trash','.mozilla/*'} --delete "$INPUT_FOLDER" "$BACKUP_FOLDER")
RSYNC_COMMAND=$(rsync -rai  --exclude={'.cache/*','.local/share/Trash','.mozilla/*'} --delete "$INPUT_FOLDER" "$BACKUP_FOLDER")
if [ $? -eq 0 ]; then
  if [ -n "${RSYNC_COMMAND}" ]; then
    sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Backup eseguito: $(date)"
    if [ ${LOG_ENABLED} = true ]; then
      echo "OK - Backup eseguito: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
    fi
  else
    sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Backup eseguito senza modifiche: $(date)"
    if [ ${LOG_ENABLED} = true ]; then
      echo "NM - Backup eseguito: nessuna modifica: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
    fi
  fi
else
  sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Si è verificato un errore: $(date)"
    if [ ${LOG_ENABLED} = true ]; then
      echo "KO - Errore: backup non eseguito: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
    fi
  exit 1
fi
