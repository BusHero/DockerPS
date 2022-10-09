Describe 'Check dependencies are installed' -ForEach @(
	@{ ModuleName = 'Pester'; Version = '5.3.3' }
	@{ ModuleName = 'PesterExtensions'; Version = '0.7.4' }
) {
	BeforeAll {
		$Module = Get-Module $ModuleName
	}
	It '<ModuleName> is installed' {
		$Module | Should -Not -BeNullOrEmpty -Because "$ModuleName is installed"
	}
	It '<ModuleName> should have <Version>' {
		$Module.Version | Should -Be $Version
	}
}