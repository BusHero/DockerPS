using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tools.PowerShell;
using static PowerShellCoreTasks;

class Build : NukeBuild
{
	private AbsolutePath SrcPath => RootDirectory / "src";
	private AbsolutePath RunnersPath => RootDirectory / "runners";

	public static int Main() => Execute<Build>(x => x.InstallDependencies);

	private Target InstallDependencies => _ => _
		.Executes(() => PowerShellCore(_ => _
			.SetFile(SrcPath / "Install-Dependencies.ps1")));

	private Target TestInstallDependencies => _ => _
		.TriggeredBy(InstallDependencies)
		.Unlisted()
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "dependencies.runner.ps1")));

	private Target RunUnitTests => _ => _
		.DependsOn(InstallDependencies)
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "unit-tests.runner.ps1")));
}
