# Check if running as Administrator; request elevation if not
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Log "Requesting administrative privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Add assembly for System.Windows.Forms to access screen properties
Add-Type -AssemblyName System.Windows.Forms

# Base64 encoded string of the megatools.exe
# Megatools 1.11.1 from https://megatools.megous.com/ was used. Thank you @megous
$megatoolsBase64 = @"
[BASE64_CONTENT_PLACEHOLDER]
"@

# Function to decode Base64 string and write to file
Function Decode-Base64ToFile {
    param (
        [string]$Base64String,
        [string]$OutputFilePath
    )
    [System.IO.File]::WriteAllBytes($OutputFilePath, [System.Convert]::FromBase64String($Base64String))
}

# Decode and save megatools.exe to a temporary location
$megatoolsPath = "$env:TEMP\megatools.exe"
Decode-Base64ToFile -Base64String $megatoolsBase64 -OutputFilePath $megatoolsPath

# Function to set console window size and position
Function Set-ConsoleSizeAndPosition {
    param (
        [int]$width = 75,
        [int]$height = [console]::LargestWindowHeight
    )
    $host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size($width, $height)
    $consolePtr = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle

    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class User32 {
            [DllImport("user32.dll", SetLastError = true)]
            public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
        }
"@
    [User32]::MoveWindow($consolePtr, 0, -20, $host.UI.RawUI.WindowSize.Width * 8, $host.UI.RawUI.WindowSize.Height * 14, $true)
}

# Set the console size and position
Set-ConsoleSizeAndPosition -width 150 -height ([console]::LargestWindowHeight)

# Set console background color to black and text color to white
[console]::BackgroundColor = "Black"
[console]::ForegroundColor = "White"

# Function to set console window size
Function Set-ConsoleSize {
    param (
        [int]$width = 120,
        [int]$height = 40
    )
    $host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size ($width, $height)
}

# Set the console size to fit the longest line and maximum height of the console
Set-ConsoleSize -width 75 -height ([console]::LargestWindowHeight)

# Clear the screen to apply the color changes
Clear-Host

# Function to write to log
Function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "C:\Quectel\pslog.txt" -Value "$timestamp - $message"
}

# Set the working directory to the location of the script
Set-Location -Path (Get-Location)

# Function to download a file
Function Download-File {
    param (
        [string]$url,
        [string]$output
    )
    Write-Log "Downloading $url ..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Log "Downloaded $url to $output"
    } catch {
        Write-Log "ERROR: Failed to download $url"
    }
}

# Function to download with Megatools
Function Download-With-Megatools {
    param (
        [string]$url,
        [string]$output
    )
    Write-Log "Using Megatools to download $url ..."
    if (-Not (Test-Path -Path $megatoolsPath)) {
        Write-Log "ERROR: Megatools executable not found at $megatoolsPath"
        return
    }
    $cmd = "& `"$megatoolsPath`" dl --path `"$output`" `"$url`""
    try {
        Invoke-Expression $cmd
        Write-Log "Downloaded $url to $output with Megatools"
    } catch {
        Write-Log "ERROR: Failed to download $url with Megatools."
    }
}

# Function to extract a ZIP file
Function Extract-Zip {
    param (
        [string]$zipPath,
        [string]$extractPath
    )
    Write-Log "Extracting * from $zipPath to $extractPath ..."
    try {
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
        Write-Log "Extracted * to $extractPath"
    } catch {
        Write-Log "ERROR: Failed to extract $zipPath"
    }
}

# Set the PATH variable
$env:Path += ";$PSScriptRoot"
Write-Log "Set PATH variable to include current directory."

# Create the C:\Quectel directory if it does not exist
$quectelDir = "C:\Quectel"
If (-Not (Test-Path -Path $quectelDir)) {
    Write-Log "Creating C:\Quectel directory..."
    New-Item -Path $quectelDir -ItemType Directory
}

# List of available colors
$colors = @("Blue", "Green", "Cyan", "Red", "Magenta", "Yellow")

# Function to write text in a random color
Function Write-RandomColorText {
    param (
        [string]$text
    )
    
    # Select a random color from the list
    $randomColor = Get-Random -InputObject $colors
    
    # Write the text with the random color
    Write-Host $text -ForegroundColor $randomColor
}

