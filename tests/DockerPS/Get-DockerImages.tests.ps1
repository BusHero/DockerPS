Describe 'Get-DockerImages' {
	BeforeAll {
		Mock -ModuleName DockerPS docker { '{"foo": "bar", "bar": "baz"}' }
	}
	
	It 'No parameters' {
		Get-DockerImages
		Should -Invoke -CommandName docker -ModuleName DockerPS -Times 1 -ParameterFilter {
			"$($args[0])" -eq 'images --format {{json .}}'
		}
	}

	# It 'Specify image name' {
	# 	$imageName = 'foo'
	# 	Get-DockerImages -Image $imageName
	# 	Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 		"${args}" -eq "images --format '{{json .}}' ${imageName}" 
	# 	}
	# }

	# It '--no-trunc' {
	# 	Get-DockerImages -NoTrunc
	# 	Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 		"${args}" -eq "images --format '{{json .}}' --no-trunc"
	# 	}
	# }

	# Describe '--filter' {
	# 	It 'one filter' {
	# 		$filter = 'foo=bar'
	# 		Get-DockerImages -Filter $filter 
	# 		Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 			"${args}" -eq "images --format '{{json .}}' --filter '${filter}'"
	# 		}
	# 	}

	# 	It 'two filter' {
	# 		$filter1 = 'foo=bar'
	# 		$filter2 = 'bar=baz'
	# 		Get-DockerImages -Filter $filter1, $filter2
	# 		Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 			"${args}" -eq "images --format '{{json .}}' --filter '${filter1}' --filter '${filter2}'"
	# 		}
	# 	}

	# 	Describe 'Ignore empty filters' {
	# 		It 'One filter' {
	# 			$filter = ''
	# 			Get-DockerImages -Filter $filter
	# 			Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 				"${args}" -eq "images --format '{{json .}}'"
	# 			}
	# 		}
			
	# 		It 'Two filters' {
	# 			$filter1 = 'foo=bar'
	# 			$filter2 = ''
	# 			Get-DockerImages -Filter $filter1, $filter2
	# 			Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 				"${args}" -eq "images --format '{{json .}}' --filter '${filter1}'"
	# 			}
	# 		}
	# 	}

	# 	Describe 'Filter as dictionary' {
	# 		It 'One filter' {
	# 			$filter = @{
	# 				foo = 'Bar'
	# 			}
	# 			Get-DockerImages -Filter $filter
	# 			Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 				"${args}" -eq "images --format '{{json .}}' --filter 'foo=$($filter.foo)'"
	# 			}
	# 		}

	# 		It 'Hashtable' {
	# 			$filter = @{
	# 				foo = 'bar'
	# 				bar = 'baz'
	# 			}
	# 			Get-DockerImages -Filter $filter
	# 			Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 				switch ("${args}") {
	# 					"images --format '{{json .}}' --filter 'foo=$($filter.foo)' --filter 'bar=$($filter.bar)'" { 
	# 						return $true
	# 					}
	# 					"images --format '{{json .}}' --filter 'bar=$($filter.bar)' --filter 'foo=$($filter.foo)'" {
	# 						return $true
	# 					}
	# 					Default {
	# 						return $false
	# 					}
	# 				}
	# 			}
	# 		}

	# 		It 'Two filter ordered' {
	# 			$filter = [ordered]@{
	# 				foo = 'Bar'
	# 				bar = 'Baz'
	# 			}
	# 			Get-DockerImages -Filter $filter
	# 			Should -Invoke -CommandName 'docker' -ModuleName DockerPS -Times 1 -ParameterFilter {
	# 				"${args}" -eq "images --format '{{json .}}' --filter 'foo=$($filter.foo)' --filter 'bar=$($filter.bar)'"
	# 			}
	# 		}
	# 	}
	# }

	# Describe 'Get-DockerImages returns an object' {
	# 	BeforeAll {
	# 		Mock -ModuleName DockerPS docker { '{"foo": "bar", "bar": "baz"}' }
	# 		$result = Get-DockerImages
	# 	}
	# 	It 'Contains foo property' {
	# 		$result.foo | Should -Be 'bar'
	# 	}
	# 	It 'Contains bar property' {
	# 		$result.bar | Should -Be 'baz'
	# 	}
	# }
}

