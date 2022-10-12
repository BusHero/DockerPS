BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)

	function CreateTrivialDockerImage {
		$image = "image_$(New-Guid)"

		Write-Output "FROM scratch`nCMD echo ''" | `
			docker build -t $image -f - . > $null
		
		return $image
	}
}

Describe 'Get-DockerImages' {
	Describe 'Get all images' {
		BeforeAll {
			$image1 = CreateTrivialDockerImage
			$image2 = CreateTrivialDockerImage
		
			$images = Get-DockerImages | ForEach-Object { $_.Repository }
		}
		
		It 'Get Docker Containers' {
			$images | Should -Contain $image1
		}
		
		It 'image2' {
			$images | Should -Contain $image2
		}
		
		AfterAll {
			docker image rm $image1
			docker image rm $image2
		}
	}

	Describe 'Get only a single image' {
		BeforeAll {
			$image1 = CreateTrivialDockerImage
			$image2 = CreateTrivialDockerImage

			$images = @(Get-DockerImages $image1) | ForEach-Object { $_.Repository }
		}

		It 'Only <image1> should be returned' {
			$images | Should -Contain $image1
		}
		
		It 'image2 should not be present' {
			$images | Should -Not -Contain $image2
		}

		AfterAll {
			docker image rm $image1
			docker image rm $image2
		}
	}
}

AfterAll {

}