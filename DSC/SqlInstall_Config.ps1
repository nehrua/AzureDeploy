Configuration SQLInstall
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $SqlInstallCredential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $SqlAdministratorCredential = $SqlInstallCredential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $SqlServiceCredential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $SqlAgentServiceCredential = $SqlServiceCredential
    )

    Add-LocalGroupMember -Member '<enter sql install username>' -Group Administrators

    Import-DscResource -ModuleName 'SqlServerDsc', 'PSDesiredStateConfiguration'

    node localhost
    {
        # # secure Credential
        # User SQLInstallUser
        # {
        #     UserName = $SqlInstallCredential.UserName
        #     Password = $sqlinstallcredential.Password
        #     disabled = $false
        #     ensure = 'Present'
        #     Fullname = 'SQL Install Acct'
        #     Description = 'SQL Install Acct'
        #     passwordneverExpires = $true
        # }

        #region Install prerequisites for SQL Server
        WindowsFeature 'NetFramework35'
        {
            Name   = 'NET-Framework-Core'
            Ensure = 'Present'
        }

        WindowsFeature 'NetFramework45'
        {
            Name   = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }
        #endregion Install prerequisites for SQL Server 

        #region Install SQL Server
        SqlSetup 'InstallNamedInstance-INST2016'
        {
            InstanceName          = 'SRPINSTANCE'
            Features              = 'SQLENGINE'
            SQLCollation          = 'SQL_Latin1_General_CP1_CI_AS'
            SQLSvcAccount         = $SqlInstallCredential
            AgtSvcAccount         = $SqlInstallCredential
            ASSvcAccount          = $SqlServiceCredential
            SQLSysAdminAccounts   = $SqlInstallCredential.UserName
            InstallSharedDir      = 'R:\Program Files\Microsoft SQL Server'
            InstallSharedWOWDir   = 'R:\Program Files (x86)\Microsoft SQL Server'
            InstanceDir           = 'R:\Program Files\Microsoft SQL Server'
            InstallSQLDataDir     = 'M:\Program Files\Microsoft SQL Server\MSSQL13.INST2016\MSSQL\Data'
            SQLUserDBDir          = 'N:\Program Files\Microsoft SQL Server\MSSQL13.INST2016\MSSQL\Data'
            SQLUserDBLogDir       = 'L:\Program Files\Microsoft SQL Server\MSSQL13.INST2016\MSSQL\Logs'
            SQLTempDBDir          = 'T:\Program Files\Microsoft SQL Server\MSSQL13.INST2016\MSSQL\Data'
            SQLTempDBLogDir       = 'T:\Program Files\Microsoft SQL Server\MSSQL13.INST2016\MSSQL\Logs'
            SQLBackupDir          = 'V:\Program Files\Microsoft SQL Server\MSSQL13.INST2016\MSSQL\Backup'
            SourcePath            = '\\rtool\SoftwareShare\SQLSource'
            UpdateEnabled         = 'False'
            ForceReboot           = $true
            BrowserSvcStartupType = 'Automatic'

            PsDscRunAsCredential  = $SqlInstallCredential
            DependsOn             = '[WindowsFeature]NetFramework35', '[WindowsFeature]NetFramework45'
        }
        #endregion Install SQL Server
    }
}
