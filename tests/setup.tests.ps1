BeforeAll {
	$constants = & "${PSScriptRoot}\..\constants.ps1"
	$ModulePath = & (Get-ScriptPath -Path $PSCommandPath)
	Import-Module $ModulePath -DisableNameChecking
	$ImportedModule = Get-Module $constants.ProjectName
}

Describe 'Functions' {
	It 'Get-DockerImages' {
		$ImportedModule.ExportedCommands.Keys | Should -Contain 'Get-DockerImages'
	}
}

AfterAll {

}