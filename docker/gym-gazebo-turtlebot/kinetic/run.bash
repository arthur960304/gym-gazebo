XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

echo $XAUTH

docker run -it --rm \
  --runtime=nvidia \
  --env DISPLAY \
  --env QT_X11_NO_MITSHM=1 \
  --env XAUTHORITY=$XAUTH \
  --volume "$XAUTH:$XAUTH" \
  --volume "/tmp/.X11-unix:/tmp/.X11-unix" \
  --name=gym-gazebo-turtlebot \
  --rm \
  austinderic/gym-gazebo-turtlebot:kinetic \
  /bin/bash
