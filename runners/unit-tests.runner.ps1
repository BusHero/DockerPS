Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."

Import-Module -Name "${ProjectRoot}\src\DockerPS\DockerPS.psd1"

$path = "${ProjectRoot}\tests\DockerPS\Get-DockerImages.tests.ps1"
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = $path
$configuration.Run.Exit = $true
$configuration.Output.CIFormat = 'GithubActions'
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\unit-tests.${date}.xml"

Invoke-Pester -Configuration $configuration

Remove-Module -Name DockerPS
