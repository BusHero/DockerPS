BeforeAll {
	$constants = & "${PSScriptRoot}\..\constants.ps1"
	$ImportedModule = Test-ModuleManifest -Path 'C:\Users\Petru\projects\powershell\DockerPS\src\DockerPS\DockerPS.psd1'
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
	}

	It 'Tags' {
		$ImportedModule.Tags | Should -Contain 'docker'
	}
}
