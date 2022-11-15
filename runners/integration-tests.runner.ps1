Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$path = "${ProjectRoot}\tests\integration.tests.ps1"
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = $path
$configuration.Run.Exit = $true
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\integration-tests.${date}.xml"

Invoke-Pester -Configuration $configuration
