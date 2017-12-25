#Removing Indices

#Removing all filebeat content from elasticsearch
Invoke-WebRequest -Method Delete -Uri http://localhost:9200/filebeat-* -ContentType application/json

#Removing all winlogbeat content from elasticsearch
Invoke-WebRequest -Method Delete -Uri http://localhost:9200/winlogbeat-* -ContentType application/json
