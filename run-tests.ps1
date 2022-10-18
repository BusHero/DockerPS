Import-Module Pester

$configuration = [PesterConfiguration](New-PesterConfiguration)
$configuration.Run.Path = 'tests'
$configuration.Filter.ExcludeTag = 'docker'

Invoke-Pester -Configuration $configuration

