Import-Module Microsoft.PowerShell.Crescendo

$modulePath = "${PSScriptRoot}\..\src\DockerPS\"

New-Item `
	-Path $modulePath `
	-Force `
	-ItemType Directory > $null

Export-CrescendoModule `
	-ConfigurationFile "${PSScriptRoot}\..\DockerPS.json" `
	-ModuleName "${ModulePath}\DockerPS.psm1"
