function Get-DockerImages {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
	[CmdletBinding(HelpUri = 'https://github.com/BusHero/DockerPS/wiki/Get-DockerImages')]
	param (
		[string]
		$Image,

		[switch]
		$NoTrunc,

		$Filter
	)

	function ConvertStringFilterToArguments {
		param (
			$Filter
		)
		if ($Filter) {
			'--filter'
			"'${Filter}'"
		}
	}

	function ConvertArrayToArguments {
		param (
			$Filter
		)
		foreach ($f in $Filter | Where-Object { $_ }) {
			'--filter'
			"'${f}'"
		}
	}

	function ConvertHashtableToArguments {
		param (
			$Filter
		)
		foreach ($key in $Filter.Keys) {
			if ($Filter.$key) {
				'--filter'
				"'${Key}=$($Filter.$Key)'"
			}
		}
	}

	function ConvertFilterToDockerArguments {
		param (
			$Filter
		)
		if ($Filter -is [string]) {
			return ConvertStringFilterToArguments $Filter
		}
		elseif ($Filter -is [array]) {
			return ConvertArrayToArguments $Filter
		}
		elseif ($Filter -is [hashtable] -or $Filter -is [System.Collections.Specialized.OrderedDictionary]) {
			return ConvertHashtableToArguments $Filter
		}
	}

	function Format-DockerArguments {
		[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
		param (
			[string]
			$Image,

			[switch]
			$NoTrunc,

			$Filter
		)
		$arguments = @()

		$arguments += 'images'
		$arguments += '--format'
		$arguments += "'{{json .}}'"
		$arguments += $Image
		if ($NoTrunc) {
			$arguments += '--no-trunc'
		}

		$arguments += (ConvertFilterToDockerArguments $Filter)

		$arguments = $arguments | Where-Object { $_ }
		return [string]::Join(' ', $arguments)
	}

	$arguments = (Format-DockerArguments -Image $Image -NoTrunc:$NoTrunc -Filter $Filter)
	return docker $arguments | ConvertFrom-Json
}
