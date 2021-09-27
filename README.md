# test

## Prerequire
- OS: ubuntu
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
    - 
## Experiment
1. Docker Container without any running containers
    - 1-1: Run container
        ```
        $ sudo docker run --rm -it --name victim_container sync_test
        ```
    - 1-2: Run fio test
        ```
        # fio --filename=/dev/sdb --rw=write --ioengine=libaio --bs=4k --rwmixread=100 --iodepth=16 --numjobs=6 --runtime=6 --group_reporting --size=40mb --name=4ktest
        ```
        - normally the sequential write speed on my device is about 1700MB/s to 2200MB/s
        - ![](https://i.imgur.com/eOGYc9E.png)

        - ![](https://i.imgur.com/UME10ZK.png)

        - ![](https://i.imgur.com/tYaENBJ.png)
2. Now we launch another terminal window to run sync_loop container
    - 2-1: Run another container
    ```
    $ sudo docker run --rm -it --name sync_loop_container sync_test
    ```
    
    - 2-2: Launch the sync_loop.sh in container
    ```
    # chmod +x /sync_loop.sh
    # ./sync_loop.sh
    ```
    
    - 2-3: Run the fio test again in the vitim container
    ```
        # fio --filename=/dev/sdb --rw=write --ioengine=libaio --bs=4k --rwmixread=100 --iodepth=16 --numjobs=6 --runtime=6 --group_reporting --size=40mb --name=4ktest
    ```
    - you will see that the sequential write speed drops to about 700MB/s
    - ![](https://i.imgur.com/k1xP1LS.png)
    - now you can leave the sync_loop_container container
 3. Now adding some resources constraint on the sync_loop container
    - 3-1: Run another sync_loop container
    ```
    $ sudo docker run --rm -it --cpus=0.5 --cpuset-cpus=1 -m=2G --name sync_loop_container_2 sync_test
    ```
    - 3-2: Run the fio test again in the victim container
        ```
        # fio --filename=/dev/sdb --rw=write --ioengine=libaio --bs=4k --rwmixread=100 --iodepth=16 --numjobs=6 --runtime=6 --group_reporting --size=40mb --name=4ktest
        ```
    - ![](https://i.imgur.com/3iuWSkq.png)
    - the limitation eases some resource drain. But the sequential write speed still drop to 1000MB/s compare to normal condiction is 1700MB/s
 
 4. Adding more resources constraints on the sync_loop container
    - 4-1: Run another sync_loop container
    ```
    $ sudo docker run --rm -it --cpus=0.5 --cpuset-cpus=1 -m=2G --device-read-bps /dev/sda:1mb --device-write-bps /dev/sda:1mb --name sync_loop_container_3 sync_test
    ```
    - 4-2: Run the fio test again in the victim container
    ```
    # fio --filename=/dev/sdb --rw=write --ioengine=libaio --bs=4k --rwmixread=100 --iodepth=16 --numjobs=6 --runtime=6 --group_reporting --size=40mb --name=4ktest
    ```
    - ![](https://i.imgur.com/85rQC7w.png)
    - ![](https://i.imgur.com/RmCqLGG.png)
    - The sequential write is still below the normal condiction.
 

## REFERENCES
- [Xing Gao, Zhongshu Gu, Zhengfa Li, Hani Jamjoom, Cong Wang: Houdini’s Escape. Breaking the Resource Rein of Linux Control Groups. In ACM CCS 2019.](https://gzs715.github.io/pubs/HOUDINI_CCS19.pdf)
