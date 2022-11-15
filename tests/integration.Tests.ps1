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
		Describe 'Containers' {
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

		It 'No containers' {
			Get-DockerContainers | Should -BeNullOrEmpty
		}
	}

	AfterAll {
		Remove-Module DockerPS
	}
}