# Main Menu
Function Start-Menu {
    Write-Log "Displaying Start Menu."
    cls
Write-Host "                           .%+:                             "
Write-Host "                             .*@@@-.                        "
Write-Host "                                  :@@@@-                    "
Write-Host "                                     @@@@#.                 "
Write-Host "                                      -@@@@#.               "
Write-Host "       :.                               %@@@@: -#           "
Write-Host "      .+-                                #@@@@%.+@-         "
Write-Host "      .#- .                               +@@@@# #@-        "
Write-Host "    -@*@*@%                                @@@@@::@@=       "
Write-Host ".+%@@@@@@@@@%=.                            =@@@@# #@@- ..   "
Write-Host "    .@@@@@:                                :@@@@@ =@@@..%=  "
Write-Host "    -::@-.+.                                @@@@@.=@@@- =@- "
Write-Host "      .@-                                  .@@@@@:.@@@*  @@."
Write-Host "      .%-                                  -@@@@@:=@@@@  @@#"
Write-Host "      .#-         .%@@@@@@#.               +@@@@@.#@@@@  @@@"
Write-Host "      .*-            .@@@@@@@@@@=.         @@@@@@ @@@@@  @@@"
Write-Host "       :.             .%@@@@@@@@@@@%.     .@@@@@+:@@@@@  @@@"
Write-Host "                        -@@@@@@@@@@@@@@@..@@@@@@.-@@@@@ .@@@"
Write-Host "                         -@@@@@@@@@@%.  .@@@@@@. @@@@@+ =@@@"
Write-Host "                           =@@@@@@@@*  .@@@@@@. @@@@@@..@@@@"
Write-Host "                            #@@@@@@@@-*@@@@@%..@@@@@@+ #@@@@"
Write-Host "                            @@@@@@:.-@@@@@@.  @@@@@@= %@@@@@"
Write-Host "                           .@@@@. *@@@@@@- .+@@@@@@-.@@@@@@+"
Write-Host "                           %@@. =@@@@@*.  +@@@@@@%.-@@@@@@% "
Write-Host "                          .@@ .@@@@@=  :@@@@@@@@..@@@@@@@=  "
Write-Host "                          =@.+@@@@@. -@@@@@@@*.:@@@@@@@*.   "
Write-Host "                          %.*@@@@= .@@@@@@@-.:@@@@@@@+.     "
Write-Host "                          ..@@@@= .@@@@@@: #@@@@@@@:        "
Write-Host "                           .@@@@  +@@@@..%@@@@@+.           "
Write-Host "                           .@@@.  @@@@.:@@@@+.              "
Write-Host "                            @@@.  @@@. @@@*    .@.          "
Write-Host "                            :@@@  %@@..@@#.    *@           "
Write-Host "                         -*: .@@* :@@. @@.  -..@@           "
Write-Host "                       =@@@@@@.*@- :@%  @* =@:=@#           "
Write-Host "                      .@@@-+@@@@:%@..%- ...@%:@@:           "
Write-Host "                      .@@.  @@-%@:      .%@@*@@%.           "
Write-Host "                       :@@ :+   *@     *@@#*@@@.            "
Write-Host "                                     =@@@.@@@@              "
Write-Host "                                  .*@@@:=@@@@:              "
Write-Host "                                .@@@@:.@@@@@:               "
Write-Host "                              .@@@@#.-@@@@@.                "
Write-Host "                             #@@@@: =@@@@@-                 "
Write-Host "                           .@@@@@..@@@@@@*                  "
Write-Host "                          -@@@@@. @@@@@@#.                  "
Write-Host "                         -@@@@@  @@@@@@%                    "
Write-Host "                         @@@@@. #@@@@@@.                    "
Write-Host "                        :@@@@# =@@@@@@%                     "
Write-Host "                        @@@@@: @@@@@@@:                     "
Write-Host "                        *@@@@  @@@@@@@.                     "
Write-Host "                        .@@@@  @@@@@@@                      "
Write-Host "                         #@@@. @@@@@@*                      "
Write-Host "                          @@@# @@@@@@@                      "
Write-Host "                           .@@+=@@@@@@.                     "
Write-Host "                                *@@@@@@                     "
Write-Host "                                 :@@@@@=                    "
Write-Host "                                  .@@@@@@.                  "
Write-Host "                                    :@@@@@*.                "
Write-Host "                                      .=@@@@@-              "
Write-Host "                                           :+##+.           "
    Write-Host "Welcome to iamromulan's Quectel Software Deployment Tool" -ForegroundColor Green
    Write-Host "Visit https://github.com/iamromulan/ for more" -ForegroundColor Green
	sleep 3
	cls
	Write-Host "=============================================================" -ForegroundColor Green
	Write-Host "Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Visit https://github.com/iamromulan/ for more" -ForegroundColor Green
    Write-Host "Please select an option:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Install/Uninstall Drivers"
    Write-RandomColorText "2) Install/Uninstall Qflash 7.3"
    Write-RandomColorText "3) Install/Uninstall Qnavigator 1.6.10"
    Write-RandomColorText "4) Firmware downloads"
    Write-RandomColorText "5) View AT Command Docs and other resources"
    Write-RandomColorText "6) Exit"
	Write-Host "=============================================================" -ForegroundColor Green
    $choice = Read-Host "Please select a choice"
    Switch ($choice) {
        1 { Install-Drivers-Menu }
        2 { Install-Qflash-Menu }
        3 { Install-Qnavigator-Menu }
        4 { Get-Firmware-Menu }
        5 { Get-Docs-Menu }
        6 { Exit-Tool }
        Default { Main-Menu }
    }
}

