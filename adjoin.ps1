$name=$args[0]

Rename-Computer -NewName $name

Set-DnsClientServerAddress "tap*" -ServerAddresses ("192.168.0.203", "8.8.8.8")

$dc = "mysil.local" 
$pw = "Cisco123!" | ConvertTo-SecureString -asPlainText -force
$usr ="$dc\Administrator"
$creds = New-Object System.Management.Automation.PSCredential($usr,$pw)
Add-Computer -DomainName $dc -Credential $creds -force -verbose
