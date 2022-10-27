[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]
	$File
)

BeforeDiscovery {
	$dependencies = Get-Content `
		-Path $File |
	ConvertFrom-Json | 
	ForEach-Object { @{ 
			Name    = $_.name;
			Version = $_.version 
		}
	}
}

Describe '<Name>.<version>' -ForEach $dependencies {
	It 'Is installed' {
		$module = Get-InstalledModule $Name
		$module.Version | Should -Be $Version
	}
}
