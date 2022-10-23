[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository `
	-Name PSGallery `
	-InstallationPolicy Trusted 

if (!(Get-InstalledModule `
			-Name Pester `
			-RequiredVersion '5.3.3' `
			-ErrorAction Ignore)) {
	Write-Host 'Install Pester'
	Install-Module `
		-Name Pester `
		-RequiredVersion '5.3.3' `
		-Force
}
if (!(Get-InstalledModule `
			-Name PesterExtensions `
			-RequiredVersion '0.7.4' `
			-ErrorAction Ignore)) {
	Write-Host 'Install PesterExtensions'
	Install-Module `
		-Name PesterExtensions `
		-RequiredVersion '0.7.4' `
		-Force
} 

if (!(Get-InstalledModule `
			-Name PSScriptAnalyzer `
			-RequiredVersion '1.21.0' `
			-ErrorAction Ignore)) {
	Write-Host 'Install PSScriptAnalyzer'
	Install-Module `
		-Name PSScriptAnalyzer `
		-RequiredVersion '1.21.0' `
		-Force
}

