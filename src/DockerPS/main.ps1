function Format-DockerArguments {
	[CmdletBinding(PositionalBinding = $false)]
	param (
		[string]
		$Image,

		[switch]
		$NoTrunk,

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
	if ($Filter -is [string]) {
		if ($Filter) {
			$arguments += '--filter'
			$arguments += "'${Filter}'"
		}
	}
	elseif ($Filter -is [array]) {
		foreach ($f in $Filter | Where-Object { $_ }) {
			$arguments += '--filter'
			$arguments += "'${f}'"
		}
	}
	elseif ($Filter -is [hashtable] -or $Filter -is [System.Collections.Specialized.OrderedDictionary]) {
		foreach ($key in $Filter.Keys) {
			if ($Filter.$key) {
				$arguments += '--filter'
				$arguments += "'${Key}=$($Filter.$Key)'"
			}
		}
	}

	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}