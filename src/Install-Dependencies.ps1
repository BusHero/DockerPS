[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
Install-Module -Name Pester -Force
Install-Module -Name PesterExtensions -Force
