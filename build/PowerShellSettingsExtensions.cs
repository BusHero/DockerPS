using Nuke.Common.Tools.PowerShell;
using Nuke.Common.Tooling;

public static class PowerShellSettingsExtensions
{
	public static PowerShellSettings UsePowerShellCore(
		this PowerShellSettings settings) => settings
		.SetProcessToolPath("pwsh");

	public static PowerShellSettings UsePowerShellSystem(
		this PowerShellSettings settings) => settings
		.SetProcessToolPath("powershell");

	public static PowerShellSettings Configure(this PowerShellSettings settings) => settings
		.UsePowerShellCore()
		.SetNoProfile(true)
		.SetNoLogo(true);
}
