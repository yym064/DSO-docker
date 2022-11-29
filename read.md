docker run -it \
	--name test-gui \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/arketi/projects/data:/home/data" \
	dso-devel bash


bin/dso_dataset \
files=/home/data/dso_data/sequence_02/images.zip \
calib=/home/data/dso_data/sequence_02/camera.txt \
gamma=/home/data/dso_data/sequence_02/pcalib.txt \
vignette=/home/data/dso_data/sequence_02/vignette.png \
preset=0 \
mode=0