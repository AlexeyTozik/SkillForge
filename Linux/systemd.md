## Systemctl & Journalctl

| command                     | description                                                                                                                                                   |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| systemctl start <service>   | запуск службы                                                                                                                                                 |
| systemctl stop <service>    | остановка службы                                                                                                                                              |
| systemctl restart <service> | перезапуск службы                                                                                                                                             |
| systemctl enable <service>  | включение автозапуска службы при загрузке системы                                                                                                             |
| systemctl disable <service> | отключение автозапуска службы при загрузке системы                                                                                                            |
| systemctl status <service>  | получение информации о состоянии службы                                                                                                                       |
| systemctl reload <service>  | обновить конфигурационные файлы (без перезапуска службы)                                                                                                      |
| systemctl edit <service>    | редактирование служебного файла systemd                                                                                                                       |
| systemctl daemon-reload     | выполняет перезагрузку демона systemd, обновляя его конфигурацию и перечитывая все измененные файлы в директориях /etc/systemd/system/ и /run/systemd/system/ |
| journalctl                  | используется для просмотра системного журнала                                                                                                                 |
