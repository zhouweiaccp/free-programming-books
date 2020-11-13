wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

chmod 777 Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh

vim ~/.bashrc

export  PATH="/home/gaoxiang/miniconda3/bin:"$PATH

source ~/.bashrc
# 1
# 输入conda命令，如正常返回，说明conda安装成功
# 在这里插入图片描述

# 4 添加清华大学的镜像源
# 这样安装其他包的时候，下载速度会很快

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
conda config --set show_channel_urls yes 
conda config --get channels


# 5 环境管理命令
# 可使用如下命令查看已有环境列表，*表示当前环境，base表示默认环境

conda env list
# 1
# 在这里插入图片描述
# 使用命令“conda create -n 环境名称 python=版本号”创建环境，这里创建了名称为3.6.7（名称不是很好）的python版本号为3.6.7的虚拟环境，稍微等待，过程中输入“y”。

conda create -n 3.6.7 python=3.6.7

# 安装好后，使用activate激活某个环境
activate python34 # for Windows
source activate python34 # for Linux & Mac

# 如果想返回默认的python 2.7环境，运行
deactivate python34 # for Windows
source deactivate python34 # for Linux & Mac

# 删除一个已有的环境
conda remove --name python34 --all

# 查看当前环境下已安装的包
conda list

# 查看某个指定环境的已安装包
conda list -n python34

# 查找package信息
conda search numpy

# 安装package
conda install -n python34 numpy
# 如果不用-n指定环境名称，则被安装在当前活跃环境
# 也可以通过-c指定通过某个channel安装

# 更新package
conda update -n python34 numpy

# 删除package
conda remove -n python34 numpy

# 更新conda，保持conda最新
conda update conda

# 更新anaconda
conda update anaconda

# 更新python
conda update python

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple opencv-python

# pytorch已发布1.1.0版本，升级至pytorch最新版本命令。

# pip install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple torch torchvision
# 1
# 2019.11.08记录
# 最近发现清华的镜像源关闭了。
# 换回conda默认的源，访问起来可能有些慢，但总比无法访问好。。

# conda config --remove-key channels

windows下
在清华源和中科大源之间自行选择

1 添加清华源
命令行中直接使用以下命令

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge 
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/

# 设置搜索时显示通道地址
conda config --set show_channel_urls yes

2 添加中科大源
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/msys2/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/bioconda/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/menpo/

conda config --set show_channel_urls yes

Linux下
将以上配置文件写在~/.condarc中 
vim ~/.condarc

channels:
  - https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
  - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - defaults
show_channel_urls: true