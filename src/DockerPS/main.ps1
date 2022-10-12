function Get-DockerImages {
	docker images --format '{{json .}}' | ConvertFrom-Json
}