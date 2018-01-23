# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# Path to the InnoSetup compiler
$env:InnoSetup = "C:\Program Files (x86)\Inno Setup 5\ISCC.exe"

# Create build artifact directories
New-Item -ItemType directory -Path "$env:BuildDate\editor", "$env:BuildDate\templates"

If ($env:Tools -eq "yes") {
    If ($env:Arch -eq "x64") {
        # Create 64-bit editor ZIP archive
        Move-Item "bin\godot.windows.opt.tools.64.exe" "godot.exe"
        7z a "$env:BuildDate\editor\godot-windows-x86_64.zip" "godot.exe"
    } ElseIf ($env:Arch -eq "x86") {
        # Create 32-bit editor ZIP archive
        Move-Item "bin\godot.windows.opt.tools.32.exe" "godot.exe"
        7z a "$env:BuildDate\editor\godot-windows-x86.zip" "godot.exe"
    }
} ElseIf (($env:Tools -eq "no") -and ($env:Target -eq "release_debug")) {
    # Move the debug export templates to the build artifacts directory
    If ($env:Arch -eq "x64") {
        Move-Item "bin\godot.windows.opt.debug.64.exe" "$env:BuildDate\templates\windows_64_debug.exe"
    } ElseIf ($env:Arch -eq "x86") {
        Move-Item "bin\godot.windows.opt.debug.32.exe" "$env:BuildDate\templates\windows_32_debug.exe"
    }
} ElseIf (($env:Tools -eq "no") -and ($env:Target -eq "release")) {
    # Move the release export templates to the build artifacts directory
    If ($env:Arch -eq "x64") {
        Move-Item bin\godot.windows.opt.64.exe "$env:BuildDate\templates\windows_64_release.exe"
    } ElseIf ($env:Arch -eq "x86") {
        Move-Item bin\godot.windows.opt.32.exe "$env:BuildDate\templates\windows_32_release.exe"
    }
}

# Deploy to server using SCP
scp -Br "$env:BuildDate" "hugo@hugo.pro:/var/www/godot.hugo.pro/builds"
