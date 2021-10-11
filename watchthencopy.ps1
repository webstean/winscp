# Set path to winscp 0
$assemblyPath = "C:\Program Files (x86)\WinSCP"
Add-Type -Path (Join-Path $assemblyPath "WinSCPnet.dll")

# Setup session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
  Protocol = [WinSCP.Protocol]::Scp
  HostName = "hostname"
  UserName = "username"
  Password = "passwd"
  SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx"
}

# Destinatoon for file
# $remotePath = "/remotefilegoeshere"
$remotePath = "/"

$session = New-Object WinSCP.Session

try {
    # Connect
    $session.Open($sessionOptions)
    # Upload files, collect results
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

    $transferResult =
    $session.PutFiles($filepath, $remotePath, $False, $transferOptions)

    # Throw on any error
    $transferResult.Check()

    # Print results
    foreach ($transfer in $transferResult.Transfers) {
          Write-Host "Upload of $($transfer.FileName) succeeded"
    }
}
  
finally {
  # Disconnect, clean up
  $session.Dispose()
}

exit 0
  }#end of first try 

catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}

}

}#end of action

# keep running forever
# while ($true) {sleep 5}
