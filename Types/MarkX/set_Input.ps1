param(
[PSObject[]]$InputObject
)

$this | Add-Member NoteProperty '#Input' $InputObject -Force

$currentRows = @()
$allMarkdown = @(:nextInput foreach ($md in $InputObject) {    
    if ($md -isnot [string]) {
        
        if ($md -is [Management.Automation.CommandInfo]) {
            $cmdHelp = if (
                $md -is [Management.Automation.FunctionInfo] -or
                $md -is [Management.Automation.AliasInfo]
            ) {
                Get-Help -Name $md.Name
            } elseif ($md -is [Management.Automation.ExternalScriptInfo]) {
                Get-Help -Name $md.Source
            } else {
                continue nextInput
            }
            if ($cmdHelp) {
                $md = $cmdHelp                
            }
        }

        if ($md.pstypenames -match 'HelpInfo') {
            @(
                if ($md.Name -match '[\\/]') {
                    "# $(@($md.Name -split '[\\/]')[-1] -replace '\.ps1')"
                } else {
                    "# $($md.Name)"
                }
                
                if ($md.Synopsis) {
                    "## $($md.Synopsis)"
                }                
                $description = $md.Description.text -join [Environment]::NewLine
                if ($description) {
                    "### $($description)"
                }
                
                $md.alertset.alert.text -join [Environment]::NewLine
                foreach ($example in $md.examples.example) {
                    $exampleNumber++
                    
                    # Combine the code and remarks
                    $exampleLines = 
                        @(
                            $example.Code
                            foreach ($remark in $example.Remarks.text) {
                                if (-not $remark) { continue }
                                $remark
                            }
                        ) -join ([Environment]::NewLine) -split '(?>\r\n|\n)' # and split into lines

                    # Anything until the first non-comment line is a markdown predicate to the example
                    $nonCommentLine = $false
                    $markdownLines = @()

                    # Go thru each line in the example as part of a loop
                    $codeBlock = @(foreach ($exampleLine in $exampleLines) {
                        # Any comments until the first uncommentedLine are markdown
                        if ($exampleLine -match '^\#' -and -not $nonCommentLine) {
                            $markdownLines += $exampleLine -replace '^\#' -replace '^\s+'
                        } else {
                            $nonCommentLine = $true
                            $exampleLine
                        }
                    }) -join [Environment]::NewLine
                    
                    # Join all of our markdown lines together                        
                    $markdownLines -join [Environment]::NewLine
                    "~~~PowerShell"
                    $codeBlock
                    "~~~"
                }
            ) -join [Environment]::NewLine
            continue nextInput
        }        
        if ($md -is [ScriptBlock]) {
            "<pre><code class='language-powershell'>$(
                [Web.HttpUtility]::HtmlEncode(
                    "$md"
                )
            )</code><pre>"
            continue nextInput
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