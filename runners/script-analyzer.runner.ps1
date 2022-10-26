Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."
$date = Get-Date -Format 'yyyy_MM_dd_HH_mm_ss'


$files = @(
	"${ProjectRoot}\src\DockerPS\Get-DockerImages.ps1",
	"${ProjectRoot}\src\DockerPS\Get-DockerContainers.ps1"
)

foreach ($file in $files) {
	[PesterConfiguration] $configuration = New-PesterConfiguration
	
	[Pester.ContainerInfo]$container = New-PesterContainer `
		-Path "${ProjectRoot}\tests\analyzer.tests.ps1"
	
	$container.Data = @{
		TestLocation = $file
	}
	
	$configuration.Run.Container = $container
	$configuration.Run.Exit = $true
	$configuration.TestResult.Enabled = $true
	$configuration.TestResult.OutputPath = `
		"${ProjectRoot}\test-results\analyzer.${file}.${date}.xml"
	
	Invoke-Pester -Configuration $configuration
}
