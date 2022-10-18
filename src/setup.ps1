Import-Module Pester

$constants = & "${PSScriptRoot}\..\constants.ps1"
$manifestPath = "${PSScriptRoot}\$($constants.ProjectName)\$($constants.ProjectName).psd1"

New-ModuleManifest `
	-Guid $constants.ProjectGUID `
	-Path $manifestPath `
	-Description 'Some description here and there' `
	-Author $constants.Author `
	-ProjectUri $constants.Repository `
	-LicenseUri $constants.LicenseUri `
	-RootModule "$($constants.ProjectName).psm1" `
	-Tags 'docker' `
	-FunctionsToExport 'Get-DockerImages'
