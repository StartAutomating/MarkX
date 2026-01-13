if ($args) {
    $anyOutput = foreach ($arg in $args) {
        $thisArg = $this.$arg
        if ($thisArg) {
            if ($thisArg.XHTML.InnerXML) {
                "$($thisArg.XHTML.InnerXML)" + [Environment]::NewLine
            } else {
                "$thisArg"
            }
        }
    }
    if ($anyOutput) {
        return $anyOutput -join [Environment]::NewLine
    }    
}

if (-not $this.XML.XHTML) { return '' }
return ("$($this.XML.XHTML.InnerXML)" + [Environment]::NewLine)