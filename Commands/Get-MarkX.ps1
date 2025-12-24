function Get-MarkX {
    [Alias('MarkX','Markdown','Get-Markdown')]
    param()

    $allInput = @($input) + $(if ($args) {
        $args
    })    
    
    [PSCustomObject]@{
        PSTypeName = 'MarkX'
        Markdown = $allInput
        YamlHeader = $yamlheader
    }    
}