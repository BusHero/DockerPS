Describe 'Get Docker-Images' {
	BeforeAll {
		Import-Module -Name "${PSScriptRoot}\..\..\src\DockerPS"
	}

	Describe 'Get-DockerImages' {
		BeforeAll {
			$imageName = "image_$(New-Guid)"
			'FROM hello-world' | docker build -t $imageName -
		}

		It 'Get-DockerImages' {
			$result = Get-DockerImages -Image $imageName
			$result.Repository | Should -Be $imageName
		}

		AfterAll {
			docker image rm $imageName
		}
	}

	AfterAll {
		Remove-Module DockerPS
	}
}
