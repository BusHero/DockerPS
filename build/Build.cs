using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tools.PowerShell;
using static PowerShellCoreTasks;

class Build : NukeBuild
{
	readonly AbsolutePath InstallDependenciesScript = RootDirectory / "src" / "Install-Dependencies.ps1";

	public static int Main() => Execute<Build>(x => x.InstallDependencies);

	private Target InstallDependencies => _ => _
		.Executes(() => PowerShellCore(_ => _
			.SetFile(InstallDependenciesScript)));
}
