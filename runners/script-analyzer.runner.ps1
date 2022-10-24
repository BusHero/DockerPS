Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'

[PesterConfiguration] $configuration = New-PesterConfiguration

[Pester.ContainerInfo]$container = New-PesterContainer `
	-Path "${ProjectRoot}\tests\analyzer.tests.ps1"

$container.Data = @{
	TestLocation = "${ProjectRoot}\src\DockerPS\Get-DockerImages.ps1"
}

$configuration.Run.Container = $container
$configuration.Run.Exit = $true
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\analyzer.${date}.xml"

Invoke-Pester -Configuration $configuration
