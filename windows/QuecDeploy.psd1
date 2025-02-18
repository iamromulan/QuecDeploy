@{
    Root = 'D:\Users\camer\Documents\GitHub\QuecDeploy\windows\QuecDeploy.ps1'
    OutputPath = 'D:\Users\camer\Documents\GitHub\QuecDeploy\windows\'
    Package = @{
        Enabled = $true
        Host = 'IronmanPowerShellHost'
        PowerShellVersion = "Windows PowerShell"
        Obfuscate = $true
        FileVersion = '1.0.4'
        FileDescription = 'Quickly deploy Quectel Tools/Firmware'
        ProductName = 'QuecDeploy_x64_1.0.4'
        ProductVersion = '1.0.3'
        Copyright = 'Cameron S Thompson'
        RequireElevation = $true
        ApplicationIconPath = 'D:\Users\camer\Documents\GitHub\QuecDeploy\windows\FenixStar.ico'
        PackageType = 'Console'
        Platform = 'x64'
    }
    Bundle = @{
        Enabled = $true
        Modules = $true
    }
}
