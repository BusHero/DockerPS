using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tools.PowerShell;
using static Nuke.Common.Tools.PowerShell.PowerShellTasks;
using Nuke.Common.Tooling;

class Build : NukeBuild
{
	readonly AbsolutePath Foo = RootDirectory / "Foo.ps1";

	public static int Main() => Execute<Build>(x => x.First);

	private Target First => _ => _
		.Executes(() => PowerShell(_ => _
			.SetProcessToolPath("pwsh")
			.SetNoProfile(true)
			.SetNoLogo(true)
			.SetFile(Foo)));
}
