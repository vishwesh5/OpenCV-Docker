#!/bin/bash -i

############## WELCOME #############
# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build
rm -rf installation

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
sudo apt-get -y install uuid uuid-dev

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
sudo apt-get -y install libssl1.0.0

# Optional dependencies
sudo apt-get -y install libprotobuf-dev protobuf-compiler
sudo apt-get -y install libgoogle-glog-dev libgflags-dev
sudo apt-get -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen wget vim
echo "================================"

# Install Anaconda 3
wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
chmod u+x Anaconda3-5.2.0-Linux-x86_64.sh
./Anaconda3-5.2.0-Linux-x86_64.sh -b -p ~/anaconda3
#CONDA_DIR=$(which conda)
#echo $CONDA_DIR
#CONDA_DIR=${CONDA_DIR:0:${#CONDA_DIR}-10}
#echo $CONDA_DIR
CONDA_DIR=~/anaconda3
#export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/x86_64-linux-gnu:~/anaconda3/lib:$LD_LIBRARY_PATH
######### VERBOSE ON ##########

echo "Complete"


# Step 3: Install Python libraries
$CONDA_DIR/bin/conda install -y xeus-cling notebook -c QuantStack -c conda-forge && \
$CONDA_DIR/bin/conda create -y -f -n OpenCV-"$cvVersion"-py2 python=2.7 anaconda && \
$CONDA_DIR/bin/conda install -y -n OpenCV-"$cvVersion"-py2 numpy==1.14.0 scipy matplotlib scikit-image scikit-learn ipython ipykernel && \
$CONDA_DIR/bin/conda create -y -f -n OpenCV-"$cvVersion"-py3 python=3.6 anaconda && \
$CONDA_DIR/bin/conda install -y -n OpenCV-"$cvVersion"-py3 numpy==1.14.0 scipy matplotlib scikit-image scikit-learn ipython ipykernel && \
source $CONDA_DIR/bin/activate OpenCV-"$cvVersion"-py2 && \
python -m ipykernel install --name OpenCV-"$cvVersion"-py2 --user && \
source $CONDA_DIR/bin/activate OpenCV-"$cvVersion"-py3 && \
python -m ipykernel install --name OpenCV-"$cvVersion"-py3 --user
#source deactivate

