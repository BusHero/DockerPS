param(
	[Parameter(Mandatory)]
	[version]
	$Version,

	[Parameter(Mandatory = $false)]
	[string]
	$Prerelease
)

$constants = & "${PSScriptRoot}\..\constants.ps1"
$manifestPath = "${PSScriptRoot}\..\src\$($constants.ProjectName)\$($constants.ProjectName).psd1"

$moduleManifestArgs = @{
	Guid              = $constants.ProjectGUID
	Path              = $manifestPath
	Description       = 'Some description here and there'
	Author            = $constants.Author
	ProjectUri        = $constants.Repository
	LicenseUri        = $constants.LicenseUri
	RootModule        = "$($constants.ProjectName).psm1"
	ModuleVersion     = $version
	Tags              = 'docker'
	FunctionsToExport = 'Get-DockerImages', 'Get-DockerContainers'
}
if ($Prerelease) {
	$moduleManifestArgs.Prerelease = $Prerelease
}

New-ModuleManifest @moduleManifestArgs
