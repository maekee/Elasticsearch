Function Invoke-CuratorCmd {
    param ($Arguments)

    $curator_cli = "C:\Program Files\elasticsearch-curator\curator_cli.exe"
    #$Arguments = "show_indices"
    $curatorcommand = "$curator_cli $Arguments"

    $output = Invoke-Command -ScriptBlock {
        param ($curator_cli,$Arguments)
        & $curator_cli $Arguments
    } -ArgumentList $curator_cli,$Arguments

    $output
}
