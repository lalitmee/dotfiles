#!/bin/bash
cd /tmp || exit
echo "Downloading Postman ..."
wget -q https://dl.pstmn.io/download/latest/linux?arch=64 -O postman.tar.gz
tar -xzf postman.tar.gz
rm postman.tar.gz

echo "Installing to opt..."
if [ -d "/opt/Postman" ];then
    sudo rm -rf /opt/Postman
fi
sudo mv Postman /opt/Postman

echo "Creating symbolic link..."
if [ -L "/usr/bin/postman" ];then
    sudo rm -f /usr/bin/postman
fi
sudo ln -s /opt/Postman/Postman /usr/bin/postman

echo "Creating .desktop file..."
if [ -e "/usr/share/applications/Postman.desktop" ];then
    sudo rm /usr/share/applications/Postman.desktop
fi
sudo mv Postman.desktop /usr/share/applications/Postman.desktop

echo "Installation completed successfully."
echo "You can use Postman!"
