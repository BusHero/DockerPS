function Format-DockerArguments {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
	param (
		[string]
		$containerName
	)
	$arguments = @()

	$arguments += 'container'
	$arguments += 'ls'
	$arguments += '--format'
	$arguments += "'{{json .}}'"
	$arguments += $containerName
	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}

function Get-DockerContainers {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
	param (
		[string]
		$containerName
	)
	$arguments = (Format-DockerArguments -containerName $containerName)
	return docker $arguments | ConvertTo-Json
}
