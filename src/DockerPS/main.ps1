function Format-DockerArguments {
	param (
		[string]
		$Image,

		[switch]
		$NoTrunk,

		[string[]]
		$Filter
	)
	$arguments = @()

	$arguments += 'images'
	$arguments += '--format'
	$arguments += "'{{json .}}'"
	$arguments += $Image
	if ($NoTrunk) {
		$arguments += '--no-trunc'
	}
	foreach ($f in $filter | Where-Object { $_ }) {
		$arguments += '--filter'
		$arguments += "'${f}'"
	}

	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}