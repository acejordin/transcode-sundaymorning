$LogFileName = 'transcode-sundaymorning-' + (Get-Date -UFormat "%Y-%m-%d").tostring() + '.log'
$LogFileName = Join-Path -Path $PSScriptRoot -ChildPath $LogFileName

$ErrLogFileName = 'transcode-sundaymorning-error-' + (Get-Date -UFormat "%Y-%m-%d").tostring() + '.log'
$ErrLogFileName = Join-Path -Path $PSScriptRoot -ChildPath $LogFileName

#Start-Transcript -Path $LogFileName -Append #-IncludeInvocationHeader

#Write-Output $LogFileName
$PSDefaultParameterValues['Out-File:FilePath'] = $LogFileName
$PSDefaultParameterValues['Out-File:Append'] = $true

Write-Output 'Starting transcode-sundaymorning.ps1...' | Out-File
$path = 'C:\Users\acejo\Videos\TV\CBS Sunday Morning (1979)'
#$path = 'C:\Users\acejo\Videos\TV\tasteMAKERS (2018)'
$cmd = "$PSScriptRoot\HandBrakeCLI.exe"
#$destinationFolder = 'T:\tv\CBS Sunday Morning (1979)'
#$destinationFolder = 'C:\Users\acejo\Videos\TV\tasteMAKERS (2018)\Season 02\Transcoded\'
$exitCode = 0

$tsFiles = @(Get-ChildItem $path -Filter *.ts -Recurse)
Write-Output "Found $($tsFiles.Length) sundaymorning(s) to encode..." | Out-File
foreach ($tsFile in $tsFiles) {
    Write-Output "Working on $($tsFile.FullName)..." | Out-File
    $outputFileName = Join-Path -Path $($tsFile.DirectoryName) -ChildPath ($tsFile.BaseName + '-1.m4v')
    #Write-Output $outputFileName
    #Write-Output $destinationFolder
    Write-Output 'Beginning HandbrakeCLI encode...' | Out-File
    & $cmd --preset-import-file $PSScriptRoot\preset.json -Z sundaymorning --audio-lang-list "English" --all-audio -i "$($tsFile.FullName)" -o "$outputFileName" 2>> $LogFileName
    #Write-Output "HandbrakeCLI result: $? $LastExitCode" | Out-File
    #Write-Output "HandbrakeCLI result: $? $LastExitCode" | Out-File
    
    if ($LastExitCode -ne 0) {
        Write-Output 'Encode failed; continuing to next' | Out-File
        $exitCode = 1
        continue #if handbrakecli isn't successful don't copy or delete anything, move on to next file
    }

    Write-Output 'Finished encode...' | Out-File
    Write-Output "Copying $outputFileName to $destinationFolder" | Out-File
    $destinationFolder = 'T:\tv\CBS Sunday Morning (1979)'
    #$destinationFolder = 'C:\Users\acejo\Videos\TV\tasteMAKERS (2018)\Season 02\Transcoded\'
    $destinationFolder = Join-Path -Path $destinationFolder -ChildPath $tsFile.Directory.Name
    Write-Host $destinationFolder
    New-Item -Path $destinationFolder -ItemType "directory" -Force | Out-File #this will create the folder if it doesn't exist
    #New-item -Name "ccmsetup" -Type Folder -Path "c:\temp"
    if ($? -eq $false) {
        Write-Output 'New-Item failed to create $destinationFolder' | Out-File
        $exitCode = 1
        continue
    }

    Write-Host $destinationFolder 
    Copy-Item -Path $outputFileName -Destination $destinationFolder | Out-File
    #Write-Output $? | Out-File
    if ($? -eq $false) { #Copy-Item was false
        Write-Output 'Copy failed; continuing to next' | Out-File
        $exitCode = 1
        continue #If copy was unsuccessful then don't delete, move on to next file
    }

    Write-Output 'Copy done' | Out-File
    Write-Output 'Renaming .ts and local .m4v' | Out-File
    #uncomment these out when sure copy/script is good
    #Remove-Item $tsFile.FullName #delete the .ts file
    #Remove-Item $outputFileName #delete the local .m4v file
    #rename them until we start to delete them
    Rename-Item $tsFile.FullName ($tsFile.FullName + '.old') | Out-File
    Rename-Item $outputFileName ($outputFileName + '.old') | Out-File

}

Write-Output 'transcode-sundaymorning.ps1 finished' | Out-File

exit $exitCode

#Stop-Transcript