#!/bin/bash

############## WELCOME #############
CONDA_DIR=$(which conda)
CONDA_DIR=${CONDA_DIR:0:${#CONDA_DIR}-10}

######### VERBOSE ON ##########

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

# Step 0: Take inputs
echo "OpenCV installation by learnOpenCV.com"

echo "Select OpenCV version to install (1 or 2)"
echo "1. OpenCV 3.4.1 (default)"
echo "2. Master"

read cvVersionChoice

if [ "$cvVersionChoice" -eq 2 ]; then
        cvVersion="master"
else
        cvVersion="3.4.1"
fi

# Save current working directory
cwd=$(pwd)

# Step 1: Update packages
echo "Updating packages"

sudo apt-get -y update
sudo apt-get -y upgrade
echo "================================"

echo "Complete"

# Step 2: Install OS libraries
echo "Installing OS libraries"

sudo apt-get -y remove x264 libx264-dev

## Install dependencies
sudo apt-get -y install build-essential checkinstall cmake pkg-config yasm
sudo apt-get -y install git gfortran
sudo apt-get -y install libjpeg8-dev libjasper-dev libpng12-dev

sudo apt-get -y install libtiff5-dev

sudo apt-get -y install libtiff-dev

sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
sudo apt-get -y install libxine2-dev libv4l-dev
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd $cwd

sudo apt-get -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt-get -y install libgtk2.0-dev libtbb-dev qt5-default
sudo apt-get -y install libatlas-base-dev
sudo apt-get -y install libfaac-dev libmp3lame-dev libtheora-dev
sudo apt-get -y install libvorbis-dev libxvidcore-dev
sudo apt-get -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get -y install libavresample-dev
sudo apt-get -y install x264 v4l-utils

# Optional dependencies
sudo apt-get -y install libprotobuf-dev protobuf-compiler
sudo apt-get -y install libgoogle-glog-dev libgflags-dev
sudo apt-get -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
echo "================================"

echo "Complete"


# Step 3: Install Python libraries
conda install -y xeus-cling notebook -c QuantStack -c conda-forge && \
conda create -y -f -n OpenCV-"$cvVersion"-py2 python=2.7 anaconda && \
conda install -y -n OpenCV-"$cvVersion"-py2 numpy scipy matplotlib scikit-image scikit-learn ipython ipykernel && \
conda create -y -f -n OpenCV-"$cvVersion"-py3 python=3.6 anaconda && \
conda install -y -n OpenCV-"$cvVersion"-py3 numpy scipy matplotlib scikit-image scikit-learn ipython ipykernel && \
source activate OpenCV-"$cvVersion"-py2 && \
python -m ipykernel install --name OpenCV-"$cvVersion"-py2 && \
source deactivate && \
source activate OpenCV-"$cvVersion"-py2 && \
python -m ipykernel install --name OpenCV-"$cvVersion"-py2 && \
source deactivate

echo "================================"

echo "Complete"

# Step 4: Download opencv and opencv_contrib
echo "Downloading opencv and opencv_contrib"
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout $cvVersion
cd ..

git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout $cvVersion
cd ..
echo "================================"
echo "Complete"

# Step 5: Compile and install OpenCV with contrib modules
echo "================================"
echo "Compiling and installing OpenCV with contrib modules"
cd opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=$cwd/installation/OpenCV-$cvVersion \
-D INSTALL_C_EXAMPLES=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D WITH_TBB=ON \
-D WITH_V4L=ON \
-D WITH_QT=ON \
-D WITH_OPENGL=ON \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
-DPYTHON2_EXECUTABLE=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/bin/python \
-DPYTHON2_INCLUDE_DIR=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/opencv_include \
-DPYTHON2_LIBRARY=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/libpython2.7.so \
-DPYTHON2_NUMPY_INCLUDE_DIRS=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/python2.7/site-packages/numpy/core/include \
-DPYTHON2_PACKAGES=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/python2.7/site-packages \
-DPYTHON3_EXECUTABLE=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/bin/python \
-DPYTHON3_INCLUDE_DIR=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/opencv_include \
-DPYTHON3_LIBRARY=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/libpython3.6m.so \
-DPYTHON3_NUMPY_INCLUDE_DIRS=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/python3.6/site-packages/numpy/core/include \
-DPYTHON3_PACKAGES_PATH=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/python3.6/site-packages \
-D BUILD_EXAMPLES=ON ..

make -j4
make install

# Create symlink in virtual environment
py2binPath=$(find $cwd/installation/OpenCV-$cvVersion/lib/ -type f -name "cv2.so")
py3binPath=$(find $cwd/installation/OpenCV-$cvVersion/lib/ -type f -name "cv2.cpython*.so")

# Link the binary python file
cd ~/.virtualenvs/OpenCV-$cvVersion-py2/lib/python2.7/site-packages/
ln -f -s $py2binPath cv2.so

cd ~/.virtualenvs/OpenCV-$cvVersion-py3/lib/python3.6/site-packages/
ln -f -s $py3binPath cv2.so

# Install dlib
echo "================================"
echo "Installing dlib"

wget http://dlib.net/files/dlib-19.15.tar.bz2 && \
tar xvf dlib-19.15.tar.bz2 && \
cd dlib-19.15 && \
mkdir build && \
cd build && \
cmake .. && \
make && \
make install && \
ldconfig && \
cd ..

cd $cwd/dlib-19.15

source activate OpenCV-"$cvVersion"-py2 
python setup.py install 
rm -rf $cwd/dlib-19.15/dist
rm -rf $cwd/dlib-19.15/tools/python/build
source deactivate
source activate OpenCV-"$cvVersion"-py2 
python setup.py install 
rm -rf $cwd/dlib-19.15/dist
rm -rf $cwd/dlib-19.15/tools/python/build
source deactivate


# Print instructions
echo "================================"
echo "Installation complete. Printing test instructions."

echo workon OpenCV-"$cvVersion"-py2
echo "ipython"
echo "import cv2"
echo "cv2.__version__"

if [ $cvVersionChoice -eq 2 ]; then
	       echo "The output should be 4.0.0-pre"
else
               echo The output should be "$cvVersion"
fi

echo "deactivate"

echo workon OpenCV-"$cvVersion"-py3
echo "ipython"
echo "import cv2"
echo "cv2.__version__"

if [ $cvVersionChoice -eq 2 ]; then
              echo "The output should be 4.0.0-pre"
else
              echo The output should be "$cvVersion"
fi

echo "deactivate"

echo "Installation completed successfully"
