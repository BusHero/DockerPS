using Nuke.Common;
using static Nuke.Common.Tools.DotNet.DotNetTasks;
using Nuke.Common.Tools.DotNet;
using NuGet.Configuration;
using static Nuke.Common.Tools.NuGet.NuGetTasks;
using Nuke.Common.Tools.NuGet;

partial class Build
{
	[Parameter]
	readonly string NugetApiUrl = "https://nuget.pkg.github.com/BusHero/index.json";

	[Parameter]
	[Secret]
	readonly string NugetApiKey;

	[Parameter]
	readonly string RepositoryName = "github";

	private Target Pack => _ => _
		.DependsOn(GenerateNuspec)
		.Executes(() => NuGetPack(_ => _
			.SetTargetPath(SrcPath / "DockerPS" / "DockerPS.nuspec")
			.SetOutputDirectory(RootDirectory / "packages")
			.AddProperty("NoWarn", "NU5110,NU5111,NU5125")));

	private Target Publish => _ => _
		.Requires(() => NugetApiUrl)
		.Requires(() => NugetApiKey)
		.DependsOn(RegisterRepository)
		.Executes(() => DotNetNuGetPush(_ => _
			.SetTargetPath(RootDirectory / "packages" / "*.nupkg")
			.SetSource(RepositoryName)
			.SetApiKey(NugetApiKey)));

	private Target RegisterRepository => _ => _
		.Requires(() => NugetApiKey)
		.Requires(() => NugetApiUrl)
		.OnlyWhenStatic(() => !DoesPackageSourceExist(RepositoryName))
		.Executes(() => DotNetNuGetAddSource(_ => _
			.SetName(RepositoryName)
			.SetPassword(NugetApiKey)
			.SetSource(NugetApiUrl)
			.SetUsername("BusHero")
			.SetStorePasswordInClearText(true)));

	private Target Tests => _ => _
		.DependsOn(RunUnitTests)
		.DependsOn(RunIntegrationTests)
		.DependsOn(InvokePSAnalyzer);

	private static bool DoesPackageSourceExist(string packageSource) => SettingsUtility
		.GetEnabledSources(Settings.LoadDefaultSettings(default))
		.Select(source => source.Name)
		.Any(source => source == packageSource);


	private Target Step1 => _ => _
	 	.DependsOn(Tests)
		.Triggers(Step2);

	private Target Step2 => _ => _
	 	.DependsOn(Pack)
		.Triggers(Step3);

	private Target Step3 => _ => _
	 	.DependsOn(Publish);
}
