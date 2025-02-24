@{
    Description       = "Functions that make Jesse happy."
    Author            = "Jesse Stone"
    Copyright         = "(c) 2025 Jesse Stone. All rights reserved."
    RootModule        = "PersonalModule.psm1"
    FunctionsToExport = @(
        "Invoke-Login"
        "Invoke-PrintConsoleColors"
        "Invoke-BuildAPI"
        "Invoke-TagAPI"
        "Invoke-PublishAPI"
        "Get-ImageLatest"
        "Invoke-BuildAndPublishAPI"
        "Invoke-SSHDatabase"
    )
    ModuleVersion     = "1.0.0"
}
