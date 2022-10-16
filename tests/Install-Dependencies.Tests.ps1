BeforeAll {
	$item = Get-ScriptPath -Path $PSCommandPath | Get-Item
	$Container = 'test'
	$SourcePath = $item.Directory
	$TargetPath = 'C:\scripts'
	
	docker run `
		--name $container `
		--mount "type=bind,source=${SourcePath},target=${TargetPath}" `
		-it `
		-d `
		--rm `
		mcr.microsoft.com/powershell
	
	docker exec `
		$Container `
		pwsh -File "${TargetPath}\$($item.Name)"
}

Describe 'Check dependencies are installed' -ForEach @(
	@{ ModuleName = 'Pester'; Version = '5.3.3' }
	@{ ModuleName = 'PesterExtensions'; Version = '0.7.4' }
) {

	It '<ModuleName> should have <Version>' {
		$ActualVersion = docker exec `
			$Container `
			pwsh -c "Get-InstalledModule ${ModuleName} | Select -ExpandProperty Version"
		$ActualVersion | Should -Be $Version
	}
}

AfterAll {
	docker stop $container
}
