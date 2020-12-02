$LogFileName = 'transcode-sundaymorning-' + (Get-Date -UFormat "%Y-%m-%d").tostring() + '.log'
$LogFileName = Join-Path -Path $PSScriptRoot -ChildPath $LogFileName
#Write-Output $LogFileName
$PSDefaultParameterValues['Out-File:FilePath'] = $LogFileName
$PSDefaultParameterValues['Out-File:Append'] = $true

Write-Output 'Starting transcode-sundaymorning.ps1...' | Out-File
$path = 'C:\Users\acejo\Videos\TV\CBS Sunday Morning (1979)'
#$path = 'C:\Users\acejo\Videos\TV\tasteMAKERS (2018)'
$cmd = "$PSScriptRoot\HandBrakeCLI.exe"
$destinationFolder = 'T:\tv\CBS Sunday Morning (1979)'
#$destinationFolder = 'C:\Users\acejo\Videos\TV\tasteMAKERS (2018)\Season 02\Transcoded\'
$exitCode = 0

$tsFiles = @(Get-ChildItem $path -Filter *.ts -Recurse)
Write-Output "Found $($tsFiles.Length) sundaymornings to encode..." | Out-File
foreach ($tsFile in $tsFiles)
{
    Write-Output "Working on $($tsFile.FullName)..." | Out-File
    $outputFileName = Join-Path -Path $($tsFile.DirectoryName) -ChildPath ($tsFile.BaseName + '-1.m4v')
    #Write-Output $outputFileName
    $destinationFolder = Join-Path -Path $destinationFolder -ChildPath $tsFile.Directory.Name
    #Write-Output $destinationFolder
    Write-Output 'Beginning HandbrakeCLI encode...' | Out-File
    & $cmd --preset-import-file $PSScriptRoot\preset.json -Z sundaymorning --audio-lang-list "English" --all-audio -i "$($tsFile.FullName)" -o "$outputFileName" 2>> $LogFileName
    #Write-Output "HandbrakeCLI result: $? $LastExitCode" | Out-File
    #Write-Output "HandbrakeCLI result: $? $LastExitCode" | Out-File
    
    if($LastExitCode -ne 0)
    {
        Write-Output 'Failed encode; continuing to next' | Out-File
        $exitCode = 1
        continue #if handbrakecli isn't successful don't copy or delete anything, move on to next file
    }

    Write-Output 'Finished encode, copying to tower...' | Out-File
    New-Item -Force $destinationFolder -ItemType "directory" #this will create the folder if it doesn't exist
    
    Copy-Item -Path $outputFileName -Destination $destinationFolder
    Write-Output $? | Out-File
    if ($? -eq $false) #Copy-Item was false
    {
        Write-Output 'Copy to tower was unsuccessful; continuing to next' | Out-File
        $exitCode = 1
        continue #If copy was unsuccessful then don't delete, move on to next file
    }

    Write-Output 'Renaming .ts and local .m4v' | Out-File
    #uncomment these out when sure copy/script is good
    #Remove-Item $tsFile.FullName #delete the .ts file
    #Remove-Item $outputFileName #delete the local .m4v file
    #rename them until we start to delete them
    Rename-Item $tsFile.FullName ($tsFile.FullName + '.old')
    Rename-Item $outputFileName ($outputFileName + '.old')

    break #just do one file for now

    #TODO log handbrakecli output to txt file
    #better comment script
    #validate handbrakecli was successful?
    #copy-item the file to tower, validate success
    #remove-item the .ts file

}

Write-Output 'transcode-sundaymorning.ps1 finished' | Out-File

exit $exitCode