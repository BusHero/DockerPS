using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tools.PowerShell;
using static Nuke.Common.Tools.PowerShell.PowerShellTasks;
using Nuke.Common.Tooling;

class Build : NukeBuild
{
	readonly AbsolutePath InstallDependenciesScript = RootDirectory / "src" / "Install-Dependencies.ps1";

	public static int Main() => Execute<Build>(x => x.InstallDependencies);

	private Target InstallDependencies => _ => _
		.Executes(() => PowerShell(_ => _
			.SetProcessToolPath("pwsh")
			.SetNoProfile(true)
			.SetNoLogo(true)
			.SetFile(InstallDependenciesScript)));
}
