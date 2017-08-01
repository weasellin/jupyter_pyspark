# jupyter pyspark

This is a dockerized jupyter notebook server with multiple pyspark kernels,

which is based on the [scipy-notebook image](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook).

### Usage

How to build:

    $ git clone https://github.com/weasellin/jupyter_pyspark.git
    $ cd jupyter_pyspark
    $ docker build -t `IMAGE_NAME` .

How to configurate pyspark kernels:

* Alter the configuration list in `spark_version.list`
    * `SPARK_VERSION`: spark release pre-built version, please refer to [http://d3kbcqa49mib13.cloudfront.net/] for availabilities
    * `PYTHON_VERSION`: python version, build-in `python2` or `python3` in the based image `scipy-notebook`
    * `KERNEL_TEMPLATE`: template file for `kernel.json`, optionally to setup the kernel json template under `kernel_template`
    * `SCRIPT_PROFILE`: script set for ipython profile startup, optionally to setup the startup script under `profile_script`
* Rebuild image
