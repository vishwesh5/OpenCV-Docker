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
