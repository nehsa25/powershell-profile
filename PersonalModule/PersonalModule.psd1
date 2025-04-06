@{
    Description       = "Functions that make Jesse happy."
    Author            = "Jesse Stone"
    Copyright         = "(c) 2025 Jesse Stone. All rights reserved."
    RootModule        = "PersonalModule.psm1"
    FunctionsToExport = @(
        "Invoke-Login"
        "Invoke-PrintConsoleColors"
        "Get-ImageLatest"
        "Invoke-BuildAPI"
        "Invoke-TagAPI"
        "Invoke-PublishAPI"
        "Invoke-BuildAndPublishAPI"
        "Invoke-BuildMudReact"
        "Invoke-TagMudReact"
        "Invoke-PublishMudReact"
        "Invoke-BuildAndPublishMudReact"        
        "Invoke-SSHDatabase"
        "Invoke-RefreshModule"
    )
    ModuleVersion     = "1.0.0"
}
