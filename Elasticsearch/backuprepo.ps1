#Prereqs:
# Add repo path to elasticsearch.yml
# Windows -> path.repo: ["d:\\esbackup"]
# Linux -> path.repo ["/mount/backups/esbackup"]
# Restart elasticsearch service

#Create backup/restore repository with PowerShell
$body = @{
    "type" = "fs"
    "settings" = @{
        "compress" = $true
        "location" = "D:\\ESBackup"
    }
}

$jsonbody = $body | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri 'http://127.0.0.1:9200/_snapshot/esbackup01' -ContentType 'application/json' -Body $jsonbody

#This line will remove the repo
Invoke-RestMethod -Method Delete -Uri 'http://localhost:9200/_snapshot/repositoryName'
