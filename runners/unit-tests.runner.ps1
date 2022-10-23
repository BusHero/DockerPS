Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$path = "${ProjectRoot}\tests\DockerPS\"
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = $path
$configuration.Run.Exit = $true
$configuration.Output.CIFormat = 'GithubActions'
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\unit-tests.${date}.xml"

# Code Coverage
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.Path = "${ProjectRoot}\src\DockerPS\Get-DockerImages.ps1"
$configuration.CodeCoverage.OutputPath = "${ProjectRoot}\test-results\coverage.${date}.xml"

Invoke-Pester -Configuration $configuration
