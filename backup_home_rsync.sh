#!/bin/bash

BACKUP_FOLDER="/media/$USER/backup"
LOG_FOLDER=$PWD

RSYNC_COMMAND=$(rsync -vrahi  --exclude={'.cache/*','.local/share/Trash','.mozilla/*'} --delete "/home/$USER" "$BACKUP_FOLDER")

    if [ $? -eq 0 ]; then
        if [ -n "${RSYNC_COMMAND}" ]; then
            sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Il backup giornaliero è stato effettuato: $(date): files modificati"
        echo "Backup eseguito: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
        else
            sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Il backup giornaliero è stato effettuato: $(date): nessuna modifica"
        echo "Backup eseguito senza modifiche: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
        fi
    else
        sh "$PWD/backup_notify"  -u critical -i dialog-warning "Backup giornaliero" "Si è verificato un errore: $(date)"
        echo "Errore, backup non eseguito: $(date)" >> "$LOG_FOLDER/backup_home_rsync.log"
        exit 1
    fi
$PWD
