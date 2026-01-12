<#
.SYNOPSIS
    Gets code
.DESCRIPTION
    Gets code within Markdown / MarkX, grouped by language.
.EXAMPLE
    "
    # Hello World in PowerShell
    ~~~PowerShell
    'Hello World'
    ~~~
    " | markx | Select-Object -ExpandProperty Code 
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
    $codeByLanguage[$language] += $element.node.InnerText
}

return $codeByLanguage