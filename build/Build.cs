using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tools.PowerShell;
using static PowerShellCoreTasks;
using static Nuke.Common.Tools.NuGet.NuGetTasks;
using static Nuke.Common.Tools.DotNet.DotNetTasks;
using Nuke.Common.Tools.DotNet;
using Nuke.Common.Tools.NuGet;
using Nuke.Common.Tools.GitVersion;
using Nuke.Common.Git;

class Build : NukeBuild
{
	[GitRepository]
	readonly GitRepository Repository;

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
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "unit-tests.runner.ps1")));

	private Target InvokePSAnalyzer => _ => _
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "script-analyzer.runner.ps1")));

	[GitVersion(Framework = "net6")]
	readonly GitVersion GitVersion;


	private Target GenerateModuleManifest => _ => _
		.Executes(() =>
		{
			var segments = Repository.Branch.Split("/");
			string prerelease = segments.Length == 1
				? segments[0]
				: segments.Last();

			return PowerShellCore(_ => _
				.SetFile(SrcPath / "setup.ps1")
				.AddFileArguments("-Version", GitVersion.MajorMinorPatch)
				.AddFileArguments("-Prerelease", GitVersion.NuGetPreReleaseTagV2));
		});

	private Target TestModuleManifest => _ => _
		.TriggeredBy(GenerateModuleManifest)
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "test-modulemanifest.runner.ps1")));

	private Target GenerateNuspec => _ => _
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "nuspec.ps1")
			.AddFileArguments(
				"-ManifestPath", SrcPath / "DockerPS" / "DockerPS.psd1",
				"-DestinationFolder", SrcPath / "DockerPS")));

	private Target Pack => _ => _
		.DependsOn(GenerateNuspec)
		.Executes(() => NuGetPack(_ => _
			.SetTargetPath(SrcPath / "DockerPS" / "DockerPS.nuspec")
			.SetOutputDirectory(RootDirectory / "packages")
			.AddProperty("NoWarn", "NU5110,NU5111,NU5125")));

	[Parameter]
	readonly string NugetApiUrl = "https://nuget.pkg.github.com/BusHero/index.json";

	[Parameter]
	[Secret]
	readonly string NugetApiKey;

	private Target Publish => _ => _
		.Requires(() => NugetApiUrl)
		.Requires(() => NugetApiKey)
		.Executes(() => DotNetNuGetPush(_ => _
			.SetTargetPath(RootDirectory / "packages" / "*.nupkg")
			.SetSource(NugetApiUrl)
			.SetApiKey(NugetApiKey)));

	private Target RestoreTools => _ => _
		.Executes(() => DotNetToolRestore());
}
