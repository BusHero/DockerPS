function Get-DockerContainers {
	param (
	)
	docker "container ls --format '{{json .}}'"
}
