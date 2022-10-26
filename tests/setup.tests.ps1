Describe 'Check project' {
	BeforeAll {
		$constants = & "${PSScriptRoot}\..\constants.ps1"
		Import-Module -Name "${PSScriptRoot}\..\src\DockerPS"
		$ImportedModule = Get-Module -Name $constants.ProjectName
	}

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
		@{ FunctionName = 'Get-DockerContainers' }
	) {
		It '<FunctionName> should be exported' {
			$ImportedModule.ExportedCommands.Keys | Should -Contain $FunctionName
		}
		Describe 'Check <FunctionName>' {
			BeforeAll {
				$command = Get-Command `
					$FunctionName `
					-Module DockerPS `
					-ErrorAction Ignore
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
			It 'Help' {
				Get-Help $FunctionName | Should -Not -BeNullOrEmpty
			}
			It '<FunctionName> should support -?' {
				& $FunctionName -? | Should -Not -BeNullOrEmpty
			}
		}
	}

	It 'Tags' {
		$ImportedModule.Tags | Should -Contain 'docker'
	}

	AfterAll {
		Remove-Module -Name DockerPS
	}
}