Function Main-Menu {
    Write-Log "Displaying Main Menu."
	cls
	Write-Host "=============================================================" -ForegroundColor Green
	Write-Host "Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Visit https://github.com/iamromulan/ for more" -ForegroundColor Green
    Write-Host "Please select an option:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Install/Uninstall Drivers"
    Write-RandomColorText "2) Install/Uninstall Qflash 7.3"
    Write-RandomColorText "3) Install/Uninstall Qnavigator 1.6.10"
    Write-RandomColorText "4) Firmware downloads"
    Write-RandomColorText "5) View AT Command Docs and other resources"
    Write-RandomColorText "6) Exit"
	Write-Host "=============================================================" -ForegroundColor Green
    $choice = Read-Host "Please select a choice"
    Switch ($choice) {
        1 { Install-Drivers-Menu }
        2 { Install-Qflash-Menu }
        3 { Install-Qnavigator-Menu }
        4 { Get-Firmware-Menu }
        5 { Get-Docs-Menu }
        6 { Exit-Tool }
        Default { Main-Menu }
    }
}

# Functions for each menu item
Function Install-Drivers-Menu {
    Write-Log "Displaying Install Drivers Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "It is recommended to install the NDIS and ECM drivers only"
    Write-Host "Bare minimum: Install the NDIS driver" -ForegroundColor Green
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Driver Options:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Install NDIS Driver 2.7 (For usb mode: AT+QCFG='usbnet',0)"
    Write-RandomColorText "2) Install ECM Driver 1.0 (For usb mode: AT+QCFG='usbnet',1) Note: NDIS driver needed for ports"
    Write-RandomColorText "3) Install MBIM Driver 1.3 (For usb mode: AT+QCFG='usbnet',2)"
    Write-RandomColorText "4) Install RNDIS Driver 1.1 (For usb mode: AT+QCFG='usbnet',3)"
    Write-RandomColorText "5) Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $driverChoice = Read-Host "Select a driver option"
    Switch ($driverChoice) {
        1 { Install-Driver -url "https://mega.nz/file/zJd1CYbL#OuzK4SaghBZuQ_RLstw--I38179sZM7TkkktL2IIsm4" -fileName "Quectel_Windows_USB_DriverQ_NDIS_V2.7_EN.zip" -setupExe "NDISsetup.exe" }
        2 { Install-Driver -url "https://mega.nz/file/7IEjESSB#5jj1v7F3WWVfy6cFzdvfCHxaoTENMgBW2v_94NtgpoA" -fileName "Quectel_Windows_USB_DriverQ_ECM_V1.0_EN.zip" -setupExe "ECMsetup.exe" }
        3 { Install-Driver -url "https://mega.nz/file/XRc0nZSQ#9hPjcrasgOQ9ej_tWQhvC6_NQC3iZMIdu0t17sz7AHE" -fileName "Quectel_Windows_USB_DriverQ_MBIM_V1.3_EN.zip" -setupExe "MBIMsetup.exe" }
        4 { Install-Driver -url "https://mega.nz/file/vRN1ERaL#0zp9di4iFEaamkczsmw_Xaxr3fcWS7in9ODXZ73l8Lg" -fileName "Quectel_Windows_USB_DriverQ_RNDIS_V1.1_EN.zip" -setupExe "RNDISsetup.exe" }
        5 { Main-Menu }
        Default { Install-Drivers-Menu }
    }
}

Function Install-Driver {
    param (
        [string]$url,
        [string]$fileName,
        [string]$setupExe
    )
    Write-Log "Using Megatools to download $url ..."
    $outputDir = "C:\Quectel"
    $outputFile = Join-Path -Path $outputDir -ChildPath $fileName
    Download-With-Megatools -url $url -output $outputDir
    Write-Log "Extracting $setupExe from $outputFile to $outputDir ..."
    try {
        Expand-Archive -Path $outputFile -DestinationPath $outputDir -Force
        Write-Log "Extracted $setupExe to $outputDir"
        Start-Process -FilePath (Join-Path -Path $outputDir -ChildPath $setupExe) -Wait
        Write-Log "Installation process completed for $setupExe"
        Remove-Item -Path $outputFile -Force
        Write-Log "Deleted $outputFile"
    } catch {
        Write-Log "ERROR: Failed to extract or install $fileName"
    }
    Remove-Item -Path (Join-Path -Path $outputDir -ChildPath $setupExe) -Force
    Install-Drivers-Menu
}

Function Install-Qflash-Menu {
    Write-Log "Displaying Qflash Installation Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Qflash Installation:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Install Qflash 7.3"
    Write-RandomColorText "2) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $qflashChoice = Read-Host "Select an option"
    Switch ($qflashChoice) {
        1 {
            $qflashDir = "C:\Quectel\Qflash\"
            $qflashZipUrl = "https://mega.nz/file/6FlRkAaY#nLnnwFKNRDE3DJhX7tBIGPUYQxmNAvAO1BFrYEZGAK4"
            $qflashZipName = "QFlash_V7.3.zip"
            Install-QflashVersion -url $qflashZipUrl -zipName $qflashZipName -installDir $qflashDir
        }
        2 { Main-Menu }
        Default { Install-Qflash-Menu }
    }
}

