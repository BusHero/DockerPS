BeforeAll {
	$item = Get-ScriptPath -Path $PSCommandPath | Get-Item
	$Container = 'test'
	$SourcePath = "${PSScriptRoot}\.."
	$TargetPath = 'C:\DockerPS'
	
	Write-Host 'Create test container ...'
	docker run `
		--name $container `
		--mount "type=bind,source=${SourcePath},target=${TargetPath}" `
		--interactive `
		--detach `
		--tty `
		--rm `
		mcr.microsoft.com/powershell
	
	Write-Host 'Install dependencies in container ...'
	docker exec `
		--tty `
		--interactive `
		$Container `
		pwsh -File "${TargetPath}\src\$($item.Name)"
}

Describe 'Dependencies are installed' -Tag 'docker' {
	It 'Dependencies are installed' {
		Write-Host 'Invoke dependencies.Tests.ps1 ...'
		docker exec `
			--tty `
			--interactive `
			$Container `
			pwsh -Command "Invoke-Pester -EnableExit ${TargetPath}\tests\dependencies.Tests.ps1"
		$LASTEXITCODE | Should -Be 0
	}
}

AfterAll {
	docker stop $container
}
