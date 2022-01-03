#!/bin/sh

# If the directory below is wrong, get the right one by pressing "Settings -> Manage -> Browse local files" for Horizon Zero Dawn on Steam. Don't forget to put quotes around it.
HORIZON_ZERO_DAWN_DIRECTORY="$HOME/.steam/debian-installation/steamapps/common/Horizon Zero Dawn"

# Install required tools
clear
echo "If this script was not run as root your password may be required to install some tools."
# Install wget to fetch depotDownloader
sudo apt -y install wget
echo "wget was installed via apt"
# Install unzip to extract depotDownloader
sudo apt -y install unzip
echo "unzip was installed via apt"
# Install snapd to install the dotnet-sdk
sudo apt -y install snapd
echo "snapd was installed via apt"
# Install the dotnet-sdk to run the DepotDownloader.dll file
sudo snap install dotnet-sdk --classic
echo "dotnet-sdk was installed via snap"

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
read -r username
echo "Please input your Steam password. The console will not print anything but your keystrokes are being read."
stty -echo
read -r password
stty echo

# Perform downloads
clear
sudo dotnet depotDownloader/DepotDownloader.dll -app 1151640 -depot 1151642 -manifest 2110572734960666938 -username "$username" -password "$password" -filelist 1151642.txt
sudo dotnet depotDownloader/DepotDownloader.dll -app 1151640 -depot 1151641 -manifest 8564283306590138028 -username "$username" -password "$password" -filelist 1151641.txt

# Copy files to Horizon Zero Dawn install directory
clear
echo "Copying files to Horizon Zero Dawn's install directory..."
#sudo chown "$USER" depots
cp depots/1151642/7874181/HorizonZeroDawn.exe "$HORIZON_ZERO_DAWN_DIRECTORY/HorizonZeroDawn.exe"
cp -rT depots/1151641/7874181/LocalCacheDX12 "$HORIZON_ZERO_DAWN_DIRECTORY"/LocalCacheDX12
cp -rT depots/1151641/7874181/Packed_DX12 "$HORIZON_ZERO_DAWN_DIRECTORY"/Packed_DX12

# Clean up
clear
echo "Cleaning up..."
sudo rm -rf depotDownloader depots 1151641.txt 1151642.txt depotdownloader-2.4.5.zip

# Finish
echo "Finished. Horizon Zero Dawn has been rolled back to the 1.10 hotfix patch."
