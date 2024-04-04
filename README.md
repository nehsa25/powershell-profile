



# powershell-profile

## Description

A Powershell Profile offering useful functions and enhancements to make using Powershell easier.

Function Examples:
* Chocately integration (for refreshenv on Powershell)
* The weather (weather "city,state" - no spaces)
* Colorized ls Function
* Helpful commands for a wide variety of tools:  Chef, Chocately, Playwright, Git, Mercurial, Powershell.. 

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)
- [License](#license)

## Installation

Powershell Core: Place Microsoft.PowerShell_profile.ps1 at C:\Users\<you>\Documents\PowerShell 
Powershell OG: Place Microsoft.PowerShell_profile.ps1 at C:\Users\<you>\Documents\WindowsPowerShell
Type `. $profile` to reload your Powershell Profile

## Usage

Open Powershell/Powershell-Core and profile will automatically be loaded.

## Features

Aliases
* `npp` - Launches Notepad++
* `weather "Casablanca,Morocco"` - The weather :)
* `weather_full "Casablanca,Morocco"` - The weather, but more of it
* `ls` - Colorized directory output

Useful Chef/Ohai commands
* `knife cookbook upload -a | chef-client` - Uploads cookbooks and runs chef-client
* `knife cookbook upload cookbook-test` - Upload cookbook cookbook-test
* `chef-client -o cookbook-test::execute_tests - Execute execute_tests recipe from cookbook-test cookbook

Useful pytest commands
* `pytest -k test_authentication`  --junit-xml=tpldk_tests.xml` - Execute a single test and output the results to XML
* `pytest -m automated_maintenance_tests  --junit-xml=tpldk_tests.xml` - Execute a group of tests and output the results to XML
* `pytest --markers` - List all markers (groups of tests)
* `pytest -k test_authentication --collect-only` - List all tests that *would* be executed

Useful jq commands
* `ohai | jq -C .` - Colorized outout of all collected ohai data
* `ohai | jq -C .cpu` - Colorized outout ohai collected CPU info
* `ohai | jq -C .kernel` - Colorized outout ohai collected kernel info

Useful Docker commands
* `docker container ps` - Lists containers and their status
* `docker save --output .\out.tar` - Saves local docker image
* `docker load -i .\out.tar - Loads local docker image
* `ddocker container create --name local-dev node:20` - Creates container from image

Useful Mercurial commands
* `hg forget `set:hgignore() and not ignored()`` - Updates added files based on .hgignore

Useful Chocolatey commands
* `refreshenv` - Refreshs environment variables in CMD/Powershell

Useful Powershell commands
* `get-process rimworld*` to get the process id of a running process
* `stop-process -id 1234` - to kill a process
* `get-item $env:pythonpath` - Prints contents of environment variables
* `test-path env:pythonpath` - Check for existence of a environment variable
* `Write-Host $(Get-Date)` - The date
* `(get-command notepad.exe).Path` - Figure out where something is installed..

Useful Playwright commands
* `npm init playwright@latest --legacy-peer-deps` - Get Playwright
* `npx playwright test` - Runs the end-to-end tests.
* `npx playwright test --ui` - Opens UI / Interactive Mode

## Tests

None yet..