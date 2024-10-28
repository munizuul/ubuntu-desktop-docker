# ubuntu-desktop-docker

##Build
```
docker build -t ubuntu-desktop .
```

##Run
```
docker run -d -p 5901:5901 -p 6080:6080 ubuntu-desktop

```

##Access

Connect to the vm using vncviewer at localhost:5901
