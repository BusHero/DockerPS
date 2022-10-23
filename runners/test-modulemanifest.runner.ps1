Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = "${ProjectRoot}\tests\setup.Tests.ps1"
$configuration.Run.Exit = $true
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\test-modulemanifest.Tests.$(Get-Date -Format 'yyyy_MM_dd_HH_mm_ss').xml"

Invoke-Pester -Configuration $configuration
