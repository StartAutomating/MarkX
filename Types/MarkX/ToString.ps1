if (-not $this.XML.XHTML) { return '' }
return ("$($this.XML.XHTML.InnerXML)" + [Environment]::NewLine)