Set-location \  #Setter lokasjon hjem

New-Item "C:Zabbix" -Type Directory  #Lager directory

Set-Location C:\Zabbix\  #Hopper inn i dir

#Brannmur regel for å tillate trafikk på port 10050

New-NetFirewallRule -DisplayName "Allow inbound 10050" -Direction Inbound -Protocol TCP -Action Allow -LocalPort 10050 -Profile Domain

Invoke-WebRequest -Uri kyrre.mysil.local/code/zabbix_agentd.exe -OutFile C:\Zabbix\zabbix_agentd.exe #Laster ned exe

Invoke-WebRequest -Uri kyrre.mysil.local/code/windows_zabbix_agentd.conf -OutFile C:\Zabbix\zabbix_agentd.conf #Laster ned conf fil


.\zabbix_agentd.exe -c .\zabbix_agentd.conf -i #Installerer


.\zabbix_agentd.exe --start #starte tjeneste.


