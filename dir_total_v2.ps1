# dir_total script. shows number of files and directory sizes.
# someday wish list 
#     ask for file type and only show those # and sizes
#     show calculated time spent finding the data
# 
#
# Get the current directory and log location $temprod = Get-Content -Path ENv:\USERPROFILE

$currentDirectory = Get-Location 
$templog = Get-Content -Path ENv:\USERPROFILE
# date for banner
$ddd=date
# Display the current directory and log location
Write-Output "*****************"
write-output "Happy $($ddd.dayofweek)"
WRITE-OUTPUT "Starting directory file search.  You are at directory: $($currentDirectory.Path)"
write-output "This will write to screen and also log data to $($templog)"
Write-output "Are you Ready? If not, type Ctrl-C to break"
pause

#Start of directory scan
# date for banner
$d=date
### ask user what directory to look into
##$start_dir = read-host "Enter the starting directory or hit enter to continue"
##  ask user what megabyte size (or defaults)
##$sizer= read-host "Enter the size in megabytes or hit enter to continue"
## how to log to file and write-host?  out-file sends to file,  use two commands
## state to op that logging is enabled to c:\users\home 
##

# Define the list of directories
#$directories = @("C:\Users\1167190223C\temp", "C:\Path\To\Directory2", "C:\Path\To\Directory3")
#get directories
$hashdirs = Get-ChildItem -directory | Select-Object FullName | Out-String -stream



# Create an array to store the results
$results = @()

foreach ($row in $hashdirs) {
#    if (Test-Path $row -PathType Container) {
        # Get all files in the directory and subdirectories
        $files = Get-ChildItem -Path $row -Recurse -File

        # Count the number of files
        $fileCount = $files.Count

        # Calculate the total file size in bytes
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum

        # Convert total size from bytes to megabytes
        $totalSizeMB = [math]::Round($totalSize / 1MB, 2)

        # Store the results in a custom object
        $result = [PSCustomObject]@{
            Directory   = $row
            FileCount   = $fileCount
            TotalSizeMB = $totalSizeMB
        }

        # Add the result to the array
        $results += $result

    }


# Display the results
$results | Format-Table -AutoSize
# show the seconds elapsed by subtracting date set in line 12
$nd=date
write-host "Seconds elapsed $($nd.subtract($d).totalseconds)"

# write results to log
date | Out-File -append $templog\dirsize.txt 
$results | Format-Table -AutoSize | Out-File -append $templog\dirsize.txt  
