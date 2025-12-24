param(
[PSObject[]]$Markdown
)

$currentRows = @()
$allMarkdown = @(foreach ($md in $Markdown) {    
    if ($md -isnot [string]) {        
        if ($md -is [ScriptBlock]) {
            $md = "<pre><code class='language-powershell'>$(
                [Web.HttpUtility]::HtmlEncode(
                    "$md"
                )
            )</code><pre>"
        } 
        if ($md -is [Collections.IDictionary] -or 
            ($md.GetType -and -not $md.GetType().IsPrimitive))  {            
            $currentRows += $md            
            continue
        }
    }
    
    if ($currentRows) {    
        $this.ToTable($currentRows)        
        $currentRows = @()
    }

    if ($md -match '(?>\.md|markdown)$' -and
        (Test-Path $md -ErrorAction Ignore)
    ) {
        $md = Get-Content -Raw $md
    }

    $yamlheader = ''
    if ($md -match '^---') {
        $null, $yamlheader, $md = $in -split '---', 3
    }

    $md
})

if ($currentRows) {    
    $allMarkdown += $this.ToTable($currentRows)
    $currentRows = @()
}

$markdown = $allMarkdown -join [Environment]::NewLine

$this | 
    Add-Member NoteProperty '#Markdown' $Markdown -Force

$this.Sync()