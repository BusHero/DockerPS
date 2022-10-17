BeforeAll {
	$constants = & "${PSScriptRoot}\..\constants.ps1"
	Get-ScriptPath -Path $PSCommandPath
	
	$PSRepository = "LocalPSRepo_$(New-Guid)"
	$PackagesDirectory = "${TestDrive}\packages"
	
	New-Item `
		-Path $PackagesDirectory `
		-ItemType Directory `
		-Force
		
	Register-PSRepository `
		-Name $PSRepository `
		-SourceLocation $PackagesDirectory `
		-ScriptSourceLocation $PackagesDirectory `
		-InstallationPolicy Trusted
		
	Publish-Module `
		-Path "${PSScriptRoot}\..\src\$($constants.ProjectName)" `
		-Repository $PSRepository
	
	Install-Module `
		-Name $constants.ProjectName `
		-Repository $PSRepository `
		-Scope CurrentUser `
		-SkipPublisherCheck `
		-Force
	Import-Module `
		-Name $constants.ProjectName `
		-Scope Local
	$ImportedModule = Get-Module $constants.ProjectName
}
	
Describe 'Check project' {
	It 'Project GUID' {
		$ImportedModule.Guid | Should -Be $constants.ProjectGUID
	}
		
	Describe 'Author' {
		It 'Should be specified' {
			$ImportedModule.Author | Should -Not -BeNullOrEmpty
		}
			
		It 'As in constants' {
			$ImportedModule.Author | Should -Be $constants.Author
		}
	}

	Describe 'Description' {
		It 'Should be specified' {
			$ImportedModule.Description | Should -Not -BeNullOrEmpty
		}
	}

	Describe 'Project Uri' {
		It 'should be specified' {
			$ImportedModule.ProjectUri | Should -Not -BeNullOrEmpty 
		}
		It 'Project Uri' {
			$ImportedModule.ProjectUri | Should -Be $constants.Repository
		}

		It 'Project Uri is reachable' {
			{ Invoke-WebRequest $ImportedModule.ProjectUri } | Should -Not -Throw
		}
	}
	Describe 'License Uri' {
		It 'should be specified' {
			$ImportedModule.LicenseUri | Should -Not -BeNullOrEmpty
		}

		It 'License Uri' {
			$ImportedModule.LicenseUri | Should -Be $constants.LicenseUri 
		}
		It 'License Uri is reachable' {
			{ Invoke-WebRequest $ImportedModule.LicenseUri } | Should -Not -Throw
		}
	}

	Describe 'Exported Functions' -ForEach @(
		@{ FunctionName = 'Get-DockerImages' }
	) {
		It '<FunctionName> should be exported' {
			$ImportedModule.ExportedCommands.Keys | Should -Contain $FunctionName
		}
	
		Describe 'Foo' {
			BeforeAll {
				$command = Get-Command $FunctionName -ErrorAction Ignore
			}

			It '<FunctionName> command should exist' {
				$command | Should -Not -Be $null
			}

			It '<FunctionName>.HelpUri' {
				$command.HelpUri | Should -Not -Be $null
			}

			It '<FunctionName>.HelpUri should be reachable' {
				{ Invoke-WebRequest $command.HelpUri } | Should -Not -Throw
			}
		}

		It 'Help' {
			Get-Help $FunctionName | Should -Not -BeNullOrEmpty
		}

		It '<FunctionName> should support -?' {
			& $FunctionName -? | Should -Not -BeNullOrEmpty
		}
	}

	It 'Tags' {
		$ImportedModule.Tags | Should -Contain 'docker'
	}
}

AfterAll {
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore

	Uninstall-Module `
		-Name DockerPS `
		-ErrorAction Ignore

	Unregister-PSRepository `
		-Name $PSRepository `
		-ErrorAction Ignore
}
