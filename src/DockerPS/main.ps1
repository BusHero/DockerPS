function Format-DockerArguments {
	param (
		[string]
		$Image,

		[switch]
		$NoTrunk
	)
	$arguments = @()

	$arguments += 'images'
	$arguments += '--format'
	$arguments += "'{{json .}}'"
	$arguments += $Image
	if ($NoTrunk) {
		$arguments += '--no-trunc'
	}

	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}