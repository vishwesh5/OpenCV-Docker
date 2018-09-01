# OpenCV-Docker

The power of smaller things has never been unknown to the human world. Especially when it comes to computers, the smaller the better. Docker is just one of those **small** things that can make your life *exceedingly* simple. Now don't you worry. We are not going to go into the tits and bits of Docker. Let's directly jump to the use of Docker for our benefit. While Virtual Machine is a commonly known solution for creating machines for specific purpose, their biggest negative is the large file size (**~30 GB!!!**). Docker wins in comparison to it since the docker images by default are stored and downloaded in compressed form. So a machine of size 30 GB will have an image of size not more than 8 GB.

Now, let's see how we can install Docker and the Docker image for OpenCV - 4.0.0

# Docker Installation

## Ubuntu
1. To install docker on Ubuntu 16.04, first add the GPG key for the official Docker repository to the system:

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

2. Add the Docker repository to APT sources:

`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`

3. Next, update the package database with the Docker packages from the newly added repo:

`sudo apt-get update`

4. Make sure you are about to install from the Docker repo instead of the default Ubuntu 16.04 repo:

`apt-cache policy docker-ce`

5. You should see output similar to the follow:

```docker-ce:
  Installed: (none)
  Candidate: 17.03.1~ce-0~ubuntu-xenial
  Version table:
     17.03.1~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
```
6. Finally, install Docker:

`sudo apt-get install -y docker-ce`

## MacOS

1. To install Docker on MacOS desktop, first go to the [Docker Store](https://store.docker.com/editions/community/docker-ce-desktop-mac) and download **Docker Community Edition for Mac**.

2. Double-click Docker.dmg to open the installer, then drag Moby the whale to the Applications folder.

3. Double-click Docker.app in the Applications folder to start Docker.

4. You are prompted to authorize Docker.app with your system password after you launch it. Privileged access is needed to install networking components and links to the Docker apps.

*The whale in the top status bar indicates that Docker is running, and accessible from a terminal.*

## Windows 7 or above

1. Download and install [Docker Toolbox for Windows](https://download.docker.com/win/stable/DockerToolbox.exe). The installer adds Docker Toolbox, VirtualBox, and Kitematic to your **Applications** folder.

2. On your Desktop, find the Docker QuickStart Terminal icon.

3. Double click the **Docker QuickStart** icon to launch a pre-configured Docker Toolbox terminal.

If the system displays a **User Account Control** prompt to allow VirtualBox to make changes to your computer, choose **Yes**.
The terminal does several things to set up Docker Toolbox for you. When it is done, the terminal displays the `$` prompt.

# Installing Docker OpenCV Image

# Docker Image Instructions

To use the docker image, use the following instructions:

For **OpenCV-3.4.1**:
`docker pull spmallick/opencv-docker:opencv-3.4.1`

`docker run -it -p 8888:8888 -p 5000:5000 spmallick/opencv-docker /bin/bash`

For **OpenCV-4.0.0**:
`docker pull spmallick/opencv-docker:opencv-4`

`docker run -it -p 8888:8888 -p 5000:5000 spmallick/opencv-docker:opencv-4 /bin/bash`

To use Python environments:

`source activate OpenCV-3.4.1-py2`

`ipython`

`import cv2`

`cv2.__version__`

`exit()`

`source deactivate`

Similarly for Python 3.6,

`source activate OpenCV-3.4.1-py3`

`ipython`

`import cv2`

`cv2.__version__`

`exit()`

`source deactivate`

For **OpenCV-4.0.0** installation, replace **`OpenCV-3.4.1-py2`** with **`OpenCV-master-py2`** and **`OpenCV-3.4.1-py3`** with **`OpenCV-master-py3`**.

The image also has **dlib** installed for both Python environments. 

`source activate OpenCV-3.4.1-py2`

`ipython`

`import dlib`

`dlib.__version__`

`exit()`

`source deactivate`
