param($header)

if ($header -is [string]) {
    $this | Add-Member NoteProperty '#YamlHeader' $header -Force
    return
}

$convertToYaml = $ExecutionContext.SessionState.InvokeCommand.GetCommand('ConvertTo-Yaml', 'Alias,Cmdlet,Function')
if (-not $convertToYaml) {
    Write-Warning "Cannot set yaml header without converter"
    return
}

$convertParameters = @{}
if ($convertToYaml.Parameters['Depth']) {
    $convertParameters['Depth'] = $FormatEnumerationLimit
}
$toYaml = $header | & $convertToYaml @convertParameters
if ($toYaml -is [string]) {
    $this | Add-Member NoteProperty '#YamlHeader' $toYaml -Force
}


