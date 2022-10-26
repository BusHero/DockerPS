BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)
}

Describe 'Get-DockerContainers' {
	BeforeAll {
		Mock docker { }
	}

	It 'No parameters' {
		
	}
}
