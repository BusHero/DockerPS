[CmdLetBinding()]
Param(
	[Parameter(Mandatory = $true)]
	[string]$TestLocation
)

$scriptAnalyzerRules = Get-ScriptAnalyzerRule
$Rules = @()
$scriptAnalyzerRules | ForEach-Object { $Rules += @{'RuleName' = $_.RuleName; 'Severity' = $_.Severity } }

$Severities = @('Information', 'Warning', 'Error')

foreach ($Severity in $Severities) {
	Describe "Testing PSSA $Severity Rules" -Tag $Severity {
		It '<RuleName>' -TestCases ($Rules | Where-Object Severity -EQ $Severity) {
			param ($RuleName)
			Invoke-ScriptAnalyzer -Path $TestLocation -IncludeRule $RuleName -Recurse |
			ForEach-Object { "Problem in $($_.ScriptName) at line $($_.Line) with message: $($_.Message)" } |
			Should -BeNullOrEmpty
		}
	}
} 
