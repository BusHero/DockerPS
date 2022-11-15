Describe 'Get Docker-Images' {
	BeforeAll {
		Import-Module -Name "${PSScriptRoot}\..\src\DockerPS"
	}

	Describe 'Get-DockerImages' {
		BeforeAll {
			$imageName = "image_$(New-Guid)"
			'FROM hello-world' | docker build -t $imageName - 2> $null
		}

		It 'Get-DockerImages' {
			$result = Get-DockerImages -Image $imageName
			$result.Repository | Should -Be $imageName
		}

		AfterAll {
			docker image rm $imageName
		}
	}

	Describe 'Get-DockerContainers' {
		BeforeAll {
			$containerName = "container_$(New-Guid)"
			docker run --name $containerName -it -d --rm alpine
		}
		It 'Get-DockerContainers' {
			Get-DockerContainers |
			Select-Object -ExpandProperty Names |
			Should -Contain $containerName
		}
		AfterAll {
			docker stop $containerName
		}
	}

	AfterAll {
		Remove-Module DockerPS
	}
}
