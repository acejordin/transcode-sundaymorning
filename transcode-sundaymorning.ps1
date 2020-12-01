Write-Host "Staring transcode-sundaymorning.ps1..."
$path = 'C:\Users\acejo\Videos\TV\CBS Sunday Morning (1979)'
$cmd = './HandBrakeCLI.exe'
$destinationFolder = 'T:\tv\CBS Sunday Morning (1979)'
$LogFileName = 'transcode-sundaymorning-' + (Get-Date -UFormat "%Y-%m-%d").tostring() + '.log'
#Write-Host $LogFileName

Get-ChildItem $path -Filter *.ts -Recurse | 
Foreach-Object {

    #Write-Host $_.FullName
    #Write-Host $_.Name
    #Write-Host $_.DirectoryName
    $outputFileName = $($_.DirectoryName) + '\' + $($_.BaseName) + '-1.m4v'
    Write-Host $_.Directory.Name
    $destinationFolder = Join-Path -Path $destinationFolder -ChildPath $_.Directory.Name
    Write-Host $destinationFolder
    #--% is muy importante, see README.md
    #Write-Host $cmd '--%' '--preset-import-file preset.json' '-v' '-Z "sundaymorning"' '-a 2' '-i' "`"$($_.FullName)`"" '-o' "`"$outputFileName`""
    & $cmd --preset-import-file preset.json -Z sundaymorning -a 2 -i "$($_.FullName)" -o "$outputFileName" >> $LogFileName
    Write-Host $?
    Copy-Item -Path 'C:\Users\acejo\repos\transcode-sundaymorning\help.txt' -Destination 'C:\Users\acejo\repos\transcode-sundaymorning\help2.txt' #Copy-Item -Path $outputFileName -Destination $destinationFolder
    if ($?) #Copy-Item was true
    {

    }
    
    Write-Host $?

    break

    #TODO log handbrakecli output to txt file
    #better comment script
    #validate handbrakecli was successful?
    #copy-item the file to tower, validate success
    #delete .ts file
}