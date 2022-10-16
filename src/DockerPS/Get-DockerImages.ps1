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

	$arguments += (ConvertFilterToDockerArguments $Filter)

	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}

function Get-DockerImages {
	[CmdletBinding(HelpUri = 'https://github.com/BusHero/DockerPS')]
	param (
		[string]
		$Image,

		[switch]
		$NoTrunk,

		$Filter
	)
	$arguments = (Format-DockerArguments -Image $Image -NoTrunk:$NoTrunk -Filter $Filter)
	return docker $arguments | ConvertFrom-Json
}
