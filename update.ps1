write-host "Update Powershell profiles";

#$basepath = $Env:USERPROFILE;
$basepath = "C:/Users/jesse/Documents";

# windows Powershell
$winPSProfileDir = "$basepath/WindowsPowerShell";
$winPSProfilePath = "$winPSProfileDir/Microsoft.PowerShell_profile.ps1";

$corePSProfileDir = "$basepath/PowerShell";
$corePSProfilePath = "$corePSProfileDir/Microsoft.PowerShell_profile.ps1";

$coreVSProfilePath = "$corePSProfileDir/Microsoft.VSCode_profile.ps1";
$modulepath = "$corePSProfileDir/Modules";

# windows
copy-item ./Microsoft.PowerShell_profile.ps1 $winPSProfilePath -Force;
write-host "Windows Powershell profile updated: $winPSProfilePath";

# Core
copy-item ./Microsoft.PowerShell_profile.ps1 $corePSProfilePath -Force;
write-host "Core Powershell profile updated: $corePSProfilePath";

# VS Code
copy-item ./Microsoft.PowerShell_profile.ps1 $coreVSProfilePath -Force;
write-host "Core Powershell profile updated: $coreVSProfilePath";

# Modules
copy-item ./WorkModule "$modulepath" -Recurse -Force;
write-host "WorkModule updated: $modulepath";

copy-item ./PersonalModule "$modulepath" -Recurse -Force;
write-host "PersonalModule updated: $modulepath";

# Because we're running the modules in a script block, we also need to copy the modules here:
copy-item ./WorkModule "$winPSProfileDir/Modules" -Recurse -Force;
write-host "WorkModule updated: $winPSProfileDir/Modules";

write-host "Removing workmodule";
remove-module WorkModule -Force;

write-host "Removing PersonalModule";
remove-module PersonalModule -Force;

write-host "Importing WorkModule";
import-module WorkModule;

write-host "Importing PersonalModule";
import-module PersonalModule;