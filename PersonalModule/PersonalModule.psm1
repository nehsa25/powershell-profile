write-hostcolor "Module loaded from: $($MyInvocation.MyCommand.Path)"
$nehsa = [PSCustomObject]@{
    Profile     = "nehsa"
    Region      = "us-west-2"
    AccountPath = "593793059350.dkr.ecr.us-west-2.amazonaws.com"
    RepoName    = "nehsa-awsls-1"
}

function Invoke-Login {
    $profileName = $nehsa;
    write-hostcolor "Logging into Personal AWS account"
    aws ecr get-login-password --region $profileName.Region --profile $profileName.Profile | docker login --username AWS --password-stdin $profileName.AccountPath
}

function Invoke-BuildAPI {
    write-hostcolor "Building www.nehsa.net API";
    $build = (get-date).ToString("yyyyMMddHH");
    write-host "Building docker API image, bulid:  ${build}";
    $cd = (get-location).Path;
    set-location C:/src/nehsa/nehsanet-app/
    docker build . --platform linux/amd64;
    set-location $cd;
}

function Invoke-BuildMudReact {
    write-hostcolor "Building mud.nehsa.net React image";
    $build = (get-date).ToString("yyyyMMddHH");
    write-host "Building docker MUD React image, build:  ${build}";
    $cd = (get-location).Path;
    set-location C:/src/nehsa/websocket-mud/website/client3
    docker build . --platform linux/amd64;
    set-location $cd;
}

function Invoke-BuildMudWebsocket {
    write-hostcolor "Building mud.nehsa.net websocket image";
    $build = (get-date).ToString("yyyyMMddHH");
    write-host "Building docker NehsaMUD websocket image, build:  ${build}";
    $cd = (get-location).Path;
    set-location C:/src/nehsa/websocket-mud
    docker build . --platform linux/amd64;
    set-location $cd;
}

function Invoke-TagAPI {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "The name of the environment. e.g. dev|stage|prod")]
        [string]$env = $settings.DefaultEnvironment,
        [Parameter(HelpMessage = "The ID of the Docker image. e.g. 1234567890")]
        [string]$id = "latest"
    )
    $build = "api.$((get-date).ToString(`"yyyyMMddHH`"))";
    write-hostcolor "Tagging Docker image for: $($build)";
    if ($id -eq "latest") {
        $id = Get-nehsaImageLatest;
    }
    write-hostcolor -string "Tagging image ($id) for repo: $build";
    docker tag $id $build;
}

function Invoke-TagMudReact {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "The name of the environment. e.g. dev|stage|prod")]
        [string]$env = $settings.DefaultEnvironment,
        [Parameter(HelpMessage = "The ID of the Docker image. e.g. 1234567890")]
        [string]$id = "latest"
    )
    $build = "mudreact.$((get-date).ToString(`"yyyyMMddHH`"))";
    write-hostcolor "Tagging Docker image for: $($build)";
    if ($id -eq "latest") {
        $id = Get-nehsaImageLatest;
    }
    write-hostcolor -string "Tagging image ($id) for repo: $build";
    docker tag $id $build;
}

function Invoke-TagMudWebsocket {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "The name of the environment. e.g. dev|stage|prod")]
        [string]$env = $settings.DefaultEnvironment,
        [Parameter(HelpMessage = "The ID of the Docker image. e.g. 1234567890")]
        [string]$id = "latest"
    )
    $build = "mudwebsocket.$((get-date).ToString(`"yyyyMMddHH`"))";
    write-hostcolor "Tagging Docker image for: $($build)";
    if ($id -eq "latest") {
        $id = Get-nehsaImageLatest;
    }
    write-hostcolor -string "Tagging image ($id) for repo: $build";
    docker tag $id $build;
}

function Invoke-PublishAPI {
    write-hostcolor "Publishing www.nehsa.net API";
    $repoName  = "nehsa-awsls-1"
    $label = (get-date).ToString("yyyyMMddHH");
    $build = "api.$((get-date).ToString(`"yyyyMMddHH`"))";
    write-host "Pushing API image to Amazon Lightsail Container";
    $cmd = "aws lightsail push-container-image --profile nehsa --region $($nehsa.Region) --service-name $($repoName) --label $($label) --image $($build)";
    write-host "Running: $cmd";
    invoke-expression $cmd;
}

