xhost +local:
docker run -it \
	--name test-gui \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    dso-devel bash