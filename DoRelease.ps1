# Set these for each mod
$modName = "RandomEncounters"
$description = "This Sailwind mod adds random encounters while at sea"
$packageName = "RandomEncounters"
$owner = "bryon82"
$repo = "SailwindRandomEncounters"
$dependencies = @(
    'BepInEx-BepInExPack-5.4.2100'
)
# ======================

# Only update below if you have different items to add
$assetsPath = Join-Path $PSScriptRoot "Assets"
$dllPath = Join-Path $PSScriptRoot "$modName\bin\Debug\$modName.dll"
$changelogPath = Join-Path $PSScriptRoot "CHANGELOG.md"
$thunderstoreDir = Join-Path $PSScriptRoot "releaseThunderstore"
$githubDir = Join-Path $PSScriptRoot "releaseGithub"

Remove-Item -path "$thunderstoreDir\*" -Recurse
Remove-Item -path "$githubDir\*" -Recurse

dotnet build

$version = (Get-Item "$dllPath").VersionInfo.FileVersion
$version = $version.Substring(0, $version.Length - 2)

# # Thunderstore
New-Item -Path $thunderstoreDir -Name $modName -ItemType "directory"
$modDir = Join-Path $thunderstoreDir $modName
Copy-Item $dllPath -Destination $modDir
Copy-Item -Path $assetsPath -Destination $modDir -Recurse
Copy-Item (Join-Path $PSScriptRoot "README.md") -Destination $thunderstoreDir
Copy-Item $changelogPath -Destination $thunderstoreDir
Copy-Item (Join-Path $PSScriptRoot "icon.png") -Destination $thunderstoreDir
$manifestFilePath = Join-Path $thunderstoreDir "manifest.json"
$manifest = @{
    name = "$modName"
    version_number = "$version"
    website_url = "https://github.com/$owner/$modName"
    description = "$description"
    dependencies = $dependencies
}
$manifest | ConvertTo-Json | Out-File -FilePath $manifestFilePath
$thunderstoreAssetsPath = Join-Path $thunderstoreDir "$modName.zip"
& "C:\Program Files\7-Zip\7z.exe" a -tzip $thunderstoreAssetsPath (Get-ChildItem -Path $thunderstoreDir).FullName

# upload
Write-Host "Publishing thunderstore package: $packageName Version: $version"
tcli publish --file "$thunderstoreAssetsPath"

# Github
New-Item -Path $githubDir -Name $modName -ItemType "directory"
$modDir = Join-Path $githubDir $modName
Copy-Item $dllPath -Destination $modDir
Copy-Item -Path $assetsPath -Destination $modDir -Recurse
$githubAssetsPath = Join-Path $githubDir "$modName-$version.zip"
& "C:\Program Files\7-Zip\7z.exe" a -tzip $githubAssetsPath (Get-ChildItem -Path $githubDir).FullName

# get last changelog version info for body 
$body = awk '/^##[^#]/{block++} {if (block==1) {print}}' $changelogPath | tail -n +3 | ForEach-Object { "$_`n" } 

# upload
Write-Host "Creating github release: v$version"
gh release create "v$version" $githubAssetsPath --repo $owner/$repo --title "v$version" --notes "$body"
