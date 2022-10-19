param (
	[Parameter(Mandatory)]
	[string]
	$ApiKey
)

$PSRepository = "LocalPSRepo_$(New-Guid)"
$PackagesDirectory = "${PSScriptRoot}\packages"

Write-Host 'Create .\packages'
New-Item `
	-Path $PackagesDirectory `
	-ItemType Directory `
	-Force > $null

Write-Host 'Register local PSRepository'
Register-PSRepository `
	-Name $PSRepository `
	-SourceLocation $PackagesDirectory `
	-ScriptSourceLocation $PackagesDirectory `
	-InstallationPolicy Trusted

Write-Host 'Publish module'
Publish-Module `
	-Path '.\src\DockerPS' `
	-Repository $PSRepository `
	-ErrorAction Ignore

Unregister-PSRepository `
	-Name $PSRepository `
	-ErrorAction Ignore

New-Item `
	-Path '.\packages\DockerPS' `
	-ItemType Directory `
	-ErrorAction Ignore `
	-Force > $null

Expand-Archive `
	-Path .\packages\DockerPS.0.0.1.nupkg `
	-OutputPath "${PackagesDirectory}\DockerPS"

Remove-Item -Path "${PackagesDirectory}\DockerPS.0.0.1.nupkg"

$doc = New-Object System.Xml.XmlDocument
$doc.Load("${PackagesDirectory}\DockerPS\DockerPS.nuspec")
$repository = $doc.CreateElement('repository', $doc.package.NamespaceURI)
$typeAttribute = $doc.CreateAttribute('type')
$typeAttribute.Value = 'git'
$repository.Attributes.Append($typeAttribute)

$urlAttribute = $doc.CreateAttribute('url')
$urlAttribute.Value = $doc.package.metadata.projectUrl
$repository.Attributes.Append($urlAttribute)
$doc.package.metadata.AppendChild($repository)
$doc.Save("${PackagesDirectory}\DockerPS\DockerPS.nuspec")

nuget pack `
	"${PackagesDirectory}\DockerPS" `
	-OutputDirectory "${PackagesDirectory}"

dotnet nuget push `
	.\packages\DockerPS.0.0.1.nupkg `
	--source 'https://nuget.pkg.github.com/BusHero/index.json' `
	--skip-duplicate `
	--api-key $ApiKey
