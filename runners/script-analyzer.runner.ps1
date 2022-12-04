Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'


$files = @(
	'Get-DockerImages',
	'Get-DockerContainers'
)

foreach ($file in $files) {
	[PesterConfiguration] $configuration = New-PesterConfiguration

	[Pester.ContainerInfo]$container = New-PesterContainer `
		-Path "${ProjectRoot}\tests\analyzer.tests.ps1"

	$container.Data = @{
		TestLocation = "${ProjectRoot}\src\DockerPS\${file}.ps1"
	}

	$configuration.Run.Container = $container
	$configuration.Run.Exit = $true
	$configuration.TestResult.Enabled = $true
	$configuration.TestResult.OutputPath = `
		"${ProjectRoot}\test-results\analyzer.${file}.${date}.xml"
	$configuration.Output.CIFormat = 'GitHubActions'

	Invoke-Pester -Configuration $configuration
}
