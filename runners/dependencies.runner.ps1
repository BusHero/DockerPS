Import-Module Pester
$path = "${PSScriptRoot}\..\tests\dependencies.Tests.ps1"


[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = $path
$configuration.Run.Exit = $true
$configuration.Output.CIFormat = 'GithubActions'
Invoke-Pester -Configuration $configuration
