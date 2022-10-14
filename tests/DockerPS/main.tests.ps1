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
}

AfterAll {

}