Function Install-QflashVersion {
    param (
        [string]$url,
        [string]$zipName,
        [string]$installDir
    )
    If (Test-Path -Path $installDir) {
        $existingVersion = Get-ChildItem -Path $installDir -Filter "QFlash*.exe" | Select-Object -First 1
        If ($existingVersion) {
            $versionInstalled = $existingVersion.BaseName -replace "^QFlash_", ""
            Write-Log "Qflash $versionInstalled is already installed."
            $confirm = Read-Host "Do you want to uninstall it and install the new version? (Y/N)"
            If ($confirm -ne "Y") {
                Write-Host "Please uninstall the current version before proceeding." -ForegroundColor Red
				sleep 2
                Main-Menu
                return
            } Else {
                Write-Log "Uninstalling Qflash $versionInstalled..."
                Remove-Item -Path $installDir -Recurse -Force
                $desktopShortcut = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('CommonDesktopDirectory'), "QFlash $versionInstalled.lnk")
                $startMenuShortcut = [System.IO.Path]::Combine($env:PROGRAMDATA, 'Microsoft\Windows\Start Menu\Programs', "QFlash $versionInstalled.lnk")
                If (Test-Path $desktopShortcut) { Remove-Item -Path $desktopShortcut -Force }
                If (Test-Path $startMenuShortcut) { Remove-Item -Path $startMenuShortcut -Force }
            }
        }
    }
    Write-Log "Installing Qflash 7.3..."
    New-Item -Path $installDir -ItemType Directory -Force
    Download-With-Megatools -url $url -output $installDir
    Extract-Zip -zipPath (Join-Path -Path $installDir -ChildPath $zipName) -extractPath $installDir
    Remove-Item -Path (Join-Path -Path $installDir -ChildPath $zipName) -Force
    Write-Log "Qflash installed to $installDir"

    # Add platform-tools to PATH
    Write-Log "Enabling adb and fastboot from PATH..."
    $platformToolsPath = "$installDir\platform-tools"
    If (-Not ($env:Path -contains $platformToolsPath)) {
        [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$platformToolsPath", [System.EnvironmentVariableTarget]::Machine)
    }

    # Create shortcuts
    $desktopShortcut = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('CommonDesktopDirectory'), "QFlash 7.3.lnk")
    $startMenuShortcut = [System.IO.Path]::Combine($env:PROGRAMDATA, 'Microsoft\Windows\Start Menu\Programs', "QFlash 7.3.lnk")
    $ws = New-Object -ComObject WScript.Shell
    $s = $ws.CreateShortcut($desktopShortcut)
    $s.TargetPath = "$installDir\QFlash_V7.3.exe"
    $s.WorkingDirectory = $installDir
    $s.Save()

    $s = $ws.CreateShortcut($startMenuShortcut)
    $s.TargetPath = "$installDir\QFlash_V7.3.exe"
    $s.WorkingDirectory = $installDir
    $s.Save()

    Main-Menu
}

Function Install-Qnavigator-Menu {
    Write-Log "Displaying Qnavigator Installation Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Qnavigator Installation:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Install Qnavigator 1.6.10"
    Write-RandomColorText "2) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $qnavigatorChoice = Read-Host "Select an option"
    Switch ($qnavigatorChoice) {
        1 {
            $qnavigatorDir = "C:\Quectel\Qnavigator\"
            $qnavigatorZipUrl = "https://mega.nz/file/2RMFAbCT#zq3r9TmEF8REXK6PkuAXFiuyPI5Tw4oqYnHGEiSmoD4"
            $qnavigatorZipName = "Qnavigator_V1.6.10.zip"
            Install-QnavigatorVersion -url $qnavigatorZipUrl -zipName $qnavigatorZipName -installDir $qnavigatorDir
        }
        2 { Main-Menu }
        Default { Install-Qnavigator-Menu }
    }
}

