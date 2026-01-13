if (-not $this.'#YamlHeader') { return }

$convertFromYaml = $ExecutionContext.SessionState.InvokeCommand.GetCommand('ConvertFrom-Yaml', 'Alias,Cmdlet,Function')
if (-not $convertFromYaml) {
    Write-Warning "Cannot get header without ConvertFrom-Yaml"
    return
}

return ($this.'#YamlHeader' | & $convertFromYaml)