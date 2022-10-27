Import-Module Pester

$ProjectRoot = "${PSScriptRoot}\.."

[Pester.ContainerInfo]$container = New-PesterContainer -Path "${ProjectRoot}\tests\dependencies.Tests.ps1"
$container.Data = @{
	File = "${ProjectRoot}\dependencies.json"
}

[PesterConfiguration] $configuration = New-PesterConfiguration

$configuration.Run.Container = $container
$configuration.Run.Exit = $true
$configuration.Output.CIFormat = 'GithubActions'
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = `
	"${ProjectRoot}\test-results\dependencies.Tests.$(Get-Date -Format 'yyyy_MM_dd_HH_mm_ss').xml"

Invoke-Pester -Configuration $configuration
