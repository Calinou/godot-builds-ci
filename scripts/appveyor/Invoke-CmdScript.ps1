# Script by Brad Wilson
# https://gist.github.com/bradwilson/3fca203370d54304eff1cce21ffc32aa

param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)][string] $Script,
    [Parameter(Position=1, Mandatory=$false)][string] $Parameters
)

$tempFile = [IO.Path]::GetTempFileName()

cmd /c " `"$script`" $parameters && set > `"$tempFile`" "

Get-Content $tempFile | %{
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Content "env:\$($matches[1])" $matches[2]
    }
}

Remove-Item $tempFile
