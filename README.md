# test

## Prerequire
- OS: Linux
- Docker
- fio

## Environment Setup
1. Clone this project and cd into directory
    ```
    $ git clone https://github.com/tomhooteh/Sync_instruction_loop_impact_other_container.git

    $ cd Sync_instruction_loop_impact_other_container
    ```
2. Build Docker Image and check if docker image is successfully build on your host
    ```
    $ sudo docker build -t sync_test .
    $ sudo docker images
    ```
    - Check if this docker image "sync_test" is displayed in the images list
3. Launch another terminal window with `htop` for observing host's resource usage
4. Launch another terminal window with `sudo docker stats` for observing docker container's resource usage.

## REFERENCES
- [Xing Gao, Zhongshu Gu, Zhengfa Li, Hani Jamjoom, Cong Wang: Houdini’s Escape. Breaking the Resource Rein of Linux Control Groups. In ACM CCS 2019.](https://gzs715.github.io/pubs/HOUDINI_CCS19.pdf)
