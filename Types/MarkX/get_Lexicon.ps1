<#
.SYNOPSIS
    Gets Lexicons from Markdown 
.DESCRIPTION
    Gets At Protocol Lexicons defined in Markdown.

    A lexicon table must have at least three columns:
    
    * Property
    * Type
    * Description

    It must also contain a row containing the property `$type`.

    This will be considered the lexicon's type.

    Any bolded or italic fields will be considered required.

    Lexicon tables may also be preceeded by an element containing the description.
#>

$markdownData = $this.DataSet
:nextTable foreach ($table in $markdownData.Tables) {
    $isLexiconTable = $table.Columns['Property'] -and $table.Columns['Type'] -and $table.Columns['Description']

    if (-not $isLexiconTable) { continue nextTable }

    $hasType = $table.Select("Property='`$type'")
    if (-not $hasType) {
        Write-Warning "Missing `$type"
        continue nextTable
    }

    $lexiconType = if ($hasType.Description -match '(?:[^\.\s]+\.){3}[^\.\s]+') {
        $matches.0
    }

    if (-not $lexiconType) {
        continue nextTable
    }

    $lexiconObject = [Ordered]@{
        lexicon = 1
        id = $lexiconType
        defs = @{
            main = [Ordered]@{
                type = 'record'
                description = 
                    if ($table.ExtendedProperties.Description) {
                        $table.ExtendedProperties.Description
                    } else {
                        $lexiconType
                    }
                required = @()
                properties = [Ordered]@{}
            }
        }
    }

    foreach ($row in $table) {
        
        if ($row.Property -eq '$type') { continue }
        $lexProp = [Ordered]@{}            
        $lexProp.type =                 
            switch -regex ($row.type) {
                '\[\]' { 'array' }
                'object' { 'object' }
                'string' { 'string' }
                'bool|switch' { 'boolean' }
                'int|number|float|double' { 'number' }
                'date' { 'datetime' }
                'ur[il]' { 'uri'}
            }
            
        $lexProp.description = $row.Description
        if ($row.Property -match '\*') {
            $lexiconObject.defs.main.required += $row.Property -replace '\*'
        } 
        elseif ($row.tr.td.outerxml -match '<(?>b|i|strong)>') {
            $lexiconObject.defs.main.required += $row.Property -replace '\*'
        }
        
        $lexiconObject.defs.main.properties[$row.Property -replace '\*'] = $lexProp
    }

    $lexiconObject        
}