function Invoke-PublishMudReact {
    write-hostcolor "Publishing www.nehsa.net API";
    $repoName  = "mud-fe"
    $label = (get-date).ToString("yyyyMMddHH");
    $build = "mudreact.$((get-date).ToString(`"yyyyMMddHH`"))";
    write-host "Pushing API image to Amazon Lightsail Container";
    $cmd = "aws lightsail push-container-image --profile nehsa --region $($nehsa.Region) --service-name $($repoName) --label $($label) --image $($build)";
    write-host "Running: $cmd";
    invoke-expression $cmd;
}

function Invoke-PublishMudWebsocket {
    write-hostcolor "Publishing mud.nehsa.net Websocket image";
    $repoName    = "mud-be"
    $label = (get-date).ToString("yyyyMMddHH");
    $build = "mudwebsocket.$((get-date).ToString(`"yyyyMMddHH`"))";
    write-host "Pushing API image to Amazon Lightsail Container";
    $cmd = "aws lightsail push-container-image --profile nehsa --region $($nehsa.Region) --service-name $($repoName) --label $($label) --image $($build)";
    write-host "Running: $cmd";
    invoke-expression $cmd;
}

function Invoke-RefreshModule {
    write-hostcolor "Refreshing PersonalModule.psm1 module...";
    $modulePath = $MyInvocation.MyCommand.Path;
    if (Test-Path $modulePath) {
        Remove-Module PersonalModule -Force -ErrorAction SilentlyContinue;
        Import-Module $modulePath -Force;
        write-hostcolor "Module refreshed successfully from: $modulePath";
    } else {
        write-hostcolor "Error: Module path not found: $modulePath" -ForegroundColor Red;
    }
}

function Invoke-BuildAndPublishAPI {
    Invoke-nehsaLogin;
    Invoke-nehsaBuildAPI;
    Invoke-nehsaTagAPI;
    Invoke-nehsaPublishAPI;
}

function Invoke-BuildAndPublishMudReact {
    Invoke-nehsaLogin;
    Invoke-nehsaBuildMudReact;
    Invoke-nehsaTagMudReact;
    Invoke-nehsaPublishMudReact;
}

function Invoke-BuildAndPublishMudWebsocket {
    Invoke-nehsaLogin;
    Invoke-nehsaBuildMudWebsocket;
    Invoke-nehsaTagMudWebsocket;
    Invoke-nehsaPublishMudWebsocket;
}

function Invoke-SSHDatabase{
    write-hostcolor "SSH'ing to Lightsail Database";
    $ip = "44.246.62.151";
    $cmd = "ssh -i C:/ssh/ls.pem ubuntu@$ip";
    write-host "Running: $cmd";
    invoke-expression $cmd;
}

function Get-ImageLatest {
    write-hostcolor "Getting last Docker image created" 
    $latestImageID = docker images --format "{{.ID}} {{.CreatedAt}}" `
    | Sort-Object -Descending { $_.Split(' ')[1] } `
    | Select-Object -First 1 `
    | ForEach-Object { $_.Split(' ')[0] };
    
    write-hostcolor "Latest Image ID: $latestImageID"
    return $latestImageID;
}

function Invoke-PrintConsoleColors {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Background color to use.")]
        [string]$bg = "all"
    )

    if ($bg -eq "all") {
        $ConsoleColors = [Enum]::GetValues([System.ConsoleColor])
        foreach ($foreground in $ConsoleColors) {
            foreach ($background in $ConsoleColors) {
                # Skip combinations where foreground and background are the same
                if ($foreground -eq $background) { continue }
  
                # Print the color combination with its contrast ratio
                Write-Host ("Foreground: {0,-12} Background: {1,-12}" -f $foreground, $background) -ForegroundColor $foreground -BackgroundColor $background
            } 
        }
    } else {
        $ConsoleColors = [Enum]::GetValues([System.ConsoleColor])
        foreach ($foreground in $ConsoleColors) {
            # Skip combinations where foreground and background are the same
            if ($foreground -eq $background) { continue }

            Write-Host ("Foreground: {0,-12} Background: {1,-12}" -f $foreground, $bg) -ForegroundColor $foreground -BackgroundColor $bg
        }
    }
}