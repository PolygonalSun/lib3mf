<#
.SYNOPSIS
Build the Windows projects and generate NuGet packages

.DESCRIPTION
Build the Windows projects that were generated by GenerateVS2017.ps1 and generate the NuGet packages.

.EXAMPLE
BuildVS2017NuGet.ps1
#>

[CmdletBinding()]
param(
)

$MSbuildExe = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe"

function BuildPlatform($path)
{
    $fullPath = $PSScriptRoot + "/../build/" + $path
    if (-not (Test-Path $fullPath))
    {
        Write-Host "ERROR $fullPath does not exist"
        return
    }

    Push-Location $fullPath | Out-Null

    try
    {
        & $MSbuildExe lib3MF.sln /t:lib3MF_s /p:Configuration=Release
        & $MSbuildExe lib3MF.sln /t:lib3MF_s /p:Configuration=Debug
    }
    finally
    {
        Pop-Location
    }
}

function GenerateNuGet
{
    nuget pack $PSScriptRoot/../build/buildwin32/nuget/windows/lib3mf.windows.nuspec -OutputDirectory $PSScriptRoot/../build
}

function Main
{
    BuildPlatform "buildwin32"
    BuildPlatform "buildwin64"
    BuildPlatform "builduwp32"
    BuildPlatform "builduwp64"
    BuildPlatform "buildarm"

    GenerateNuGet
}

Main
