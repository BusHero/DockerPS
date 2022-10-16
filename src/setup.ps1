$constants = & "${PSScriptRoot}\..\constants.ps1"
$manifestPath = "${PSScriptRoot}\$($constants.ProjectName)\$($constants.ProjectName).psd1"

New-ModuleManifest `
	-Guid $constants.ProjectGUID `
	-Path $manifestPath `
	-Author $constants.Author `
	-ProjectUri $constants.Repository `
	-LicenseUri $constants.LicenseUri `
	-RootModule "$($constants.ProjectName).psm1" `
	-FunctionsToExport 'Get-DockerImages'

return $manifestPath
