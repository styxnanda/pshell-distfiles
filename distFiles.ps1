# Prompt for the source folder
# WARNING: Do not use quotation mark for the path
# This can be easily added in near future version.
$sourceFolder = Read-Host "Enter the full path of the source folder"

# Display source folder path to double-check
Write-Host "Entered source folder path: $sourceFolder"

# Verify path
if (-not (Test-Path -Path $sourceFolder)) {
    Write-Host "The specified path does not exist. Please check the path and try again."
    exit # Immediately exit
}

# Get all files
$files = Get-ChildItem -Path $sourceFolder -File

# Show number of files in the folder (Takes time, depends on your PC's performance and OS)
$totalFiles = $files.Count
Write-Host "The source folder contains $totalFiles files."

# Input the number of folders to distribute into
$numFolders = Read-Host "Enter the number of folders"

# Calculate the number of files per folder
$filesPerFolder = [math]::Ceiling($totalFiles / $numFolders)

# Initialize the folder counter, used as identifier
$folderCounter = 1

# Loop through the files and transfer into destination folders
for ($i = 0; $i -lt $totalFiles; $i += $filesPerFolder) {
    # Create the destination folder path inside the source folder
    # Name of the folders can be adjusted here, current ex: 1, 2, 3, 4, ..., n
    # Another example, if you want to change it to Folder1, Folder2, ..., FolderN,
    # then change the following line into $destinationFolder = "$sourceFolder\Folder$folderCounter"
    $destinationFolder = "$sourceFolder\$folderCounter"
    # Future improvement, make it able to load from dictionary of folder names and loop it
    
    # Create the destination folder if it doesn't exist
    if (-not (Test-Path -Path $destinationFolder)) {
        New-Item -Path $destinationFolder -ItemType Directory
    }

    # Get the files for the current folder
    $currentFiles = $files[$i..([math]::Min($i + $filesPerFolder - 1, $totalFiles - 1))]

    # Move the current files to the destination folder
    foreach ($file in $currentFiles) {
        Move-Item -Path $file.FullName -Destination $destinationFolder
    }

    # Increment the folder counter for next loop
    $folderCounter++
}

#Confirm completion and show files per folder (last folder exception)
Write-Host "Files have been successfully split into $numFolders folders with up to $filesPerFolder files each."