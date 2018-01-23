# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

cd "godot/"
Copy-Item "../scripts/appveyor/Invoke-CmdScript.ps1" "."

# LTO is enabled only for 64-bit targets, as 32-bit doesn't offer enough available RAM for linking
If ($env:Arch -eq "x64") {
    Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" "-arch=x64"
    scons platform=windows tools="$env:Tools" target="$env:Target" $env:SconsFlags use_lto=yes
} ElseIf ($env:Arch -eq "x86") {
    Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" "-arch=x86"
    scons platform=windows tools="$env:Tools" target="$env:Target" $env:SconsFlags
}
