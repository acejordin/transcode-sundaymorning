Write-Host "Staring transcode-sundaymorning.ps1..."
$path = 'C:\Users\acejo\Videos\TV\CBS Sunday Morning (1979)'
$cmd = './HandBrakeCLI.exe'
$inFileArg = ''
$outFileArg = ''

Get-ChildItem $path -Filter *.ts -Recurse | 
Foreach-Object {

    #Write-Host $_.FullName
    #Write-Host $_.Name
    #Write-Host $_.DirectoryName

    #& $cmd '--preset-import-gui' "--preset `"Custom Presets/Fast 1080p30 H.265`"" '-i' "'$($_.FullName)'" '-o' "'$($_.DirectoryName)\$($_.BaseName)-1.m4v'" #'\blah.ts'
    & $cmd '--%' '--preset-import-file preset.json' '-v' '-Z "sundaymorning"' '-a 2' '-i' "`"$($_.FullName)`"" '-o' "`"$($_.DirectoryName)\$($_.BaseName)-1.m4v`""
    #Write-Host $handbrakeCmd
    break
    #filter and save content to the original file
    #$content | Where-Object {$_ -match 'step[49]'} | Set-Content $_.FullName

    #filter and save content to a new file 
    #$content | Where-Object {$_ -match 'step[49]'} | Set-Content ($_.BaseName + '_out.log')

    #TODO log handbrakecli output to txt file
    #better comment script
    #validate handbrakecli was successful?
    #copy-item the file to tower, validate success
    #delete .ts file
}