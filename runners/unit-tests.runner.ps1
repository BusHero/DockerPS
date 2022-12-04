Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$path = "${ProjectRoot}\tests\DockerPS\"
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Path = $path
$configuration.Run.Exit = $true
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\unit-tests.${date}.xml"
$configuration.TestResult.OutputFormat
$configuration.Output.CIFormat = 'GitHubActions'

# Code Coverage
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.Path = "${ProjectRoot}\src\DockerPS\"
$configuration.CodeCoverage.OutputPath = "${ProjectRoot}\test-results\coverage.${date}.xml"

Invoke-Pester -Configuration $configuration
