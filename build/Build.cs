using Nuke.Common;
using Nuke.Common.IO;
using Nuke.Common.Tools.PowerShell;
using static PowerShellCoreTasks;
using Nuke.Common.Tools.GitVersion;
using Nuke.Common.Git;
using Serilog;
using Nuke.Common.Execution;

partial class Build : NukeBuild
{
	[GitRepository]
	readonly GitRepository Repository;

	private AbsolutePath SrcPath => RootDirectory / "src";
	private AbsolutePath RunnersPath => RootDirectory / "runners";

	public static int Main() => Execute<Build>(x => x.Step1);

	private Target InstallDependencies => _ => _
	 	.DependentFor(GenerateModuleManifest, RunUnitTests, InvokePSAnalyzer)
		.Executes(() =>
		{
			var currentLogger = Log.Logger;
			Log.Logger = this.SimpleLogger;
			PowerShellCore(_ => _
				.SetFile(RunnersPath / "Install-Dependencies.ps1"));

			PowerShellCore(_ => _
						.SetFile(RunnersPath / "dependencies.runner.ps1"));

			Log.Logger = currentLogger;
		});

	private ILogger _logger;
	private ILogger SimpleLogger => _logger ??= new LoggerConfiguration()
		.WriteTo.Console(
			outputTemplate: "{Message:l}{NewLine}{Exception}",
			applyThemeToRedirectedOutput: true)
		.ConfigureInMemory(this)
		.ConfigureFiles(this)
		.ConfigureLevel()
		.ConfigureFilter()
		.CreateLogger();

	private Target RunUnitTests => _ => _
		.Executes(() =>
		{
			var currentLogger = Log.Logger;
			Log.Logger = this.SimpleLogger;

			PowerShellCore(_ => _
				.SetFile(RunnersPath / "unit-tests.runner.ps1"));

			Log.Logger = currentLogger;
		});

	private Target RunIntegrationTests => _ => _
	 	.OnlyWhenStatic(() => IsLocalBuild)
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "integration-tests.runner.ps1")));

	private Target InvokePSAnalyzer => _ => _
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "script-analyzer.runner.ps1")));

	[GitVersion]
	readonly GitVersion GitVersion;


	private Target GenerateModuleManifest => _ => _
		.Executes(() =>
		{
			var segments = Repository.Branch.Split("/");
			string prerelease = segments.Length == 1
				? segments[0]
				: segments.Last();

			PowerShellCore(_ =>
			{
				var settings = _
					.SetFile(RunnersPath / "setup.ps1")
					.AddFileArguments("-Version", GitVersion.MajorMinorPatch);

				if (!string.IsNullOrEmpty(GitVersion.NuGetPreReleaseTagV2))
				{
					settings = settings
						.AddFileArguments("-Prerelease", GitVersion.NuGetPreReleaseTagV2);
				}

				return settings;
			});

			PowerShellCore(_ => _
				.SetFile(RunnersPath / "test-modulemanifest.runner.ps1"));
		});

	private Target GenerateNuspec => _ => _
	 	.DependsOn(GenerateModuleManifest)
		.Executes(() => PowerShellCore(_ => _
			.SetFile(RunnersPath / "nuspec.ps1")
			.AddFileArguments(
				"-ManifestPath", SrcPath / "DockerPS" / "DockerPS.psd1",
				"-DestinationFolder", SrcPath / "DockerPS")));

}
