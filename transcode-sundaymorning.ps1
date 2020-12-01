Write-Host "Starting transcode-sundaymorning.ps1..."
$path = 'C:\Users\acejo\Videos\TV\CBS Sunday Morning (1979)'
$cmd = './HandBrakeCLI.exe'
$destinationFolder = 'T:\tv\CBS Sunday Morning (1979)'
$LogFileName = 'transcode-sundaymorning-' + (Get-Date -UFormat "%Y-%m-%d").tostring() + '.log'
#Write-Host $LogFileName

Get-ChildItem $path -Filter *.ts -Recurse | 
Foreach-Object {

    Write-Host $_.FullName
    #Write-Host $_.FullName
    #Write-Host $_.Name
    #Write-Host $_.DirectoryName
    $outputFileName = Join-Path -Path $($_.DirectoryName) -ChildPath ($_.BaseName + '-1.m4v')
    #Write-Host $outputFileName
    $destinationFolder = Join-Path -Path $destinationFolder -ChildPath $_.Directory.Name
    #Write-Host $destinationFolder
    
    & $cmd --preset-import-file preset.json -Z sundaymorning --audio-lang-list "English" --all-audio -i "$($_.FullName)" -o "$outputFileName" 2>> $LogFileName
    Write-Host $?
    if(-Not $?)
    {
        continue #if handbrakecli isn't successful don't copy or delete anything, move on to next file
    }

    #Copy-Item -Path 'C:\Users\acejo\repos\transcode-sundaymorning\help.txt' -Destination 'C:\Users\acejo\repos\transcode-sundaymorning\help2.txt' #Copy-Item -Path $outputFileName -Destination $destinationFolder
    Copy-Item -Path $outputFileName -Destination $destinationFolder
    Write-Host $?
    if (-Not $?) #Copy-Item was false
    {
        continue #If copy was unsuccessful then don't delete, move on to next file
    }

    #uncomment these out when sure copy/script is good
    #Remove-Item $_.FullName #delete the .ts file
    #Remove-Item $outputFileName #delete the local .m4v file

    break

    #TODO log handbrakecli output to txt file
    #better comment script
    #validate handbrakecli was successful?
    #copy-item the file to tower, validate success
    #remove-item the .ts file
}