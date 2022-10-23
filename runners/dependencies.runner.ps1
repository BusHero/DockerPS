Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$path = "${ProjectRoot}\tests\dependencies.Tests.ps1"

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = $path
$configuration.Run.Exit = $true
$configuration.Output.CIFormat = 'GithubActions'
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = "${ProjectRoot}\test-results\dependencies.Tests.$(Get-Date -Format 'yyyy_MM_dd_HH_mm_ss').xml"

Invoke-Pester -Configuration $configuration
