# Source Directory to Monitor
$sourcePath = "C:\users\awebster\AppData\test\*.*"

# Setup session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
  Protocol = [WinSCP.Protocol]::scp
  HostName = "hostname"
  UserName = "username"
  Password = "passwd"
  SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx"
}

# Destination for file
# $remotePath = "/remotefilegoeshere"
$remotePath = "/"

# list of files
$sourceFiles = (Get-ChildItem -Recurse -Path $sourcePath -Include *.*).fullname

# sleep for 10 seconds - for any file to stabilise
while ($true) {sleep 5}

Add-Type -Path (Join-Path "WinSCPnet.dll")
$session = New-Object WinSCP.Session

try {
   # Connect
   $session.Open($sessionOptions)
   # Upload files, collect results
   $transferOptions = New-Object WinSCP.TransferOptions
   $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
    
   foreach($sourcefile in $sourcefiles) {
      Write-Host "Need to upload $sourcefile..."
      $transferResult = $session.PutFiles($sourcefile, $remotePath, $False, $transferOptions)
      # Throw on any error
      $transferResult.Check()
      # Print results
      foreach ($transfer in $transferResult.Transfers) {
          Write-Host "Upload of $($transfer.FileName) succeeded"
      }
   }
}
  
finally {
  # Disconnect, clean up
  $session.Dispose()
}

catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}

# keep running forever
# while ($true) {sleep 5}