Function Install-QnavigatorVersion {
    param (
        [string]$url,
        [string]$zipName,
        [string]$installDir
    )
    If (Test-Path -Path $installDir) {
        $existingVersion = Get-ChildItem -Path $installDir -Filter "Qnavigator.exe" | Select-Object -First 1
        If ($existingVersion) {
            Write-Log "Qnavigator is already installed."
            $confirm = Read-Host "Do you want to uninstall it and install the new version? (Y/N)"
            If ($confirm -ne "Y") {
                Write-Host "Please uninstall the current version before proceeding."
                Main-Menu
                return
            } Else {
                Write-Log "Uninstalling Qnavigator..."
                Remove-Item -Path $installDir -Recurse -Force
                $desktopShortcut = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('CommonDesktopDirectory'), "Qnavigator.lnk")
                $startMenuShortcut = [System.IO.Path]::Combine($env:PROGRAMDATA, 'Microsoft\Windows\Start Menu\Programs', "Qnavigator.lnk")
                If (Test-Path $desktopShortcut) { Remove-Item -Path $desktopShortcut -Force }
                If (Test-Path $startMenuShortcut) { Remove-Item -Path $startMenuShortcut -Force }
            }
        }
    }
    Write-Log "Installing Qnavigator 1.6.10..."
    New-Item -Path $installDir -ItemType Directory -Force
    Download-With-Megatools -url $url -output $installDir
    Extract-Zip -zipPath (Join-Path -Path $installDir -ChildPath $zipName) -extractPath $installDir
    Remove-Item -Path (Join-Path -Path $installDir -ChildPath $zipName) -Force
    Write-Log "Qnavigator installed to $installDir"

    # Create shortcuts
    $desktopShortcut = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('CommonDesktopDirectory'), "Qnavigator.lnk")
    $startMenuShortcut = [System.IO.Path]::Combine($env:PROGRAMDATA, 'Microsoft\Windows\Start Menu\Programs', "Qnavigator.lnk")
    $ws = New-Object -ComObject WScript.Shell
    $s = $ws.CreateShortcut($desktopShortcut)
    $s.TargetPath = "$installDir\Qnavigator.exe"
    $s.WorkingDirectory = $installDir
    $s.Save()

    $s = $ws.CreateShortcut($startMenuShortcut)
    $s.TargetPath = "$installDir\Qnavigator.exe"
    $s.WorkingDirectory = $installDir
    $s.Save()

    Main-Menu
}

Function Download-Firmware {
    param (
        [string]$url,
        [string]$fileName,
        [string]$type
    )
    $model = $global:model  # Using global variable for model name
    $firmwareDir = "$quectelDir\firmware\$model\$type"
    $filePath = "$firmwareDir\$fileName"
    
    # Create the necessary directory
    If (-Not (Test-Path -Path $firmwareDir)) {
        New-Item -Path $firmwareDir -ItemType Directory -Force
    }

    # Download the firmware using Megatools
    Try {
        Write-Log "Using Megatools to download $url ..."
        & "$megatoolsPath" dl --path "$filePath" $url
        Write-Log "Downloaded $url to $filePath with Megatools"

        # Create a unique subfolder for this firmware
        $firmwareSubDir = Join-Path $firmwareDir -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($fileName))
        If (-Not (Test-Path -Path $firmwareSubDir)) {
            New-Item -Path $firmwareSubDir -ItemType Directory -Force
        }

        # Extract the downloaded file to the subfolder
        Write-Log "Extracting * from $filePath to $firmwareSubDir ..."
        Expand-Archive -Path $filePath -DestinationPath $firmwareSubDir -Force
        Write-Log "Extracted * to $firmwareSubDir"

        # Delete the zip file after extraction
        Remove-Item -Path $filePath -Force
        Write-Log "Deleted $filePath"
        Write-Host "Firmware Download Complete" -ForegroundColor Green
        Write-Host "Firmware is saved to $firmwareSubDir" -ForegroundColor Green
        sleep 3

    } Catch {
        Write-Log "ERROR: Failed to download or extract $fileName"
        Write-Host "Firmware Download Failed" -ForegroundColor Red
        sleep 5
    }

    Get-Firmware-Menu
}


Function Get-Firmware-Menu {
    Write-Log "Displaying Firmware Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Select the modem model"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) RM520N-GL"
    Write-RandomColorText "2) RM521F-GL"
    Write-RandomColorText "3) RM502Q-AE"
    Write-RandomColorText "4) RM551E-GL"
    Write-RandomColorText "5) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select firmware type"
    Switch ($firmwareChoice) {
        1 { $global:model = "RM520NGL"; Get-Firmware-RM520NGL-Menu }
        2 { $global:model = "RM521FGL"; Stock-Firmware-RM521FGL-Menu }
        3 { $global:model = "RM502QAE"; Stock-Firmware-RM502QAE-Menu }
        4 { $global:model = "RM551EGL"; Stock-Firmware-RM551EGL-Menu }
        5 { Main-Menu }
        Default { Get-Firmware-Menu }
    }
}

Function Get-Firmware-RM520NGL-Menu {
    Write-Log "Displaying Firmware for RM520N-GL Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Firmware Options:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Stock Firmware"
    Write-RandomColorText "2) Certified Firmware"
    Write-RandomColorText "3) Custom Firmware"
    Write-RandomColorText "4) Go back to Firmware Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select firmware type"
    Switch ($firmwareChoice) {
        1 { Stock-Firmware-RM520NGL-Menu }
        2 { Cert-Firmware-RM520NGL-Menu }
        3 { Custom-Firmware-RM520NGL-Menu }
        4 { Get-Firmware-Menu }
        Default { Get-Firmware-RM520NGL-Menu }
    }
}

