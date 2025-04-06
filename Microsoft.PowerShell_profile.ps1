# neato logo
$neato_logo = @'

______                _  _    ______                _                                     
|  _  \              ( )| |   | ___ \              (_)                                    
| | | |  ___   _ __  |/ | |_  | |_/ /  __ _  _ __   _   ___                               
| | | | / _ \ | '_ \    | __| |  __/  / _` || '_ \ | | / __|                              
| |/ / | (_) || | | |   | |_  | |    | (_| || | | || || (__  _                            
|___/   \___/ |_| |_|    \__| \_|     \__,_||_| |_||_| \___|(_)                           
                                                                                          
                                                  -Douglas Adams                                                                                                        
'@;


$date = (Get-Date);
$username = "Jesse";
$text_color_info = 'DarkGreen';
$text_color_warn = 'Yellow';
$text_color_error = 'Red';
$PSStyle.OutputRendering = "Ansi"

# setup color scheme
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.PrivateData.ErrorForegroundColor = $text_color_error
$Host.PrivateData.WarningForegroundColor = $text_color_warn
$Host.PrivateData.DebugForegroundColor = $text_color_warn
$Host.PrivateData.VerboseForegroundColor = $text_color_info
$Host.PrivateData.ProgressForegroundColor = $text_color_info

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

function reboot { 
    shutdown -r -t 0
}

# loads/reloads the (this) PowerShell profile and can be optionally be silent
function load_profile {
    param(
        [Parameter(Mandatory = $false)][bool]$silent = $false
    ) 

    if ($silent -eq $true) {
        $env:show_ps_profile = 'false';
    }
    else { 
        $env:show_ps_profile = 'true';
    }
    . $profile;
}

# loads/reloads the (this) PowerShell profile and can be optionally be silent
function show_profile {
    load_profile;
}

function printweather {
    param(
        [Parameter(Mandatory = $false)] [string]$city = "Vancouver,Washington"
    ) 
    curl -s -A `"curl`"  http://wttr.in/`"${city}`"?0
}

function printweatherfull {
    param(
        [Parameter(Mandatory = $false)] [string]$city = "Vancouver,Washington"
    ) 
    curl -s -A `"curl`"  http://wttr.in/`"${city}`"
}
  
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
  (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function start-vscode {
    write-host "It's code.. just code.  Starting!" -foregroundcolor $text_color_warn; 
    start-process -FilePath "code.cmd"
}

function Write-Host {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [object]$Object,

        [Parameter()]
        [ConsoleColor]$ForegroundColor = "Green", # Set default to Green

        [Parameter()]
        [ConsoleColor]$BackgroundColor,

        [Parameter()]
        [switch]$NoNewline
    )

    $PSBoundParameters['ForegroundColor'] = $ForegroundColor # Force the color
    Microsoft.PowerShell.Utility\Write-Host @PSBoundParameters
}

function Write-HostColor {
    param(
        [string]$string,
        [string]$scheme = "default"
    )
    # Define color names for each method
    $colors = @{
        default         = @(
            "Green"
        )
        rainbow         = @(
            "Red",      
            "Yellow",   
            "Green",    
            "Cyan",     
            "Blue",     
            "Magenta"  
        )
        river           = @(
            "DarkBlue",   
            "Blue",      
            "Gray",       
            "White"      
        )
        fire            = @(
            "Red",      
            "DarkYellow",
            "Yellow"    
        )
        moderncorporate = @(
            "Magenta"
        )
        warn            = @(
            "darkred"           
        )
    }

    # Get the appropriate color array based on the method
    $colorArray = $colors[$scheme]

    # Initialize color index
    $colorIndex = 0

    # Build the output string with bold and colors
    for ($i = 0; $i -lt $string.Length; $i++) {
        $char = $string[$i]
        if ($scheme -eq 'warn') {
            Write-Host -NoNewline -BackgroundColor "White" -ForegroundColor $colorArray[$colorIndex] -Object ($bold + $char + $reset)
        }
        else {
            Write-Host -NoNewline -ForegroundColor $colorArray[$colorIndex] -Object ($bold + $char + $reset)
        }
        $colorIndex = ($colorIndex + 1) % $colorArray.Count
    }

    Write-Host "" # Add a newline at the end
}

function Get-Colorized-Dir-Items {
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
            -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)

    $fore = $Host.UI.RawUI.ForegroundColor
    $regex_opts = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
      
    $compressed = New-Object System.Text.RegularExpressions.Regex(
        '\.(zip|tar|gz|rar|7z)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|fsx)$', $regex_opts)
    $dll_pdb = New-Object System.Text.RegularExpressions.Regex(
        '\.(dll|pdb)$', $regex_opts)
    $configs = New-Object System.Text.RegularExpressions.Regex(
        '\.(config|conf|ini)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(txt|cfg|conf|ini|csv|log)$', $regex_opts)
    $dev_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(cs|cpp|c|h|java|js|html|css|go|rs|ts)$', $regex_opts) # Added development files
      
    # Set background to black for better contrast
    $Host.UI.RawUI.BackgroundColor = "Black"
      
    Invoke-Expression ("Get-ChildItem $args") |
    ForEach-Object {
        $c = $fore
      
        # directories
        if ($_.GetType().Name -eq 'DirectoryInfo') {
            $c = 'Cyan'
        }
        # compressed files
        elseif ($compressed.IsMatch($_.Name)) {
            $c = 'Magenta'
        }
        # executables
        elseif ($executable.IsMatch($_.Name)) {
            $c = 'DarkGray'
        }
        # text files
        elseif ($text_files.IsMatch($_.Name)) {
            $c = 'Green'
        }
        # dlls and pdbs
        elseif ($dll_pdb.IsMatch($_.Name)) {
            $c = 'Yellow'
        }
        # config files
        elseif ($configs.IsMatch($_.Name)) {
            $c = 'Red'
        }
        # development files
        elseif ($dev_files.IsMatch($_.Name)) {
            $c = 'Blue'
        }
      
      
        $Host.UI.RawUI.ForegroundColor = $c
        Write-Output $_
        $Host.UI.RawUI.ForegroundColor = $fore # Reset foreground color
    }
}

function Get-ChildItem-Force { Get-ChildItem -Force }

#aliases
set-alias weather_full 'printweatherfull' -option AllScope -Force
set-alias weatherfull 'printweatherfull' -option AllScope -Force
set-alias full-weather 'printweatherfull' -option AllScope -Force
set-alias fullweather 'printweatherfull' -option AllScope -Force
set-alias weather 'printweather' -option AllScope -Force
set-alias npp 'notepad++.exe' -option AllScope -Force
set-alias ls 'Get-Colorized-Dir-Items' -option AllScope -Force
set-alias touch 'new-item' -option AllScope -Force
set-alias vscode 'start-vscode' -option AllScope -Force
set-alias grep -Value select-string -option AllScope -Force
set-alias tee -Value tee-object -option AllScope -Force

# only print profile if environment variable = true
if ($env:show_ps_profile -ne 'false') {
    write-host ''
    write-host 'Aliases' -foregroundcolor $text_color_error
    write-host '* "npp" - Launches Notepad++'
    write-host '* "weather "Casablanca,Morocco" - The weather :)'
    write-host '* "weather_full "Casablanca,Morocco" - The weather, but more of it'
    write-host '* "ls" - Colorized directory output'
    write-host '* "touch" - Create empty file'
    write-host '* "grep" - select-string'
    write-host ''
    write-host 'Useful Chef/Ohai commands' -foregroundcolor $text_color_error
    write-host '* "knife cookbook upload -a | chef-client" - Uploads cookbooks and runs chef-client'
    write-host '* "knife cookbook upload cookbook-test" - Upload cookbook cookbook-test'
    write-host '* "chef-client -o cookbook-test::execute_tests - Execute execute_tests recipe from cookbook-test cookbook'
    write-host ''
    write-host 'Useful pytest commands' -foregroundcolor $text_color_error
    write-host '* "pytest -k test_authentication"  --junit-xml=tpldk_tests.xml" - Execute a single test and output the results to XML'
    write-host '* "pytest -m automated_maintenance_tests  --junit-xml=tpldk_tests.xml" - Execute a group of tests and output the results to XML'
    write-host '* "pytest --markers" - List all markers (groups of tests)'
    write-host '* "pytest -k test_authentication --collect-only" - List all tests that *would* be executed'
    write-host ''
    write-host 'Useful jq commands' -foregroundcolor $text_color_error
    write-host '* "ohai | jq -C ." - Colorized outout of all collected ohai data'
    write-host '* "ohai | jq -C .cpu" - Colorized outout ohai collected CPU info'
    write-host '* "ohai | jq -C .kernel" - Colorized outout ohai collected kernel info'
    write-host ''
    write-host 'Useful Docker commands' -foregroundcolor $text_color_error
    write-host '* "docker container ps" - Lists containers and their status'
    write-host '* "docker save --output .\out.tar" - Saves local docker image'
    write-host '* "docker load -i .\out.tar" - Loads local docker image'
    write-host '* "docker container create --name local-dev node:20" - Creates container from image'
    write-host ''
    write-host 'Useful Mercurial commands' -foregroundcolor $text_color_error
    write-host '* "hg forget "set:hgignore() and not ignored()"" - Updates added files based on .hgignore'
    write-host ''
    write-host 'Useful Chocolatey commands' -foregroundcolor $text_color_error
    write-host '* "refreshenv" - Refreshs environment variables in CMD/Powershell'
    write-host ''
    write-host 'Useful Powershell commands' -foregroundcolor $text_color_error
    write-host '* "get-process rimworld*" to get the process id of a running process'
    write-host '* "stop-process -id 1234" - to kill a process'
    write-host '* "get-item $env:pythonpath" - Prints contents of environment variables'
    write-host '* "test-path env:pythonpath" - Check for existence of a environment variable'
    write-host '* "Write-Host $(Get-Date)" - The date'
    write-host '* "(get-command notepad.exe).Path" - Figure out where something is installed..'
    write-host '* "get-help get-date - to get command help'
    write-host '* "import-module [-force] workmodule - to import a module'
    write-host '* "remove-module [-force] workmodule - to remove a module'
    write-host '* "get-module - to list modules'  
    write-host '* "get-module workmodule | select-object -expandproperty Name - to list functions'  
    write-host '* "get-command -module workmodule - to list commands in a module'
    write-host ''
    write-host 'Useful Playwright commands' -foregroundcolor $text_color_error
    write-host '* "npm init playwright@latest" - Get Playwright'
    write-host '* "npx playwright test" - Runs the end-to-end tests.'
    write-host '* "npx playwright test --ui" - Opens UI / Interactive Mode'
    write-host ''

    #print out the weather
    #weather;
    #write-host '';

    write-host "Importing personal AWS module";
    Import-Module personalmodule -prefix nehsa;

    # print logo
    write-host $neato_logo -foregroundcolor $text_color_warn;

    # ps version
    # write-host "PowerShell Version: $(($PSVersionTable).PSVersion)"
    # write-host '';

    $test_admin = Test-Administrator;
    if ($test_admin -ne $true) {
        write-host "YOU ARE NOT RUNNING AS AN ADMINISTRATOR." -foregroundcolor $text_color_warn;
    }

    # ensure we only show profile when requested via load_profile
    $env:show_ps_profile = 'false';

    # DON'T PUT ANYTHING BELOW THIS.  WE USE THIS LINE TO CLEAN OUTPUT FROM SCRIPT_UTILS->SUBPROCESSUTILS AMONG OTHER PLACES...
    write-host '';
    write-host "Good day, sir $username!  It is: $date";
    write-host '';
}
