#If Logstash/filebeat is installed in windows you can check logfiles with Powershell
Get-Content -Path C:\Filebeat\logs\filebeat | Select -Last 20
Get-Content -Path C:\Winlogbeat\logs\winlogbeat | Select -Last 20
Get-Content -Path C:\Logstash\logs\logstash-plain.log | Select -Last 20

#When troubleshooting/developing logstash filters for filebeat i use these commands to generate new data:
#The path D:\LOGS in my case is where filebeat looks for new logs
Copy-Item "D:\templateLog.log" "D:\LOGS\NewLog_$(Get-Date -format "yyyy-MM-dd-HHmmss").log"

#If you want to use winlogbeat and read in a channel (a named stream of events that transports events from an event source to an event log)
#e.g. "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"
#To get all available eventlogs and channels you can run this PowerShell one-liner:
Get-WinEvent -ListLog * | Select LogName
#or search with this:
Get-WinEvent -ListLog * | Where {$_.LogName -match "Iphlpsvc"} | Select LogName
