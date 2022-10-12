BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)

	function CreateTrivialDockerImage {
		$image = "image_$(New-Guid)"

		Write-Output "FROM scratch`nCMD echo ''" | `
			docker build -t $image -f - . > $null
		
		return $image
	}
}

Describe 'Initial Tests' {
	BeforeAll {
		$image1 = CreateTrivialDockerImage
		$image2 = CreateTrivialDockerImage
	}
	
	It 'Get Docker Containers' {
		$images = Get-DockerImages | ForEach-Object { $_.Repository }
		$images | Should -Contain $image1
		$images | Should -Contain $image2
	}

	AfterAll {
		docker image rm $image1
		docker image rm $image2
	}
}

AfterAll {

}