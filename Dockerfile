FROM ubuntu:16.04

MAINTAINER Vishwesh Ravi Shrimali <vishweshshrimali5@gmail.com>

# Setup Environment Variable
RUN cvVersionChoice=1
RUN cvVersion="3.4.1"
RUN cwd=$(pwd)

RUN apt-get update && \
	apt-get remove -y \
	x264 libx264-dev && \
	apt-get install -y \
	build-essential \
	checkinstall \
	cmake \
	pkg-config \
	yasm \
	git \
	gfortran \
	libjpeg8-dev \
	libjasper-dev \
	libpng12-dev \
	libtiff5-dev \
	libtiff-dev \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	libdc1394-22-dev \
	libxine2-dev \
	libv4l-dev

RUN cd /usr/include/linux && \
	ln -s -f ../libv4l1-videodev.h videodev.h && \
	cd $cwd

RUN apt-get install -y \
	libgstreamer0.10-dev \
	libgstreamer-plugins-base0.10-dev \
	libgtk2.0-dev \
	libtbb-dev \
	qt5-default \
	libatlas-base-dev \
	libfaac-dev \
	libmp3lame-dev \
	libtheora-dev \
	libvorbis-dev \
	libxvidcore-dev \
	libopencore-amrnb-dev \
	libopencore-amrwb-dev \
	libavresample-dev \
	x264 \
	v4l-utils \
	libprotobuf-dev \
	protobuf-compiler \
	libgoogle-glog-dev \
	libgflags-dev \
	libgphoto2-dev \
	libeigen3-dev \
	libhdf5-dev \
	doxygen

RUN apt-get install -y \
	python-dev \
	python-pip \
	python3-dev \
	python3-pip

RUN pip2 install -U pip numpy && \
	pip3 install -U pip numpy

RUN apt-get install -y python3-testresources

#RUN python3 -m pip uninstall pip && \
#	apt install python3-pip --reinstall

#RUN python -m pip uninstall pip && \
#	apt install python-pip --reinstall

RUN pip2 install -U virtualenv virtualenvwrapper && \
	pip3 install -U virtualenv virtualenvwrapper

RUN echo "# Virtual Environment Wrapper" >> ~/.bashrc && \
	echo "source ~/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc && \
	cd $cwd && \
	source ~/.local/bin/virtualenvwrapper.sh

RUN mkvirtualenv OpenCV-"$cvVersion"-py2 -p python2 && \
	workon OpenCV-"$cvVersion"-py2 && \
	pip install numpy scipy matplotlib scikit-image scikit-learn ipython && \
	pip install ipykernel && \
	deactivate && \
	mkvirtualenv OpenCV-"$cvVersion"-py3 -p python3 && \
	workon OpenCV-"$cvVersion"-py3 && \
	pip install numpy scipy matplotlib scikit-image scikit-learn ipython && \
	pip install ipykernel && \
	deactivate

RUN git clone https://github.com/opencv/opencv.git && \
	cd opencv && \
	git checkout $cvVersion && \
	cd ..

RUN git clone https://github.com/opencv/opencv_contrib.git && \
	cd opencv_contrib && \
	git checkout $cvVersion && \
	cd ..

RUN cd opencv && \
	mkdir build && \
	cd build

RUN cmake -DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=$cwd/installation/OpenCV-$cvVersion \
	-DINSTALL_C_EXAMPLES=ON \
	-DWITH_TBB=ON \
	-DWITH_V4L=ON \
	-DWITH_QT=ON \
	-DWITH_OPENGL=ON \
	-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-DBUILD_EXAMPLES=ON ..

RUN make -j4 && make install

RUN sh -c 'echo "/usr/local/lib" >> etc/ld.so.conf.d/opencv.conf'
RUN ldconfig

RUN py2binPath=$(find /usr/local/lib/ -type f -name "cv2.so")
RUN py3binPath=$(find /usr/local/lib/ -type f -name "cv2.cpython*.so")

RUN cd ~/.virtualenvs/OpenCV-$cvVersion-py2/lib/python2.7/site-packages && \
	ln -s -f py2binPath cv2.so

RUN cd ~/.virtualenvs/OpenCV-$cvVersion-py3/lib/python3.6/site-packages && \
	ln -s -f py3binPath cv2.so

RUN workon OpenCV-$cvVersion-py2
RUN python -m ipykernel install --name OpenCV-$cvVersion-py2
RUN deactivate

RUN workon OpenCV-$cvVersion-py3
RUN python -m ipykernel install --name OpenCV-$cvVersion-py3
RUN deactivate

RUN apt-get install wget && \
	wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh && \
	chmod u+x Anaconda3-5.2.0-Linux-x86_64.sh && \
	./Anaconda3-5.2.0-Linux-x86_64.sh -b && \
	echo 'export PATH="~/anaconda3/bin:$PATH"' >> ~/.bashrc && \
	source ~/.bashrc

RUN conda install xeus-cling notebook -c QuantStack -c conda-forge
RUN conda install jupyterhub==0.8.1


