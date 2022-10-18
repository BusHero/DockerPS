$PSRepository = 'LocalPSRepo'
$PackagesDirectory = "${PSScriptRoot}\packages"

Write-Host 'Create .\packages'
New-Item `
	-Path $PackagesDirectory `
	-ItemType Directory > $null

Write-Host 'Register local PSRepository'
Register-PSRepository `
	-Name $PSRepository `
	-SourceLocation $PackagesDirectory `
	-ScriptSourceLocation $PackagesDirectory `
	-InstallationPolicy Trusted

Write-Host 'Publish module'
Publish-Module `
	-Path '.\src\DockerPS' `
	-Repository $PSRepository


