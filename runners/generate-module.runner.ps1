Import-Module Microsoft.PowerShell.Crescendo

$RootDirectory = "${PSScriptRoot}\.."
$modulePath = "${RootDirectory}\src\DockerPS\"

. "${RootDirectory}\src\parsers.ps1"

New-Item `
	-Path $modulePath `
	-Force `
	-ItemType Directory > $null

Export-CrescendoModule `
	-ConfigurationFile "${RootDirectory}\DockerPS.json" `
	-ModuleName "${ModulePath}\DockerPS.psm1"
