Configuration FormatDrives
{
     param
     (
          [Parameter()]
          [ValidateSet('Number', 'UniqueId', 'Guid', 'Location')]
          [System.String]
          $DiskIdType = 'Number',

          [Parameter()]
          [ValidateSet('GPT', 'MBR')]
          [System.String]
          $PartitionStyle = 'GPT',

          [Parameter()]
          [System.UInt64]
          $Size,

          [Parameter()]
          [System.String]
          $FSLabel,

          [Parameter()]
          [System.UInt32]
          $AllocationUnitSize,

          [Parameter()]
          [ValidateSet('NTFS', 'ReFS')]
          [System.String]
          $FSFormat = 'NTFS',

          [Parameter()]
          [System.Boolean]
          $AllowDestructive,

          [Parameter()]
          [System.Boolean]
          $ClearDisk
     )
    
     Import-DSCResource -ModuleName StorageDsc

     Node localhost
     {
          WaitForDisk Disk2
          {
               DiskId           = 2
               RetryIntervalSec = 60
               RetryCount       = 1
          }

          Disk LVolume
          {
               DiskId         = 2
               DriveLetter    = 'L'
               PartitionStyle = 'GPT'
               FSLabel        = 'Logs'
               DependsOn      = '[WaitForDisk]Disk2'
          }

          WaitForDisk Disk3
          {
               DiskId           = 3
               RetryIntervalSec = 60
               RetryCount       = 1
          }

          Disk MVolume
          {
               DiskId         = 3
               DriveLetter    = 'M'
               PartitionStyle = 'GPT'
               FSLabel        = 'Data'
               DependsOn      = '[WaitForDisk]Disk3'
          }

          WaitForDisk Disk4
          {
               DiskId           = 4
               RetryIntervalSec = 60
               RetryCount       = 2
          }

          Disk NVolume
          {
               DiskId         = 4
               DriveLetter    = 'N'
               PartitionStyle = 'GPT'
               FSLabel        = 'Data'
               DependsOn      = '[WaitForDisk]Disk4'
          }

          WaitForDisk Disk5
          {
               DiskId           = 5
               RetryIntervalSec = 60
               RetryCount       = 2
          }

          Disk RVolume
          {
               DiskId         = 5
               DriveLetter    = 'R'
               PartitionStyle = 'GPT'
               FSLabel        = 'Root_System'
               DependsOn      = '[WaitForDisk]Disk5'
          }

          WaitForDisk Disk6
          {
               DiskId           = 6
               RetryIntervalSec = 60
               RetryCount       = 2
          }

          Disk TVolume
          {
               DiskId         = 6
               DriveLetter    = 'T'
               PartitionStyle = 'GPT'
               FSLabel        = 'TempDB'
               DependsOn      = '[WaitForDisk]Disk6'
          }

          WaitForDisk Disk7
          {
               DiskId           = 7
               RetryIntervalSec = 60
               RetryCount       = 2
          }

          Disk VVolume
          {
               DiskId         = 7
               DriveLetter    = 'V'
               PartitionStyle = 'GPT'
               FSLabel        = 'Backups'
               DependsOn      = '[WaitForDisk]Disk7'
          }
     }
}
