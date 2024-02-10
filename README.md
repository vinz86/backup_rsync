BACKUP HOME

-rendere i file eseguibili

``chmod 775 backup_home_rsync.sh``

``chmod 775 backup_notify``

-lanciare il comando:

``crontab -e``

-aggiungere il cron:

``0 8 * * * /bin/bash /home/nome_utente/backup_home/backup_home_rsync.sh
``
----------

o aggiungere il comando in avvio automatico:

``bash /home/nome_utente/backup_home/backup_home_rsync.sh``


