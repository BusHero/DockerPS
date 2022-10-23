using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tooling;
using static Nuke.Common.Tools.PowerShell.PowerShellTasks;

class Build : NukeBuild
{
	[PathExecutable]
	readonly Tool Pwsh;

	readonly AbsolutePath Foo = RootDirectory / "constants.ps1";

	public static int Main() => Execute<Build>(x => x.First);

	Target First => _ => _
		.Executes(() =>
		{
			PowerShell($"-NoProfile -File '{Foo}'");
		});
}
