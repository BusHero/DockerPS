function Format-DockerArguments {
	param (
		[string]
		$Image
	)
	$arguments = @()

	$arguments += 'images'
	$arguments += '--format'
	$arguments += "'{{json .}}'"
	$arguments += $Image
	
	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}