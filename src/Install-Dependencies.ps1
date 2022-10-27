[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository `
	-Name PSGallery `
	-InstallationPolicy Trusted 

$dependencies = Get-Content -Path "${PSScriptRoot}\..\dependencies.json" | ConvertFrom-Json

foreach ($dependency in $dependencies) {
	if (!(Get-InstalledModule `
				-Name $dependency.Name `
				-RequiredVersion $dependency.Version `
				-ErrorAction Ignore)) {
		Write-Host "Install $($dependency.Name)"
		Install-Module `
			-Name $dependency.Name `
			-RequiredVersion $dependency.Version `
			-Force
	}
	else {
		Write-Host "$($dependency.Name).$($dependency.Version) is already installed"
	}
}