Function Stock-Firmware-RM520NGL-Menu {
    Write-Log "Displaying Stock Firmware for RM520N-GL Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
	Write-Host "Stock Firmware:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "These options will download and extract a firmware zip with an update folder for use with Qflash"
    Write-Host "The .zips will extract to C:\Quectel\firmware\RM520NGL\Stock\<name_of_zip_without_extension>\" -ForegroundColor Green
	Write-Host "=============================================================" -ForegroundColor Green
	Write-RandomColorText "1) RM520NGLAAR01A08M4G (2025-01-08)"
    Write-RandomColorText "2) RM520NGLAAR01A08M4G (2024-10-09)"
    Write-RandomColorText "3) RM520NGLAAR01A08M4G (2024-06-20)"
    Write-RandomColorText "4) RM520NGLAAR01A08M4G (2024-04-03)"
    Write-RandomColorText "5) RM520NGLAAR01A08M4G (2024-02-01)"
    Write-RandomColorText "6) RM520NGLAAR01A08M4G (2023-07-20)"
    Write-RandomColorText "7) RM520NGLAAR01A07M4G (2023-07-12)"
    Write-RandomColorText "8) RM520NGLAAR01A07M4G (2023-03-27)"
    Write-RandomColorText "9) RM520NGLAAR01A06M4G (2023-01-20)"
    Write-RandomColorText "10) RM520NGLAAR01A06M4G (2022-12-26)"
    Write-RandomColorText "11) Go back to RM520N-GL Firmware options"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select a stock firmware"
    Switch ($firmwareChoice) {
	"1" { Download-Firmware "https://mega.nz/file/PItyjRaT#Mx3wkRsYcrZNjuvRj8c_qR-1W1swu6iYbcHPp39LCnc" "RM520NGLAAR01A08M4G_2025_01_08.zip" "Stock" }
	"2" { Download-Firmware "https://mega.nz/file/PMNkCLzR#MoLgG9mROATtL5LpYgFiroAudZMOOWCOAumYlPi1NFA" "RM520NGLAAR01A08M4G_2024_10_09.zip" "Stock" }
	"3" { Download-Firmware "https://mega.nz/file/eBVFhDhZ#1or8iMpmJiIKtZAPjo3rBTL2rit-pMFyZN10VSUzbgg" "RM520NGLAAR01A08M4G_2024_06_20.zip" "Stock" }
    "4" { Download-Firmware "https://mega.nz/file/ucclVCLT#chq0HzixUTPoNpG9G2duv5Xhj2JChz2ALa6QJpZJ3kY" "RM520NGLAAR01A08M4G_2024_04_03.zip" "Stock" }
    "5" { Download-Firmware "https://mega.nz/file/2NdzWKJJ#n4EbQkh17Pwfkfxzz-ZbjN5MFK6fJVRgLx6Chh43QRk" "RM520NGLAAR01A08M4G_2024_02_01.zip" "Stock" }
    "6" { Download-Firmware "https://mega.nz/file/SYMh0YwI#xLaLs8qeOMOmic1wHLROrZedZ3USmNzGrSkFddOiAzk" "RM520NGLAAR01A08M4G_2023_07_20.zip" "Stock" }
    "7" { Download-Firmware "https://mega.nz/file/zR011SQT#lPdFog6G_5RFdKCltnpGKrblvEFOiW-Ctumz72LNMns" "RM520NGLAAR01A07M4G_2023_07_12.zip" "Stock" }
    "8" { Download-Firmware "https://mega.nz/file/bFdVlJAB#-vDBJ4ywc4aM68ECG2Sef2i-5VuCHk-is05Y5HRyUJM" "RM520NGLAAR01A07M4G_2023_03_27.zip" "Stock" }
    "9" { Download-Firmware "https://mega.nz/file/TJ8m1QoB#V7Gt1KHpbQIw8J66wo07PMqamGjQK1uXfu1etbjENvs" "RM520NGLAAR01A06M4G_2023_01_20.zip" "Stock" }
    "10" { Download-Firmware "https://mega.nz/file/7dVlmaRL#oGc7xp0BwjweSqACmxWHjlAZwVuBNtNa-v1z6ob43oQ" "RM520NGLAAR01A06M4G_2022_12_26.zip" "Stock" }
    "11" { Get-Firmware-RM520NGL-Menu }
        Default { Stock-Firmware-RM520NGL-Menu }
    }
}

