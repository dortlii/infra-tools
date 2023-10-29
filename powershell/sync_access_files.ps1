# path vars
$sourceFrontendPath = "C:\App\Frontend.mdb"
$sourceBackendPath = "C:\App\Backend.mdb"

$destinationFrontendPath = "D:\App\Frontend.mdb"
$destinationBackendPath = "D:\App\Backend.mdb"

# Path to the log file
$logFilePath = "C:\SyncLog.txt"

# Function to check and copy the newer file with logging
function CheckAndCopy($source, $destination) {
    if (Test-Path $source -and Test-Path $destination) {
        $sourceVersion = [System.IO.File]::GetLastWriteTime($source)
        $destinationVersion = [System.IO.File]::GetLastWriteTime($destination)

        if ($sourceVersion -gt $destinationVersion) {
            $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Copying $source to $destination"
            Write-Host $logEntry
            Add-Content -Path $logFilePath -Value $logEntry
            Copy-Item $source $destination -Force
        } else {
            $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $source is not newer than $destination. No action required."
            Write-Host $logEntry
            Add-Content -Path $logFilePath -Value $logEntry
        }
    } else {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - One of the files does not exist. Check and copy cannot be performed."
        Write-Host $logEntry
        Add-Content -Path $logFilePath -Value $logEntry
    }
}

# Check and copy Frontend files
CheckAndCopy $sourceFrontendPath $destinationFrontendPath

# Check and copy Backend files
CheckAndCopy $sourceBackendPath $destinationBackendPath
