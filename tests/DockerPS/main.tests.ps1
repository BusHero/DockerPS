BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)
}

Describe 'Format-DockerArguments' {
	It 'No parameters' {
		Format-DockerArguments | Should -Be "images --format '{{json .}}'" 
	}

	It 'Specify image name' {
		$imageName = 'foo'
		Format-DockerArguments -Image $imageName | Should -Be "images --format '{{json .}}' $imageName" 
	}

	It '--no-trunk' {
		Format-DockerArguments -NoTrunk | Should -Be "images --format '{{json .}}' --no-trunc" 
	}

	Describe '--filter' {
		It 'one filter' {
			$filter = 'foo=bar'
			Format-DockerArguments -Filter $filter | Should -Be "images --format '{{json .}}' --filter '${filter}'" 
		}

		It 'two filter' {
			$filter1 = 'foo=bar'
			$filter2 = 'bar=baz'
			Format-DockerArguments -Filter $filter1, $filter2 |
			Should -Be "images --format '{{json .}}' --filter '${filter1}' --filter '${filter2}'" 
		}

		Describe 'Ignore empty filters' {
			It 'One filter' {
				$filter = ''
				Format-DockerArguments -Filter $filter |
				Should -Be "images --format '{{json .}}'"
			}
			
			It 'Two filters' {
				$filter1 = 'foo=bar'
				$filter2 = ''
				Format-DockerArguments -Filter $filter1, $filter2 |
				Should -Be "images --format '{{json .}}' --filter '${filter1}'" 
			}
		}
	}
}

AfterAll {

}