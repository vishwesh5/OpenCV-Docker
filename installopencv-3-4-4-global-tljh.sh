#!/bin/sh

#Specify OpenCV version
cvVersion="3.4.4"

# Save current working directory
cwd=$(pwd)
sudo apt -y update
sudo apt -y upgrade

sudo apt -y remove x264 libx264-dev
 
## Install dependencies
sudo apt -y install build-essential checkinstall cmake pkg-config yasm
sudo apt -y install git gfortran
sudo apt -y install libjpeg8-dev libpng-dev
 
sudo apt -y install software-properties-common
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
sudo apt -y update
 
sudo apt -y install libjasper1
sudo apt -y install libtiff-dev
 
sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
sudo apt -y install libxine2-dev libv4l-dev
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd "$cwd"
 
sudo apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt -y install libgtk2.0-dev libtbb-dev qt5-default
sudo apt -y install libatlas-base-dev
sudo apt -y install libfaac-dev libmp3lame-dev libtheora-dev
sudo apt -y install libvorbis-dev libxvidcore-dev
sudo apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt -y install libavresample-dev
sudo apt -y install x264 v4l-utils
 
# Optional dependencies
sudo apt -y install libprotobuf-dev protobuf-compiler
sudo apt -y install libgoogle-glog-dev libgflags-dev
sudo apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

#sudo apt -y install python3-dev python3-pip
#sudo -E pip3 install -U pip numpy
#sudo apt -y install python3-testresources

cd $cwd
sudo -E conda -y install -c quantstack -c conda-forge xeus-cling
sudo -E conda -y install pip
sudo -E pip install cmake wheel numpy scipy matplotlib scikit-image scikit-learn ipython
sudo -E pip install dlib 
sudo -E pip install opencv-contrib-python==3.4.4.19

######################################

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 3.4
cd ..
 
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout 3.4
cd ..


cd opencv
mkdir build
cd build


cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=/usr/local \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..

make -j$(nproc)
sudo make install
sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig

cd $cwd

wget http://dlib.net/files/dlib-19.16.tar.bz2
tar -xvjf dlib-19.16.tar.bz2
cd dlib-19.16
mkdir build
#mkdir ../dlib-installation
cd build
cmake -DBUILD_SHARED_LIBS=1 ..
make
sudo make install

cd $cwd

rm -rf opencv
rm -rf opencv_contrib
rm -rf dlib-19.16
rm -rf dlib-19.16.tar.bz2
