Configuration IISInstall 
{
    # Import the module that contains the resources we're using.
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    node localhost
    {
        WindowsFeature IIS {
            Ensure = "Present"
            Name   = "Web-Server"
        }
         
        WindowsFeature Management {
            Name      = 'Web-Mgmt-Console'
            Ensure    = 'Present'
            DependsOn = @('[WindowsFeature]IIS')
        }
    }
}
