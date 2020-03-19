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

          Disk EVolume
          {
               DiskId         = 2
               DriveLetter    = 'F'
               PartitionStyle = 'GPT'
               FSLabel        = 'Data'
               DependsOn      = '[WaitForDisk]Disk2'
          }

          WaitForDisk Disk3
          {
               DiskId           = 3
               RetryIntervalSec = 60
               RetryCount       = 1
          }

          Disk FVolume
          {
               DiskId         = 3
               DriveLetter    = 'G'
               PartitionStyle = 'GPT'
               FSLabel        = 'Data'
               DependsOn      = '[WaitForDisk]Disk3'
          }
     }
}
