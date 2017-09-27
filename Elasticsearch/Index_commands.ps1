#Removing Index content

#Removing all filebeat content from elasticsearch
Invoke-WebRequest -Method Delete -Uri http://localhost:9200/filebeat-* -ContentType application/json

#Removing all winlogbeat content from elasticsearch
Invoke-WebRequest -Method Delete -Uri http://localhost:9200/winlogbeat-* -ContentType application/json

#PowerShell function that runs different _cat RESTful API calls
Function Get-ElasticSearchCat{
    param(
        [string]$Uri = 'http://127.0.0.1:9200/_cat',
        [ValidateSet('allCats','allocation','shards','master','nodes','tasks','indices','segments','segments','recovery','health','pending_tasks','aliases','thread_pool','plugins','fielddata','repositories','snapshots','templates')]$CatType = 'allCats',
        [switch]$HelpAdded
    )
    if($CatType -eq 'allCats'){ $fullUri = $Uri }
    else{
        $fullUri = "$Uri/$CatType"
        if($HelpAdded){ $fullUri = "$($fullUri)?help" }
        else{$fullUri = "$($fullUri)?v"}
    }

    try{ $response = Invoke-WebRequest -Uri $FullUri -Method Get -ContentType 'application/json' -ErrorAction Stop }
    catch{
        if($CatType -eq 'snapshots' -and $_.ErrorDetails.message -match "repository is missing"){
            Write-Warning "No snapshot repositories found"
        }
        else{
            $ErrorObj = ConvertFrom-Json -InputObject $_.ErrorDetails.message
            Write-Warning "Status: $($ErrorObj.status)"
            Write-Warning "Reason: $($ErrorObj.error.reason)"
        }
        break
    }
    $response.Content
}

#PowerShell function that runs different statistics/health RESTful API calls
Function Get-ElasticSearchStats{
    [CmdletBinding()]
    param (
        [string]$Uri = 'http://127.0.0.1:9200',
        [ValidateSet('stats','nodes','nodesstatsjvmhttp','clusterstats','clusterhealth','winlogbeatindexresultinfo','pendingTasks')]$StatisticsType = 'stats'
    )
    #https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-stats.html
    #https://www.datadoghq.com/blog/collect-elasticsearch-metrics/#node-stats-api

    if($StatisticsType -eq 'stats'){ [Uri]$FullUri = "$Uri/_stats" }
    if($StatisticsType -eq 'nodes'){ [Uri]$FullUri = "$Uri/_nodes/stats" }
    if($StatisticsType -eq 'nodesstatsjvmhttp'){ [Uri]$FullUri = "$Uri/_nodes/stats/jvm,http" }
    if($StatisticsType -eq 'clusterstats'){ [Uri]$FullUri = "$Uri/_cluster/stats" }
    if($StatisticsType -eq 'clusterhealth'){ [Uri]$FullUri = "$Uri/_cluster/health" }
    if($StatisticsType -eq 'winlogbeatindexresultinfo'){ [Uri]$FullUri = "$Uri/winlogbeat-*/_search" }
    if($StatisticsType -eq 'pendingTasks'){
        [Uri]$FullUri = "$Uri/_cluster/pending_tasks"
        Write-Verbose "If all is well, you’ll receive an empty list"
        #Otherwise, you’ll receive information about each pending task’s priority, how 
        #long it has been waiting in the queue, and what action it represents.
    }

    $response = Invoke-WebRequest -Uri $FullUri -Method Get -ContentType 'application/json'
    ConvertFrom-Json -InputObject $response.Content
}

#PowerShell function that retrieves ES index, with regexfilter support
 Function Get-ElasticSearchIndex {
    param (
        $ElasticSearchUri = 'http://localhost:9200',
        $Filter,
        [switch]$IncludeKibanaIndex
    )

    $output = Invoke-WebRequest -Method Get -Uri "${ElasticSearchUri}/_cat/indices?v=pretty" -ContentType application/json
    $output = $output.Content.Split("`n")
    if(!($IncludeKibanaIndex)){ $output = $output | Where {$_ -ne ".kibana"} }
    
    if($Filter){ $output | Where {$_ -match $Filter} }
    else{$output}
} 
