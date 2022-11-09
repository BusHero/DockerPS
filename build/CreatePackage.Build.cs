using Nuke.Common;
using static Nuke.Common.Tools.DotNet.DotNetTasks;
using Nuke.Common.Tools.DotNet;
using NuGet.Configuration;

partial class Build
{
	[Parameter]
	readonly string NugetApiUrl = "https://nuget.pkg.github.com/BusHero/index.json";

	[Parameter]
	[Secret]
	readonly string NugetApiKey;

	[Parameter]
	readonly string RepositoryName = "github";

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

	private Target Continous => _ => _
		.Triggers(InstallDependencies)
		.Triggers(RunUnitTests)
		.Triggers(InvokePSAnalyzer)
		.Triggers(GenerateModuleManifest)
		.Triggers(Pack)
		.Triggers(Publish);

	private static bool DoesPackageSourceExist(string packageSource) => SettingsUtility
		.GetEnabledSources(Settings.LoadDefaultSettings(default))
		.Select(source => source.Name)
		.Any(source => source == packageSource);
}
