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
		.DependsOn(Pack)
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

	private Target Foo => _ => _
		.DependsOn(InstallDependencies)
		.DependentFor(Continous);

	private Target Continous => _ => _
		.DependsOn(RunUnitTests)
		.DependsOn(InvokePSAnalyzer)
		.Triggers(Publish);

	private static bool DoesPackageSourceExist(string packageSource) => SettingsUtility
		.GetEnabledSources(Settings.LoadDefaultSettings(default))
		.Select(source => source.Name)
		.Any(source => source == packageSource);
}
