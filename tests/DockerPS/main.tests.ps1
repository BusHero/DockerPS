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
		
		Describe 'Filter as dictionary' {
			It 'One filter' {
				$filter = @{
					foo = 'Bar'
				}
				Format-DockerArguments -Filter $filter |
				Should -Be "images --format '{{json .}}' --filter 'foo=$($filter.foo)'"
			}
			Describe 'Hashtable' {
				BeforeAll {
					$filter = @{
						foo = 'bar'
						bar = 'baz'
					}
					$result = Format-DockerArguments -Filter $filter
				}
				It 'foo' {
					$result | Should -Match "--filter 'foo=$($filter.foo)'"
				}
				It 'bar' {
					$result | Should -Match "--filter 'bar=$($filter.bar)'"
				}
			}
			It 'Two filter ordered' {
				$filter = [ordered]@{
					foo = 'Bar'
					bar = 'Baz'
				}
				Format-DockerArguments -Filter $filter |
				Should -Be "images --format '{{json .}}' --filter 'foo=$($filter.foo)' --filter 'bar=$($filter.bar)'"
			}
		}
	}
}

AfterAll {

}