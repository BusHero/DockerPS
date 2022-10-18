Describe 'Check dependencies are installed' -ForEach @(
	@{ ModuleName = 'Pester'; Version = '5.3.3' }
	@{ ModuleName = 'PesterExtensions'; Version = '0.7.4' }
	@{ ModuleName = 'PSScriptAnalyzer'; Version = '1.21.0' }
) {
	It '<ModuleName> should have <Version>' {
		$module = Get-InstalledModule ${ModuleName} 
		$module.Version | Should -Be $Version
	}
}
