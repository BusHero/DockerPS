BeforeAll {
	$constants = & "${PSScriptRoot}\..\constants.ps1"
	$ModulePath = & (Get-ScriptPath -Path $PSCommandPath)
	Import-Module $ModulePath -DisableNameChecking
	$ImportedModule = Get-Module $constants.ProjectName
}

Describe 'Functions' -ForEach @(
	@{ FunctionName = 'Get-DockerImages' }
) {
	It '<FunctionName> should be exported' {
		$ImportedModule.ExportedCommands.Keys | Should -Contain $FunctionName
	}

	It '<FunctionName> command should exist' {
		Get-Command $FunctionName | Should -Not -Be $null
	}
}

AfterAll {	
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore
}
