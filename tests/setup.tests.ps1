BeforeAll {
	$constants = & "${PSScriptRoot}\..\constants.ps1"
	$ModulePath = & (Get-ScriptPath -Path $PSCommandPath)
	Import-Module $ModulePath -DisableNameChecking
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
	
		It '<FunctionName> command should exist' {
			Get-Command $FunctionName | Should -Not -Be $null
		}
	}
}


AfterAll {
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore
}