cd $CONDA_DIR/envs/
mkdir OpenCV-"$cvVersion"-py2/opencv_include && \
cp -r OpenCV-"$cvVersion"-py2/include/* OpenCV-"$cvVersion"-py2/opencv_include && \
cp -r OpenCV-"$cvVersion"-py2/opencv_include/python2.7/* OpenCV-"$cvVersion"-py2/opencv_include && \
mkdir OpenCV-"$cvVersion"-py3/opencv_include && \
cp -r OpenCV-"$cvVersion"-py3/include/* OpenCV-"$cvVersion"-py3/opencv_include && \
cp -r OpenCV-"$cvVersion"-py3/opencv_include/python3.6m/* OpenCV-"$cvVersion"-py3/opencv_include

cd $cwd

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
mkdir installation
cd installation
mkdir OpenCV-"$cvVersion"
cd $cwd
cd opencv
mkdir build
cd build

if [ "$cvVersionChoice" -eq 2 ]; then
        cmake -DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=../../installation/OpenCV-"$cvVersion" \
	-DINSTALL_C_EXAMPLES=ON \
	-DBUILD_EXAMPLES=ON \
	-DWITH_TBB=ON \
	-DWITH_V4L=ON \
	-DWITH_QT=ON \
	-DWITH_OPENGL=ON \
	-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-DPYTHON2_EXECUTABLE=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/bin/python \
	-DPYTHON2_INCLUDE_DIR=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/opencv_include \
	-DPYTHON2_LIBRARY=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/libpython2.7.so \
	-DPYTHON2_NUMPY_INCLUDE_DIRS=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/python2.7/site-packages/numpy/core/include \
	-DPYTHON2_PACKAGES=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/python2.7/site-packages \
	-DPYTHON3_EXECUTABLE=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/bin/python \
	-DPYTHON3_INCLUDE_DIR=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/opencv_include \
	-DPYTHON3_LIBRARY=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/libpython3.6m.so \
	-DPYTHON3_NUMPY_INCLUDE_DIRS=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/python3.6/site-packages/numpy/core/include \
	-DPYTHON3_PACKAGES_PATH=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/python3.6/site-packages ..

else
        cmake -DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=../../installation/OpenCV-"$cvVersion" \
	-DINSTALL_C_EXAMPLES=ON \
	-DENABLE_CXX11=ON \
	-DBUILD_EXAMPLES=ON \
	-DWITH_TBB=ON \
	-DWITH_V4L=ON \
	-DWITH_QT=ON \
	-DWITH_OPENGL=ON \
	-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-DPYTHON2_EXECUTABLE=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/bin/python \
	-DPYTHON2_INCLUDE_DIR=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/opencv_include \
	-DPYTHON2_LIBRARY=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/libpython2.7.so \
	-DPYTHON2_NUMPY_INCLUDE_DIRS=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/python2.7/site-packages/numpy/core/include \
	-DPYTHON2_PACKAGES=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py2/lib/python2.7/site-packages \
	-DPYTHON3_EXECUTABLE=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/bin/python \
	-DPYTHON3_INCLUDE_DIR=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/opencv_include \
	-DPYTHON3_LIBRARY=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/libpython3.6m.so \
	-DPYTHON3_NUMPY_INCLUDE_DIRS=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/python3.6/site-packages/numpy/core/include \
	-DPYTHON3_PACKAGES_PATH=$CONDA_DIR/envs/OpenCV-"$cvVersion"-py3/lib/python3.6/site-packages ..

fi

make -j4
sudo make install
sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
cd ../..

# Create symlink in virtual environment
py2binPath=$(find $cwd/installation/OpenCV-$cvVersion/lib/ -type f -name "cv2.so")
py3binPath=$(find $cwd/installation/OpenCV-$cvVersion/lib/ -type f -name "cv2.cpython*.so")

# Link the binary python file
cd $CONDA_DIR/envs/OpenCV-$cvVersion-py2/lib/python2.7/site-packages/
ln -f -s $py2binPath cv2.so

cd $CONDA_DIR/envs/OpenCV-$cvVersion-py3/lib/python3.6/site-packages/
ln -f -s $py3binPath cv2.so

# Install dlib
echo "================================"
echo "Installing dlib"

cd $cwd

wget http://dlib.net/files/dlib-19.15.tar.bz2 && \
tar xvf dlib-19.15.tar.bz2 && \
cd dlib-19.15 && \
mkdir build && \
cd build && \
cmake .. && \
make && \
sudo make install && \
sudo ldconfig && \
cd ..

cd $cwd/dlib-19.15

source $CONDA_DIR/bin/activate OpenCV-"$cvVersion"-py2
python setup.py install
rm -rf $cwd/dlib-19.15/dist
rm -rf $cwd/dlib-19.15/tools/python/build
source $CONDA_DIR/bin/activate OpenCV-"$cvVersion"-py3
python setup.py install
rm -rf $cwd/dlib-19.15/dist
rm -rf $cwd/dlib-19.15/tools/python/build

# Print instructions
echo "================================"
echo "Installation completed successfully"

#rm $CONDA_DIR/envs/OpenCV-3.4.1-py3/lib/libfontconfig.so.1 && \
#rm $CONDA_DIR/envs/OpenCV-3.4.1-py2/lib/libfontconfig.so.1
cd $cwd
echo 'PATH="~/anaconda3/bin:$PATH"' >> ~/.bashrc
#echo 'export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:~/anaconda3/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:~/anaconda3/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# Install tensorflow

source activate OpenCV-"$cvVersion"-py2
pip install numpy==1.14.0
pip install argparse==1.1 msgpack
pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.10.0-cp27-none-linux_x86_64.whl
source deactivate
source activate OpenCV-"$cvVersion"-py3
pip install numpy==1.14.0
pip install argparse==1.1 msgpack
pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.10.0-cp36-cp36m-linux_x86_64.whl
source deactivate

# Install darknet
cd $cwd
git clone https://github.com/pjreddie/darknet.git
cd darknet
make

# Install GOTURN
sudo apt-get -y install libtinyxml-dev 
# For Ubuntu >= 17.04
# sudo apt -y install caffe-cpu
# For Ubuntu < 17.04
sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get -y install --no-install-recommends libboost-all-dev

