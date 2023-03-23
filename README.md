# Docker-Pygame-GPU
## Running Pygame in Docker with GPU and sound support 

The following Dockerfile is the result of many hours of search to make Docker work with Pygame (and also other apps that need GPU and sound support) 

It's been tested on a system with integrated intel GPU and Ubuntu 20 

I've used another project of mine called Evil Pong as a demostration 

## What do you need?

- Ubuntu 20 
- Docker 

## How to use it?

first download the Dockerfile from this repository 

in the terminal run:
```
sudo docker build -it evil_pong 
```
after the image is ready run:
```
xhost+ 
```
```
sudo docker run -d -it -e -rm DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e PULSE_SERVER=unix:/run/user/1000/pulse/native -v /run/user/1000/pulse/native:/run/user/1000/pulse/native evil_pong
```

the game should start automatically 

you could try other projects instead, in the Dockerfile replace git clone https://github.com/sagi-l/Evil_Pong.git /app with the project you want to use 

I hope this little project will help you! 
