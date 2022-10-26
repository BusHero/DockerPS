BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)
}

Describe 'Get-DockerContainers' {
	BeforeAll {
		Mock docker { Write-Warning "$args" }
	}

	It 'No parameters' {
		Get-DockerContainers
		Should -Invoke -CommandName 'docker' -Exactly -Times 1 -ParameterFilter {
			"$args" -eq "container ls --format '{{json .}}'"
		}
	}

	It 'Specify container name' {
		$containerName = 'foo'
		Get-DockerContainers -containerName $containerName
		Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
			"$args" -eq "container ls --format '{{json .}}' ${containerName}"
		}
	}
}
