BeforeAll {
	. (Get-ScriptPath -Path $PSCommandPath)
}

Describe 'Get-DockerContainers' {
	BeforeAll {
		Mock docker { '"{"foo": "bar", "bar": "baz"}"' }
	}

	It 'No parameters' {
		Get-DockerContainers
		Should -Invoke -CommandName 'docker' -Exactly -Times 1 -ParameterFilter {
			"$($args[0])" -eq "container ls --format '{{json .}}'"
		}
	}

	It '--no-trunc' {
		Get-DockerContainers -NoTrunc
		Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
			"$($args[0])" -eq "container ls --format '{{json .}}' --no-trunc"
		}
	}

	Context 'Filters' {
		It 'one filter' {
			$filter = 'foo=bar'
			Get-DockerContainers -Filter $filter
			Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
				"$($args[0])" -eq "container ls --format '{{json .}}' --filter '${filter}'"
			}
		}

		It 'two filter' {
			$filter1 = 'foo=bar'
			$filter2 = 'bar=baz'
			Get-DockerContainers -Filter $filter1, $filter2
			Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
				"$($args[0])" -eq "container ls --format '{{json .}}' --filter '${filter1}' --filter '${filter2}'"
			}
		}

		Context 'Ignore empty filters' {
			It 'One filter' {
				$filter = ''
				Get-DockerContainers -Filter $filter
				Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
					"$($args[0])" -eq "container ls --format '{{json .}}'"
				}
			}

			It 'Two filters' {
				$filter1 = 'foo=bar'
				$filter2 = ''
				Get-DockerContainers -Filter $filter1, $filter2
				Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
					"$($args[0])" -eq "container ls --format '{{json .}}' --filter '${filter1}'"
				}
			}
		}
		Context 'Filter as dictionary' {
			It 'One filter' {
				$filter = @{
					foo = 'Bar'
				}
				Get-DockerContainers -Filter $filter
				Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
					"$($args[0])" -eq "container ls --format '{{json .}}' --filter 'foo=$($filter.foo)'"
				}
			}

			It 'Hashtable' {
				$filter = @{
					foo = 'bar'
					bar = 'baz'
				}
				Get-DockerContainers -Filter $filter
				Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
					switch ("$($args[0])") {
						"container ls --format '{{json .}}' --filter 'foo=$($filter.foo)' --filter 'bar=$($filter.bar)'" { return $true }
						"container ls --format '{{json .}}' --filter 'bar=$($filter.bar)' --filter 'foo=$($filter.foo)'" { return $true }
						Default { return $false }
					}
				}
			}

			It 'Two filter ordered' {
				$filter = [ordered]@{
					foo = 'Bar'
					bar = 'Baz'
				}
				Get-DockerContainers -Filter $filter
				Should -Invoke -CommandName 'docker' -Times 1 -ParameterFilter {
					"$args' -eq 'container ls --format '{{json .}}' --filter 'foo=$($filter.foo)' --filter 'bar=$($filter.bar)'"
				}
			}
		}
		Context 'Get-DockerImages returns an object' {
			BeforeAll {
				$result = Get-DockerContainers
			}
			It 'Contains foo property' {
				$result.foo | Should -Be 'bar'
			}
			It 'Contains bar property' {
				$result.bar | Should -Be 'baz'
			}
		}
	}

}
