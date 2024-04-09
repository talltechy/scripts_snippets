Function Download-File {
    Param(
      [string]$Comment,
      [string]$Url,
      [string]$Target
    )
  
    Write-Host "$Comment : downloading..."
  
    # We need to check that the target folder exists later
    $targetFolder = Split-Path -Parent $Target
  
    # Prepare cmdlet arguments for splatting
    $iwrArgs = @{
      UseBasicParsing = $true
      Uri             = $Url
      OutFile         = $Target
    }
  
    $newDirArgs = @{
      ItemType = 'Directory'
      Path     = $targetFolder
    }
  
    # Create the target parent dir, if it doesn't exist
    if ( !( Test-Path -PathType Container $targetFolder ) ) {
  
      Write-Host "Creating directory $targetFolder"
      New-Item @newDirArgs | Out-Null
    }
  
    # Workaround progress bar performance bug with Invoke-WebRequest
    # (also affects Invoke-RestMethod) by disabling it
    $OldProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
  
    # Use a try / finally block to guarantee the
    # original progress preference is changed back
    try {
  
      Invoke-WebRequest @iwrArgs -EA Stop
    }
    finally {
  
      $ProgressPreference = $OldProgressPreference
    }
  }