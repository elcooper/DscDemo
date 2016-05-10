
Configuration MySampleConfig {
 
    $OIPackageLocalPath = "C:\MMASetup-AMD64.exe"

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

   
    Node "managedwebserver" {
        
        #Ensure that IIS is present  
        WindowsFeature IIS {
                Ensure="Present"
                Name= "Web-Server"
        }

        #Create two files and validate the content of the files 
	    File MyFile {
                DestinationPath = "C:\MyFile.txt"
                Contents = "Hello World"
        }

        File MyOtherFile {
            DestinationPath = "C:\MyOtherFile.txt"
            Contents = "Goodbye World"
        }

        #Validate that MMA Agent is installed, running & sending data to Log Analytics
        Service OIService
        {
            Name = "HealthService"
            State = "Running"
        }

        xRemoteFile OIPackage {
            Uri = "https://opsinsight.blob.core.windows.net/publicfiles/MMASetup-AMD64.exe"
            DestinationPath = $OIPackageLocalPath
        }

        Package OI {
            Ensure = "Present"
            Path  = $OIPackageLocalPath
            Name = "Microsoft Monitoring Agent"
            ProductId = ""
            Arguments = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=0003933f-b5ab-4ac2-bafd-8bf588f88122 OPINSIGHTS_WORKSPACE_KEY=VZIb0JtqjLAVWizEcLqbGO+x0oK8poendQzy5SWdo466PEUvelBObwtLTtGcnogAqZ/C9ZuNbDuctQ4LRa1fdw== AcceptEndUserLicenseAgreement=1"'
            DependsOn = "[xRemoteFile]OIPackage"
        }

    }
} 