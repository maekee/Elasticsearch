#If you want to use winlogbeat and read in a channel (a named stream of events that transports events from an event source to an event log)
#e.g. "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"
#To get all available eventlogs and channels you can run this PowerShell one-liner:
Get-WinEvent -ListLog * | Select LogName
#or search with this:
Get-WinEvent -ListLog * | Where {$_.LogName -match "Iphlpsvc"} | Select LogName