Function Cert-Firmware-RM520NGL-Menu {
    Write-Log "Displaying Certified Firmware for RM520N-GL Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
	Write-Host "Certified Firmware:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "These options will download and extract a firmware zip with an update folder for use with Qflash"
    Write-Host "The .zips will extract to C:\Quectel\firmware\RM520NGL\Cert\<name_of_zip_without_extension>\" -ForegroundColor Green
	Write-Host "=============================================================" -ForegroundColor Green
	Write-RandomColorText "1) RM520NGLAAR03A03M4G (2024-12-09)"
	Write-RandomColorText "2) RM520NGLAAR03A04M4G (2024-10-22)"
	Write-RandomColorText "3) RM520NGLAAR03A04M4G (2024-08-09)"
    Write-RandomColorText "4) RM520NGLAAR03A03M4G (2024-03-28)"
    Write-RandomColorText "5) RM520NGLAAR03A01M4G (2024-01-02)"
    Write-RandomColorText "6) RM520NGLAAR03A02M4GA (2023-11-06)"
    Write-RandomColorText "7) RM520NGLAAR03A03M4G (2023-07-25)"
    Write-RandomColorText "8) RM520NGLAAR03A01M4G (2023-05-12)"
    Write-RandomColorText "9) Go back to RM520NGL Firmware options"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select a Certified firmware"
    Switch ($firmwareChoice) {
		"1" { Download-Firmware "https://mega.nz/file/nJszFDwY#s8KPB_4cpC-TUhAckZXNSnvpDMfOpHm6N0zir3U2jwg" "RM520NGLAAR03A03M4G_2024_12_09.zip" "Cert" }
		"2" { Download-Firmware "https://mega.nz/file/LNERSCbK#Nf3X7c3rJ-ZaqwfBpfgk7giHPmiTgQVat86LtKFTdsw" "RM520NGLAAR03A04M4G_2024_10_22.zip" "Cert" }
		"3" { Download-Firmware "https://mega.nz/file/GYEVXZbT#h4URXFp0VVl4IWklv24bbtKiZU-bWy96WjSeGVu-Li0" "RM520NGLAAR03A04M4G_2024_08_09.zip" "Cert" }
        "4" { Download-Firmware "https://mega.nz/file/PcV0DDzA#aeQkP3V6WnzvO5BUPTw0Vm1Zdb5n9AA0Zb3ebSsHYlM" "RM520NGLAAR03A03M4G_2024_03_28.zip" "Cert" }
        "5" { Download-Firmware "https://mega.nz/file/fdE1iY4T#4q_gz03GbQZ6mR3-SdQVptelwNPrklVSPWa1VcH9pVo" "RM520NGLAAR03A01M4G_2024_01_02.zip" "Cert" }
        "6" { Download-Firmware "https://mega.nz/file/uZsCkCyL#XxVYTEuPJJOxz1WrSHmkdTbNMvziU9LIDTPIbTh2rkg" "RM520NGLAAR03A02M4GA_2023_11_06.zip" "Cert" }
        "7" { Download-Firmware "https://mega.nz/file/TJFSiBqJ#DVPT-QX60A7pSFVXxxukMDSXTZswTl39XlTEH_NWWpM" "RM520NGLAAR03A03M4G_2023_07_25.zip" "Cert" }
        "8" { Download-Firmware "https://mega.nz/file/yd8ATTCb#ZIbLL2GWnTG_j8RzMaHV4fN5P6v4zBKc1MLfGX5BXH0" "RM520NGLAAR03A01M4G_2023_05_12.zip" "Cert" }
        "9" { Get-Firmware-RM520NGL-Menu }
        Default { Cert-Firmware-RM520NGL-Menu }
    }
}

Function Custom-Firmware-RM520NGL-Menu {
    Write-Log "Displaying Custom Firmware for RM520N-GL Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Custom Firmware"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "These options will download and extract a firmware zip with an update folder for use with Qflash"
    Write-Host "The .zips will extract to C:\Quectel\firmware\RM520NGL\Custom\<name_of_zip_without_extension>\"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) Arixolink RM520NGLAAR03A01M4G OCPU_BETA_20230419C (2023-11-07)"
    Write-RandomColorText "2) Go back to last Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select firmware type"
    Switch ($firmwareChoice) {
        1 { Download-Firmware "https://mega.nz/file/fZcUjCLK#LOav6ZB9ZK15Vm8Nph1s6LpbmHTZNn0f8MsjvFcby1c" "Arixolink_RM520NGLAAR03A01M4G_2023_11_07.zip" "Custom" }
        2 { Get-Firmware-RM520NGL-Menu }
        Default { Custom-Firmware-RM520NGL-Menu }
    }
}

Function Stock-Firmware-RM521FGL-Menu {
    Write-Log "Displaying Stock Firmware for RM521F-GL Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Stock RM521F-GL Firmware:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "These options will download and extract a firmware zip with an update folder for use with Qflash"
    Write-Host "The .zips will extract to C:\Quectel\firmware\RM521FGL\Stock\<name_of_zip_without_extension>\"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) RM521FGLEAR05A02M4G (2023-09-19)"
    Write-RandomColorText "2) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select a stock firmware"
    Switch ($firmwareChoice) {
        "1" { Download-Firmware "https://mega.nz/file/SJN0mQwZ#C7EicrIRcGRG2bsz92Q27VA_zfTE6IAfFTgiUsbanYk" "RM521FGLEAR05A02M4G_2023_09_19.zip" "Stock" }
        "2" { Get-Firmware-Menu }
        Default { Stock-Firmware-RM521FGL-Menu }
    }
}

