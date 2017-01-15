# Install-Module Find-String

# Set-ExecutionPolicy unrestricted

# Install OpenSSH
# Note: do not install chocolatey. Use Install-Package instead.
# Get-PackageProvider
# Get-PackageSource -Provider chocolatey
# Install-Package -Name openssh
Add-PathVariable "${env:ProgramFiles}\OpenSSH"
Add-PathVariable "${env:ProgramFiles}\rethinkdb"
Add-PathVariable "${env:ProgramFiles}\7-Zip"
Add-PathVariable "C:\OpenSSL-Win32\bin"

# For working less (except in ISE)
# Install-Package Pscx

# For history with up/down arrows
# Install-Package PSReadLine
Import-Module PSReadLine

# https://technet.microsoft.com/en-us/magazine/hh241048.aspx
$MaximumHistoryCount = 10000

# Tab completion for git
# Install-Module posh-git
# Load posh-git example profile
# . 'C:\Users\mike\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

# https://gallery.technet.microsoft.com/scriptcenter/Get-NetworkStatistics-66057d71
. 'C:\Users\mike\powershell\Get-NetworkStatistics.ps1'

function uptime {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function edit-powershell-profile {
	subl $profile
}

function reload-powershell-profile {
	& $profile
}

# https://blogs.technet.microsoft.com/heyscriptingguy/2012/12/30/powertip-change-the-powershell-console-title/t-----BEGIN CERTIFICATE REQUEST-----\nMIIC1TCCAb8CAQAwYjFgMAkGA1UEBhMCVVMwFQYDVQQDEw5oYWdlcnNoYXJwLmNv\nbTAPBgNVBAgTCERlbGF3YXJlMBEGA1UEBxMKV2lsbWluZ3RvbjAYBgNVBAoTEUhh\nZ2VyIFNoYXJwLCBJbmMuMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA\nxdmJXC5WMATpvkR0GMjXujWlKVpx2hoJJgqWipg2TBlbPXP5S48CrUL6fey1Mybo\nCwaGyMlCaNZ2hG4rXjRkOud8z2xd+vEtPClpTY9PojVbFu8+x5WANFVavu5+1Dnb\nGFULQtDyfpyu8DyL0lcQEfUS9zXnKAU3Dgi0VHd0kGH+5D1STb755BbGW6gbT0d4\nTOZrGxgirdWamBxW4mrKqLn2rWQhejK/2Y2xDBromTCnpOg2uEFzwciuCqUSjCnh\nakP4Fcq6A+zhFJrZgCreIv1vJR/m46XylE449ze4ztZc++w8r7nriF/sg79b9yLm\nTSqSxMtoXp77k1oH2wctHwIDAQABoDAwLgYJKoZIhvcNAQkOMSEwHzAdBgNVHQ4E\nFgQUGbIwkLxtaZwiT+Fr96zfzCj6A7owCwYJKoZIhvcNAQELA4IBAQAmorvuT0Uh\nwR+9TwAWbZIItLdPOgyNx0enveA972tVHxBE2H7Hs+lK0LdwmXQ7v4IxICjdJ49J\nA2NDYabF6cH06KnZa1iMSgpKF0rknOjuGfAPy1zswLsrL4UVkkQpL6gzzPiI1hLW\nOAmH5ngTOlBRIerHerrcmvrvpbK04zotO6KyK6k3t0y07IbluV5iJP0XeSlfV0Mg\nd91KeDe1SInt3lgukzgzmytE2MaF29Hf2dHFj9cJKgwB4QqThzW3nQwfcDXo1rBd\nzqFG2PuUoVRKRYDcvQch8IFsE+Qc9f5t4ARF+4JxnPmgR8jnZTZyTbMqGztAtjog\nR1B51KhwteMM\n-----END CERTIFICATE REQUEST-----\n
function change-title([string]$newtitle) {
	$host.ui.RawUI.WindowTitle = $newtitle + ' – ' + $host.ui.RawUI.WindowTitle
}

# From http://stackoverflow.com/questions/7330187/how-to-find-the-windows-version-from-the-powershell-command-line
function get-windows-build {
	[Environment]::OSVersion
}

# http://mohundro.com/blog/2009/03/31/quickly-extract-files-with-powershell/
function unarchive([string]$file, [string]$outputDir = '') {
	if (-not (Test-Path $file)) {
		$file = Resolve-Path $file
	}

	if ($outputDir -eq '') {
		$outputDir = [System.IO.Path]::GetFileNameWithoutExtension($file)
	}

	7z e "-o$outputDir" $file
}

#######################################################
# Prompt Tools
#######################################################

# https://github.com/gummesson/kapow/blob/master/themes/bashlet.ps1
function prompt {
	$realLASTEXITCODE = $LASTEXITCODE
	Write-Host $(Truncate-HomeDirectory("$pwd")) -ForegroundColor Yellow -NoNewline
	Write-Host " $" -NoNewline
	$global:LASTEXITCODE = $realLASTEXITCODE
	Return " "
}

function Truncate-HomeDirectory($Path) {
	$Path.Replace("$home", "~")
}

function Test-FileInSubPath([System.IO.DirectoryInfo]$Child, [System.IO.DirectoryInfo]$Parent) {
	write-host $Child.FullName | select '*'
	$Child.FullName.StartsWith($Parent.FullName)
}

# Produce UTF-8 by default
# https://news.ycombinator.com/item?id=12991690
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

#######################################################
# Dev Tools
#######################################################
function subl {
	& "$env:ProgramFiles\Sublime Text 3\subl.exe" @args
}

function explorer {
	explorer.exe .
}

function gg {
	& git grep -i @args
}

# See https://jira.atlassian.com/browse/SRCTREEWIN-394 for some limits here
function stree {
	& "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe" -f $pwd
}

function open($file) {
	ii $file
}

# http://stackoverflow.com/questions/39148304/fuser-equivalent-in-powershell/39148540#39148540
function fuser($relativeFile){
	$file = Resolve-Path $relativeFile
	echo "Looking for processes using $file"
	foreach ( $Process in (Get-Process)) {
		foreach ( $Module in $Process.Modules) {
			if ( $Module.FileName -like "$file*" ) {
				$Process | select id, path
			}
		}
	}
}

#######################################################
# Useful shell aliases
#######################################################

function findfile($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}

function get-path {
	($Env:Path).Split(";")
}

#######################################################
# Unixlike commands
#######################################################

function df {
	get-volume
}

function sed($file, $find, $replace){
	(Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function sed-recursive($filePattern, $find, $replace) {
	$files = ls . "$filePattern" -rec
	foreach ($file in $files) {
		(Get-Content $file.PSPath) |
		Foreach-Object { $_ -replace "$find", "$replace" } |
		Set-Content $file.PSPath
	}
}

function grep($regex, $dir) {
	if ( $dir ) {
		ls $dir | select-string $regex
		return
	}
	$input | select-string $regex
}

function grepv($regex) {
	$input | ? { !$_.Contains($regex) }
}

function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

# Should really be name=value like Unix version of export but not a big deal
function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	ps $name -ErrorAction SilentlyContinue | kill
}

function pgrep($name) {
	ps $name
}

function touch($file) {
	"" | Out-File $file -Encoding ASCII
}

# From https://github.com/keithbloom/powershell-profile/blob/master/Microsoft.PowerShell_profile.ps1
function sudo {
	$file, [string]$arguments = $args;
	$psi = new-object System.Diagnostics.ProcessStartInfo $file;
	$psi.Arguments = $arguments;
	$psi.Verb = "runas";
	$psi.WorkingDirectory = get-location;
	[System.Diagnostics.Process]::Start($psi) >> $null
}

# https://gist.github.com/aroben/5542538
function pstree {
	$ProcessesById = @{}
	foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
		$ProcessesById[$Process.ProcessId] = $Process
	}

	$ProcessesWithoutParents = @()
	$ProcessesByParent = @{}
	foreach ($Pair in $ProcessesById.GetEnumerator()) {
		$Process = $Pair.Value

		if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
			$ProcessesWithoutParents += $Process
			continue
		}

		if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
			$ProcessesByParent[$Process.ParentProcessId] = @()
		}
		$Siblings = $ProcessesByParent[$Process.ParentProcessId]
		$Siblings += $Process
		$ProcessesByParent[$Process.ParentProcessId] = $Siblings
	}

	function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
		$Process = $ProcessesById[$ProcessId]
		$Indent = " " * $IndentLevel
		if ($Process.CommandLine) {
			$Description = $Process.CommandLine
		} else {
			$Description = $Process.Caption
		}

		Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
		foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
			Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
		}
	}

	Write-Output ("{0,6} {1}" -f "PID", "Command Line")
	Write-Output ("{0,6} {1}" -f "---", "------------")

	foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
		Show-ProcessTree $Process.ProcessId 0
	}
}

	function unzip ($file) {
		$dirname = (Get-Item $file).Basename
		echo("Extracting", $file, "to", $dirname)
		New-Item -Force -ItemType directory -Path $dirname
		expand-archive $file -OutputPath $dirname -ShowProgress
	}

