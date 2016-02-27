# signalDesktopDocker

A DockerFile to build the Signal Desktop chrome extension

# Usage

For full information, see [this](http://blog.daviddworken.com/posts/building-signal-desktop-in-docker/) blog post. 

To build: ```docker build -t signal .```

If you want to run Signal Desktop directly from the container (not recommended since it is stateless so you will have to log in every time you launch it): ```docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix signal```

Instead, I would recommended importing it as a Chrome Extension. First, you will need to start the container: ```docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --cidfile=temp.cid signal```. Then ```cat temp.cid``` to get the ID of the container. Then run ```docker cp [Container ID]:/SignalDesktop.zip ./```. Then ```unzip SignalDesktop.zip```. Finally, open up Chrome and go to ```chrome://extensions``` and click on "Load unpacked extension..." and point it at the directory you unzipped the files in. 
