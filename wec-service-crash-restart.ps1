<## Set the name of the service you want to monitor and restart
$serviceName = "Windows Event Collector" #wec = Windows Event Collector 
#tst is Windows Push Notifications System Service

# Set the event ID that corresponds to service crashes
$eventID = 7034 #tst is 7040 (crash is 7034)
#>

# Set the log file path (don't forget to create the directory)
$logFilePath = "C:\Program Files\Seamless Intelligence\WEC Service Restart Script\logfile.txt"
#$logFilePath = "C:\temp\logfile.txt"

# Function to get current date/time for logging
function Get-CurrentDateTime {
    $currentDateTime = Get-Date
    $formattedDateTime = $currentDateTime.ToString("yyyy-MM-dd HH:mm:ss")
    return $formattedDateTime
}

# Function to start or to restart the specified service
function Restart-ServiceIfNeeded {
   param (
       [string]$ServiceName
   )

   Write-Output "[$(Get-CurrentDateTime)] Detected a WEC service crash. Checking the service status."

   $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
   if ($service -eq $null) {
       Write-Output "[$(Get-CurrentDateTime)] Service $ServiceName not found."
       return
   }

   if ($service.Status -eq "Running") {
       Write-Output "[$(Get-CurrentDateTime)] Restarting service $ServiceName..."
       try {
           Restart-Service -Name $ServiceName -Force
           Write-Output "[$(Get-CurrentDateTime)] Service $ServiceName restarted successfully."
       }
       catch {
           Write-Output "[$(Get-CurrentDateTime)] Failed to restart service $ServiceName. $_"
       }
   }
   if ($service.Status -eq "Stopped") {
       Write-Output "[$(Get-CurrentDateTime)] Attempting to start the service $ServiceName..."
       try {
           Start-Service -Name $ServiceName
           Write-Output "[$(Get-CurrentDateTime)] Service $ServiceName started successfully."
       }
       catch {
           Write-Output "[$(Get-CurrentDateTime)] Failed to start service $ServiceName. $_"
       }
   }
}

Restart-ServiceIfNeeded $serviceName | Out-File -FilePath $logFilePath -Append

# Function to monitor the event log
<#function Monitor-EventLog {
   param (
       [int]$EventID,
       [string]$ServiceName
   )
   $utcDate = (Get-Date).AddHours(-8).AddSeconds(-33)
   $utcDate = $utcDate.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

   $query = @"
<QueryList>
<Query Id="0" Path="System">
<Select Path="System">
         *[System[TimeCreated[@SystemTime >= '$utcDate']]]
         and
         *[System[EventID=$EventID]]
         and
         *[EventData[Data[@Name='param1'] and (Data='$ServiceName')]]
</Select>
</Query>
</QueryList>
"@

   $eventLog = Get-WinEvent -FilterXml $query -ErrorAction SilentlyContinue

   if ($eventLog -ne $null) {
       foreach ($event in $eventLog) {
           $timeStamp = $event.TimeCreated
           Write-Output "[$(Get-CurrentDateTime)] Detected service crash at $timeStamp."
           Restart-ServiceIfNeeded -ServiceName $ServiceName
       }
   }
   else {
       Write-Output "[$(Get-CurrentDateTime)] No service crash events found in the event log."
   }
}
#>
# Start monitoring the event log and write the output to the log file
<#Write-Output "[$(Get-CurrentDateTime)] Monitoring for service crashes (Event ID: $eventID)..."
while ($true) {
   Monitor-EventLog -EventID $eventID -ServiceName $serviceName | Out-File -FilePath $logFilePath -Append 
   Start-Sleep -Seconds 30
}#>