# From https://certsimple.com/blog/openssl-shortcuts
function openssl-view-certificate ($file) {
	openssl x509 -text -noout -in $file
}

function openssl-view-csr ($file) {
	openssl req -text -noout -verify -in $file
}

function openssl-view-key ($file) {
	openssl rsa -check -in $file
}

function openssl-view-pkcs12 ($file) {
	openssl pkcs12 -info -in $file
}

# Connecting to a server (Ctrl C exits)
function openssl-client ($server) {
	openssl s_client -status -connect $server:443
}

# Convert PEM private key, PEM certificate and PEM CA certificate (used by nginx, Apache, and other openssl apps)
# to a PKCS12 file (typically for use with Windows or Tomcat)
function openssl-convert-pem-to-p12 ($key, $cert, $cacert, $output) {
	openssl pkcs12 -export -inkey $key -in $cert -certfile $cacert -out $output
}

# Convert a PKCS12 file to PEM
function openssl-convert-p12-to-pem ($p12file, $pem) {
	openssl pkcs12 -nodes -in $p12file -out $pemfile
}

# Convert a crt to a pem file
function openssl-crt-to-pem($crtfile) {
	v
	openssl x509 -in $crtfile -out $basename.pem -outform PEM
}

# Check the modulus of a certificate (to see if it matches a key)
function openssl-check-certificate-modulus {
	openssl x509 -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a key (to see if it matches a certificate)
function openssl-check-key-modulus {
	openssl rsa -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a certificate request
function openssl-check-key-modulus {
	openssl req -noout -modulus -in "${1}" | shasum -a 256
}

# Encrypt a file (because zip crypto isn't secure)
function openssl-encrypt () {
	openssl aes-256-cbc -in "${1}" -out "${2}"
}

# Decrypt a file
function openssl-decrypt () {
	openssl aes-256-cbc -d -in "${1}" -out "${2}"
}

# For setting up public key pinning
function openssl-key-to-hpkp-pin() {
	openssl rsa -in "${1}" -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64
}

# For setting up public key pinning (directly from the site)
function openssl-website-to-hpkp-pin() {
	openssl s_client -connect "${1}":443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
}

# Combines the key and the intermediate in a unified PEM file
# (eg, for nginx)
function openssl-key-and-intermediate-to-unified-pem() {
	echo -e "$(cat "${1}")\n$(cat "${2}")" > "${1:0:-4}"_unified.pem
}

# http://stackoverflow.com/questions/39221953/can-i-make-powershell-tab-complete-show-me-all-options-rather-than-picking-a-sp
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

echo 'Mike profile loaded.'
