Configuration FormatDrives {

    param
    (        
        [Parameter()]
        [int]
        $RetryCount = 20,
        
        [Parameter()]
        [int]
        $RetryIntervalSec = 30,

        [Parameter()]
        [array]
        $driveLetters = @('L','M','N','R','T','V')
    )

    # Import the module that contains the resources we're using.
    Import-DscResource -ModuleName xStorage
  
    $disks = Get-Disk | Where-Object {$_.Model -match "Virtual Disk"}
    if ($disks.count -eq $driveLetters.count)
    {    
        Node 'localhost' {
     
            foreach ($disk in $disks)
            {        
                $diskId = $disk.UniqueId
                
                xWaitforDisk $diskId
                {
                    DiskId = $disk.Number
                    RetryIntervalSec =$RetryIntervalSec
                    RetryCount = $RetryCount
                }
         
                xDisk $diskId
                {
                    DiskId  = $disk.number
                    DriveLetter = $driveLetters[$disk.number-2]
                    DependsOn   = "[xWaitForDisk]$diskId"
                }
         
                xWaitForVolume $diskId
                {
                    DriveLetter = $driveLetters[$disk.number-2]
                    RetryIntervalSec =$RetryIntervalSec
                    RetryCount  = $RetryCount
                }
            }
        }
    }    
}
