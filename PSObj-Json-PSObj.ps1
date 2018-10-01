#Create Json from Powershell (hashtable)
$searchBody = @{
  "query" = @{
    "match_all" = @{}
  }
  "sort" = @{
    "errorcode" = "desc"
  }
  "size" = 100
} | ConvertTo-Json
#If you want arrays in Json, you use @()

#Create PSObject from Json
$PSObj = @'
{
  "query": {"match_all": {} },
  "sort":  {"errorcode":  "desc"},
  "size":  100
}
'@
$PSObj | ConvertFrom-Json

#Convert PSObject to Json
$PSObj | ConvertTo-Json

#Convert Json to PSObject and back to Json
$searchBody | ConvertFrom-Json | ConvertTo-Json

#Now you know how to use Json
#Either by building it from PowerShell or building it from raw JSON data
#But also how to convert it from and to with cmdlets ConvertFrom-Json and ConvertTo-Json
