FROM ubuntu:22.10

# Set build arguments for user and group IDs
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    pulseaudio \
    alsa-utils \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xauth \
    xvfb \
    xterm \
    fontconfig \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Pygame and Pygame GUI
RUN pip3 install pygame pygame_gui

# adding user and group to pulseaudio 
RUN groupadd -g 1000 usergroup && \
    useradd -u 1000 -g usergroup -G audio -d /home/pulseaudio pulseaudio && \
    mkdir -p /home/pulseaudio && \
    chown pulseaudio:usergroup /home/pulseaudio

# Clone repository into /app directory
RUN mkdir /app \
    && git clone https://github.com/sagi-l/Evil_Pong.git /app 

# Set working directory
WORKDIR /app

RUN chown pulseaudio:usergroup /app/scores.json && chmod 664 /app/scores.json

# Set the PulseAudio environment variable
ENV PULSE_SERVER=unix:/run/user/$USER_ID/pulse/native

# Set the non-root user as the default user for the container
USER pulseaudio

# Start PulseAudio server
CMD ["pulseaudio", "--start", "--log-target=syslog", "--log-level=4"]

# Start Evil Pong game 

CMD ["python3", "main.py"]

#if you want to run the container indefinitley (but the game won't autostart uncomment):

#CMD tail -f /dev/null

# after the container is runnig type xhost+ in the terminal 

# use this to run the container (remove both #):
# docker run -d -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e 
# PULSE_SERVER=unix:/run/user/1000/pulse/native -v /run/user/1000/pulse/native:/run/user/1000/pulse/native evil_pong2
