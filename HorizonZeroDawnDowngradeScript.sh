#!/bin/sh

HORIZON_ZERO_DAWN_DIRECTORY="$HOME/.steam/debian-installation/steamapps/common/Horizon Zero Dawn" # Default Horizon Zero Dawn install directory.
REQUIRED_APT_PACKAGES="wget unzip snapd"  # Used to store all tools needed from apt
PACKAGES_TO_FETCH=""  # Used to store all tools that need to be installed, used, then removed.

# Install required tools
clear
echo "Checking system for required tools..."

# For every required package that is not installed, add it to PACKAGES_TO_FETCH.
for PACKAGE in $REQUIRED_APT_PACKAGES
do
  if ! dpkg-query -W "$PACKAGE"  | grep "ok installed"
  then
    PACKAGES_TO_FETCH="$PACKAGES_TO_FETCH $PACKAGE"
  fi
done

# If any packages are not installed, install them all in one go.
if [ -z "$PACKAGES_TO_FETCH" ]
then
  sudo apt -y install $PACKAGES_TO_FETCH
fi

# Install the dotnet-sdk to run the DepotDownloader.dll file if it is not already there.
DOTNET_RUNTIME_INSTALLED=$(snap list | grep dotnet-runtime-60)
if [ -z "$DOTNET_RUNTIME_INSTALLED" ]
then
  sudo snap install dotnet-runtime-60 --classic
fi

# Download DepotDownloader
clear
echo "Downloading DepotDownloader..."
wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.4.5/depotdownloader-2.4.5.zip

# Unzip DepotDownloader
clear
echo "Unzipping DepotDownloader..."
unzip -o depotdownloader-2.4.5.zip -d depotDownloader

# Create files for -filelist DepotDownloader argument
echo "HorizonZeroDawn.exe" > 1151642.txt
echo "LocalCacheDX12/HashDB.bin" > 1151641.txt
echo "LocalCacheDX12/ShaderLocationDB.bin" >> 1151641.txt
echo "Packed_DX12/Patch.bin" >> 1151641.txt

# Get Steam username and prepare user for two passwords and two-factor authentication
clear
echo "Your Steam username and password as well as two-factor authentication are required to download from the depot."
echo "Please input your Steam username."
read -r USERNAME
echo "Please input your Steam password. The console will not print anything but your keystrokes are being read."
stty -echo
read -r PASSWORD
stty echo

# Get real install directory if default install directory does not exist
while [ ! -d "$HORIZON_ZERO_DAWN_DIRECTORY" ]
do
  echo "The directory $HORIZON_ZERO_DAWN_DIRECTORY does not exist."
  echo "Please input the directory in which you installed Horizon Zero Dawn."
  read -r HORIZON_ZERO_DAWN_DIRECTORY
done
echo "Using directory $HORIZON_ZERO_DAWN_DIRECTORY as Horizon Zero Dawn install directory."

# Perform downloads
clear
dotnet-runtime-60.dotnet depotDownloader/DepotDownloader.dll -app 1151640 -depot 1151642 -manifest 2110572734960666938 -username "$USERNAME" -password "$PASSWORD" -filelist 1151642.txt
dotnet-runtime-60.dotnet depotDownloader/DepotDownloader.dll -app 1151640 -depot 1151641 -manifest 8564283306590138028 -username "$USERNAME" -password "$PASSWORD" -filelist 1151641.txt

# Copy files to Horizon Zero Dawn install directory
clear
echo "Copying files to Horizon Zero Dawn's install directory..."
cp depots/1151642/7874181/HorizonZeroDawn.exe "$HORIZON_ZERO_DAWN_DIRECTORY/HorizonZeroDawn.exe"
cp -rT depots/1151641/7874181/LocalCacheDX12 "$HORIZON_ZERO_DAWN_DIRECTORY/LocalCacheDX12"
cp -rT depots/1151641/7874181/Packed_DX12 "$HORIZON_ZERO_DAWN_DIRECTORY/Packed_DX12"

# Clean up
clear
echo "Cleaning up..."

# Remove files that are no longer needed.
rm -rf depotDownloader depots 1151641.txt 1151642.txt depotdownloader-2.4.5.zip

# Uninstall packages that were installed by this script.
if [ -z "$PACKAGES_TO_FETCH" ]
then
  sudo apt -y remove $PACKAGES_TO_FETCH
fi
if [ -z "$DOTNET_RUNTIME_INSTALLED" ]
then
  sudo snap remove dotnet-runtime-60
fi

# Finish
clear
echo "Finished. Horizon Zero Dawn has been rolled back to the 1.10 hotfix patch."