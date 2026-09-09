# To build

create a running Debian 12 Bookworm RaspiOS

Run:
```
   ssh root@<your-pi>.local
   git clone --recursive https://github.com/VirusPilot/stratux
   cd stratux/image_build
   curl -fsSL https://get.docker.com -o get-docker.sh
   bash get-docker.sh
   ./build.sh
```
On your local machine:
`scp root@<your-pi>.local:/root/stratux/image_build/pi-gen/deploy/image_2026-09-08-stratux-lite.zip`

Prior to another fresh Run:
`docker rm -v pigen_work`

# Background

pi-gen is the official image builder for Raspberry PI. Stratux is using pi-gen to ensure that
Stratux images can be built efficiently and consistently.

pi-gen is used as a submodule to ensure it can be maintained and upgraded more easily. Stratux could have forked
pi-gen but that would have required more effort to keep the fork up to date.


# Local setup

The pi-gen arm64 branch should be used if your local system is arm64 (a PI, or an Apple Silicon Mac), otherwise master.

# For debugging

```
docker run -it --privileged --volumes-from=pigen_work pi-gen /bin/bash
```
