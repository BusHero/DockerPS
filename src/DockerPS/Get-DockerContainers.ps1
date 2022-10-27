function ConvertStringFilterToArguments1 {
	param (
		$Filter
	)
	if ($Filter) {
		'--filter'
		"'${Filter}'"
	}
}

function ConvertArrayToArguments1 {
	param (
		$Filter
	)
	foreach ($f in $Filter | Where-Object { $_ }) {
		'--filter'
		"'${f}'"
	}
}

function ConvertHashtableToArguments1 {
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

function ConvertFilterToDockerArguments1 {
	param (
		$Filter
	)
	if ($Filter -is [string]) {
		return ConvertStringFilterToArguments1 $Filter
	}
	elseif ($Filter -is [array]) {
		return ConvertArrayToArguments1 $Filter
	}
	elseif ($Filter -is [hashtable] -or $Filter -is [System.Collections.Specialized.OrderedDictionary]) {
		return ConvertHashtableToArguments1 $Filter
	}
}

function Format-DockerArguments1 {
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
	$arguments += (ConvertFilterToDockerArguments1 $Filter)
	$arguments = $arguments | Where-Object { $_ }
	return [string]::Join(' ', $arguments)
}

function Get-DockerContainers {
	[CmdletBinding(HelpUri = 'https://github.com/BusHero/DockerPS/wiki/Get-DockerContainers')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Demo')]
	param (
		[string]
		$containerName,

		[switch]
		$NoTrunc,

		$Filter
	)
	$arguments = (Format-DockerArguments1 `
			-containerName $containerName `
			-NoTrunc:$NoTrunc `
			-Filter $Filter)
	return docker $arguments | ConvertFrom-Json
}
