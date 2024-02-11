#!/bin/bash

INPUT_FOLDER="/home/$USER"
BACKUP_FOLDER="/media/$USER/backup"
LOG_ENABLED=true
LOG_FOLDER=$PWD

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
    sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Il backup giornaliero è stato effettuato: $(date): files modificati"
    if [ ${LOG_ENABLED} = true ]; then
      echo "Backup eseguito: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
    fi
  else
    sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Il backup giornaliero è stato effettuato: $(date): nessuna modifica"
    if [ ${LOG_ENABLED} = true ]; then
      echo "Backup eseguito senza modifiche: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
    fi
  fi
else
  sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Si è verificato un errore: $(date)"
    if [ ${LOG_ENABLED} = true ]; then
      echo "Errore, backup non eseguito: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
    fi
  exit 1
fi
