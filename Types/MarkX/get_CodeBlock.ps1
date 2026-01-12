<#
.SYNOPSIS
    Gets code blocks
.DESCRIPTION
    Gets code blocks within Markdown / MarkX
.EXAMPLE
    "
    # Hello World in PowerShell
    ~~~PowerShell
    'Hello World'
    ~~~
    " | markx | Select-Object -ExpandProperty CodeBlock 
#>
$codeByLanguage = [Ordered]@{}

foreach ($element in $this.XML | Select-Xml -XPath //code) {
    $language = 'unknown'
    if ($element.node.class -match 'language-(?<language>\S+)?') {
        $language = $matches.language        
    }
    if (-not $codeByLanguage[$language]) {
        $codeByLanguage[$language] = @()
    }
    $codeByLanguage[$language] += $element.node
}

return $codeByLanguage