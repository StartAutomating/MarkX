#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction

$PSScriptRoot | Split-Path | Push-Location

New-GitHubAction -Name "UseMarkX" -Description 'Markdown, XML, and PowerShell' -Action MarkXAction -Icon chevron-right -OutputPath .\action.yml

Pop-Location