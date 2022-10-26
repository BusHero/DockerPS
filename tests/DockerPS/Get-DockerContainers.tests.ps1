BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)
}

Describe 'Get-DockerContainers' {
	BeforeAll {
		Mock docker { Write-Warning "$args" }
	}

	It 'No parameters' {
		Get-DockerContainers
		Should `
			-Invoke `
			-CommandName 'docker' `
			-Exactly `
			-Times 1 `
			-ParameterFilter {
			"$args" -eq "container ls --format '{{json .}}'"
		}
	}
}
