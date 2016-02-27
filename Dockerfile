FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN apt-get install libasound2 git curl zip wget libgtk2.0-0 libnss3-1d libgconf2-4 libxss1 libxtst6 ruby -y  # install all dependencies needed
RUN git clone https://github.com/WhisperSystems/Signal-Desktop.git  # clone the repository (note: we clone from master which is dangerous)
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -  # install npm and add a source for nodejs
RUN sudo apt-get install -y nodejs  # install nodejs from the above source
RUN cd /Signal-Desktop/ && npm install  # run npm install to install all the needed dependencies
RUN gem install sass  # install sass (needed to build signal deskto) via gem
RUN cd /Signal-Desktop/ && node_modules/grunt-cli/bin/grunt  # run grunt to build signal desktop
RUN cd /Signal-Desktop/dist/ && zip -r ../../package.nw *  # create the package
RUN wget http://dl.nwjs.io/v0.13.0-beta3/nwjs-sdk-v0.13.0-beta3-linux-x64.tar.gz  # download nwjs to run the package directly
RUN tar xfz nwjs-sdk-v0.13.0-beta3-linux-x64.tar.gz  # extract nwjs
RUN cp /package.nw /SignalDesktop.zip  # create the SignalDesktop.zip that can then be loaded in Google Chrome
RUN mv /package.nw /nwjs-sdk-v0.13.0-beta3-linux-x64/  # move the package into the nwjs directory

# Below snippet borrowed from: http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
USER developer
ENV HOME /home/developer

RUN export DISPLAY=:0.0  # set the X DISPLAY to use
RUN export QT_GRAPHICSSYSTEM="native"  # tell QT the graphics system
RUN sudo chown developer:developer /nwjs-sdk-v0.13.0-beta3-linux-x64/ -R  # change the owner of the nwjs folder
RUN sudo chmod 777 //nwjs-sdk-v0.13.0-beta3-linux-x64/ -R  # change permissions in the nwjs folder
CMD /nwjs-sdk-v0.13.0-beta3-linux-x64/nw  # execute Signal Desktop via nwjs

