function Get-DockerImages {
	param (
		[string]
		$image
	)
	return docker images `
		$image `
		--format '{{json .}}' | ConvertFrom-Json
}