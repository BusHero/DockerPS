function Format-DockerArguments {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
	param (
		[string]
		$containerName,

		[switch]
		$NoTrunc
	)
	$arguments = @()

	$arguments += 'container'
	$arguments += 'ls'
	$arguments += '--format'
	$arguments += "'{{json .}}'"
	$arguments += $containerName
	if ($NoTrunc) {
		$arguments += '--no-trunc'
	}
	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}

function Get-DockerContainers {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
	param (
		[string]
		$containerName,

		[switch]
		$NoTrunc
	)
	$arguments = (Format-DockerArguments `
			-containerName $containerName `
			-NoTrunc:$NoTrunc)
	return docker $arguments | ConvertTo-Json
}
