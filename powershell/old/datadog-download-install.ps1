# Start-Process -Wait msiexec -ArgumentList '/qn /i datadog-agent-7-latest.amd64.msi APIKEY="xxxxxxxxxxxxxxxxxx" SITE="datadoghq.com"'

# URL and temporary staging folder
$url = "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi"
$dest = "c:\temp\datadog"

# Test if $dest folder exists
$dest
"Test to see if folder [$dest]  exists"
if (Test-Path -Path $dest ) {
    Write-Host "Path exists!"
}
else {
    Write-Host "Path doesn't exist, creating it..."
    New-Item $dest -ItemType Directory
}

# Download file
Write-Output "Starting Download..."

Write-Output "Downloading [$url] to [$dest]"
Start-BitsTransfer -Source $url -Destination $dest -RetryTimeout 60 -RetryCount 3 -Confirm
