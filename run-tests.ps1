Import-Module Pester

$configuration = [PesterConfiguration](New-PesterConfiguration)
$configuration.Run.Path = 'tests'
$configuration.Filter.ExcludeTag = 'docker'
$configuration.Output.CIFormat = 'GithubActions'

Invoke-Pester -Configuration $configuration

