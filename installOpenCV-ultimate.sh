#!/bin/sh

echo "OpenCV installation by learnOpenCV.com"

echo "Installing OpenCV - 3.4.3"
 
#Specify OpenCV version
cvVersion="3.4.3"

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

# Save current working directory
cwd=$(pwd)

apt -y update
apt -y upgrade

apt -y remove x264 libx264-dev
 
## Install dependencies
apt -y install build-essential checkinstall cmake pkg-config yasm
apt -y install git gfortran
apt -y install libjpeg8-dev libjasper-dev libpng12-dev
 
apt -y install libtiff5-dev
 
apt -y install libtiff-dev
 
apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
apt -y install libxine2-dev libv4l-dev
cd /usr/include/linux
ln -s -f ../libv4l1-videodev.h videodev.h
cd $cwd
 
apt -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
apt -y install libgtk2.0-dev libtbb-dev qt5-default
apt -y install libatlas-base-dev
apt -y install libfaac-dev libmp3lame-dev libtheora-dev
apt -y install libvorbis-dev libxvidcore-dev
apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
apt -y install libavresample-dev
apt -y install x264 v4l-utils
 
# Optional dependencies
apt -y install libprotobuf-dev protobuf-compiler
apt -y install libgoogle-glog-dev libgflags-dev
apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

apt -y install python3-dev python3-pip
pip3 install -U pip numpy
apt -y install python3-testresources
# Install virtual environment
python3 -m pip install virtualenv virtualenvwrapper
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
echo "VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "# Virtual Environment Wrapper" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
cd $cwd
source /usr/local/bin/virtualenvwrapper.sh

############ For Python 3 ############
# create virtual environment
mkvirtualenv OpenCV-"$cvVersion"-py3 -p python3
workon OpenCV-"$cvVersion"-py3
 
# now install python libraries within this virtual environment
pip install numpy scipy matplotlib scikit-image scikit-learn ipython dlib
 
# quit virtual environment
deactivate
######################################

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout tags/3.4.3
cd ..
 
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout tags/3.4.3
cd ..

cd opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=/usr/local \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
            -D OPENCV_SKIP_PYTHON_LOADER=ON \
            -D OPENCV_PYTHON3_INSTALL_PATH=/root/.virtualenvs/OpenCV-"$cvVersion"-py3/lib/python3.5/site-packages \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..
        
make -j$(nproc)
make install
echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf
ldconfig

#=========================================================================

echo "Installing OpenCV - 3.4.4"
 
#Specify OpenCV version
cvVersion="3.4.4"

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

# Create directory for installation
mkdir installation
mkdir installation/OpenCV-"$cvVersion"

############ For Python 3 ############
# create virtual environment
mkvirtualenv OpenCV-"$cvVersion"-py3 -p python3
workon OpenCV-"$cvVersion"-py3
 
# now install python libraries within this virtual environment
pip install numpy scipy matplotlib scikit-image scikit-learn ipython dlib
 
# quit virtual environment
deactivate
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
            -D CMAKE_INSTALL_PREFIX=$cwd/installation/OpenCV-"$cvVersion" \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
            -D OPENCV_SKIP_PYTHON_LOADER=ON \
            -D OPENCV_PYTHON3_INSTALL_PATH=/root/.virtualenvs/OpenCV-"$cvVersion"-py3/lib/python3.5/site-packages \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..
        
make -j$(nproc)
make install

# Create symlink in virtual environment
#py3binPath=$(find $cwd/installation/OpenCV-$cvVersion/python/cv2/python-3.5/ -type f -name "cv2.cpython*.so")
 
#cd ~/.virtualenvs/OpenCV-$cvVersion-py3/lib/python3.5/site-packages/
#ln -f -s $py3binPath cv2.so

#=========================================================================

echo "Installing OpenCV - 4.0.0"
 
#Specify OpenCV version
cvVersion="master"

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

# Create directory for installation
mkdir installation
mkdir installation/OpenCV-"$cvVersion"

############ For Python 3 ############
# create virtual environment
mkvirtualenv OpenCV-"$cvVersion"-py3 -p python3
workon OpenCV-"$cvVersion"-py3
 
# now install python libraries within this virtual environment
pip install numpy scipy matplotlib scikit-image scikit-learn ipython dlib
 
# quit virtual environment
deactivate
######################################

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout master
cd ..
 
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout master
cd ..

cd opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=$cwd/installation/OpenCV-"$cvVersion" \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
            -D OPENCV_SKIP_PYTHON_LOADER=ON \
            -D OPENCV_PYTHON3_INSTALL_PATH=/root/.virtualenvs/OpenCV-"$cvVersion"-py3/lib/python3.5/site-packages \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..
        
make -j$(nproc)
make install

# Create symlink in virtual environment
#py3binPath=$(find $cwd/installation/OpenCV-$cvVersion/python/cv2/python-3.5/ -type f -name "cv2.cpython*.so")
 
#cd ~/.virtualenvs/OpenCV-$cvVersion-py3/lib/python3.5/site-packages/
#ln -f -s $py3binPath cv2.so