Function Stock-Firmware-RM502QAE-Menu {
    Write-Log "Displaying Stock Firmware for RM502Q-AE Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Stock RM502Q-AE Firmware:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "These options will download and extract a firmware zip with an update folder for use with Qflash"
    Write-Host "The .zips will extract to C:\Quectel\firmware\RM502QAE\Stock\<name_of_zip_without_extension>\"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) RM502QAEAAR13A04M4G (2023-11-16)"
    Write-RandomColorText "2) RM502QAEAAR11A04M4G (2023-10-08)"
    Write-RandomColorText "3) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select a stock firmware"
    Switch ($firmwareChoice) {
        "1" { Download-Firmware "https://mega.nz/file/GYVDlajK#OvJNLjM74PstycUtWyuJO45akT3zA0MmUCcG0FLPIYs" "RM502QAEAAR13A04M4G_2023_11_16.zip" "Stock" }
        "2" { Download-Firmware "https://mega.nz/file/bZ9DAQBL#kPZxfdFeej1qKYgn35zwJhLKiPRmbHakC3wa1aSwCVE" "RM502QAEAAR11A04M4G_2023_10_08.zip" "Stock" }
        "3" { Get-Firmware-Menu }
        Default { Stock-Firmware-RM502QAE-Menu }
    }
}

Function Stock-Firmware-RM551EGL-Menu {
    Write-Log "Displaying Stock Firmware for RM551E-GL Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Stock RM551E-GL Firmware:"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "These options will download and extract a firmware zip with an update folder for use with Qflash"
    Write-Host "The .zips will extract to C:\Quectel\firmware\RM551EGL\Stock\<name_of_zip_without_extension>\"
	Write-Host "=============================================================" -ForegroundColor Green
	Write-RandomColorText "1) RM551EGL00AAR01A02M8G (2024-12-23)"
	Write-RandomColorText "2) RM551EGL00AAR01A01M8G (2024-08-05)"
    Write-RandomColorText "3) RM551EGL00AAR01A01M8G_BETA (2024-06-24)"
    Write-RandomColorText "4) RM551EGL00AAR01A01M8G_BETA (2024-04-28)"
    Write-Host "5) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $firmwareChoice = Read-Host "Select a stock firmware"
    Switch ($firmwareChoice) {
		"1" { Download-Firmware "https://mega.nz/file/7IVVGDpa#W0nGKnVz0WW9tEQI3W3ndm-h39X40imQjPnSfh7FJCI" "RM551EGL00AAR01A02M8G_2024_12_23.zip" "Stock" }
		"2" { Download-Firmware "https://mega.nz/file/aAdVHTST#dOzRfehUUbcUFH3Yoo-n58m68wgHcEXhcnKYuo2nMo4" "RM551EGL00AAR01A01M8G_2024_08_05.zip" "Stock" }
        "3" { Download-Firmware "https://mega.nz/file/DQlFiSTA#DwvN0Sw3jSp75yxhb6drmZGB_IiQWhixXsZ8Da-qqeg" "RM551EGL00AAR01A01M8G_BETA_2024_06_24.zip" "Stock" }
        "4" { Download-Firmware "https://mega.nz/file/jJUWhIgC#inwjWgTnrSU1_H8FRFR_Rm7X_AaqaO8uZVj2Q1Kp1s4" "RM551EGL00AAR01A01M8G_BETA_2024_04_28.zip" "Stock" }
        "5" { Get-Firmware-Menu }
        Default { Stock-Firmware-RM551EGL-Menu }
    }
}

Function Get-Docs-Menu {
    Write-Log "Displaying Get Docs Menu."
    cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Select the modem model to view AT command docs and other resources"
	Write-Host "=============================================================" -ForegroundColor Green
    Write-RandomColorText "1) RM520N-GL"
    Write-RandomColorText "2) RM521F-GL"
    Write-RandomColorText "3) RM502Q-AE"
    Write-RandomColorText "4) RM551E-GL"
    Write-RandomColorText "5) Go back to Main Menu"
	Write-Host "=============================================================" -ForegroundColor Green
    $docChoice = Read-Host "Select a modem model"
    Switch ($docChoice) {
        1 { Open-WebPage "https://github.com/iamromulan/RM520N-GL" }
        2 { Open-WebPage "https://github.com/iamromulan/RM521F-GL" }
        3 { Open-WebPage "https://github.com/iamromulan/RM502Q-AE" }
        4 { Open-WebPage "https://github.com/iamromulan/RM551E-GL" }
        5 { Main-Menu }
        Default { Get-Docs-Menu }
    }
}

Function Open-WebPage {
    param (
        [string]$url
    )
    Start-Process $url
    Main-Menu
}

Function Exit-Tool {
    Write-Log "Cleaning up..."
    Write-Host "Cleaning up..."
    Remove-Item -Path "$env:TEMP\megatools.exe" -Force -ErrorAction SilentlyContinue
    Write-Log "Goodbye!"
	cls
	Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "Goodbye!"
	Write-Host "=============================================================" -ForegroundColor Green
	sleep 1
	Exit
}

# Start the script by showing the Start menu
Start-Menu
