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

copy-item ./PersonalModule "$modulepath" -Recurse -Force;
write-host "PersonalModule updated: $modulepath";

write-host "Removing PersonalModule";
remove-module PersonalModule -Force;

write-host "Importing PersonalModule";
import-module PersonalModule -prefix "nehsa";