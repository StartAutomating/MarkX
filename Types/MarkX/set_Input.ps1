param(
[PSObject[]]$InputObject
)

$this | Add-Member NoteProperty '#Input' $InputObject -Force

$this.Sync()