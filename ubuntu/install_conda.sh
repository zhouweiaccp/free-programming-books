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

# 在这里插入图片描述在这里插入图片描述
# 查看环境列表，新环境已经创建好
# 在这里插入图片描述
# 激活环境，默认处于base环境，进入其他环境需要使用source activate手动切换
# 在这里插入图片描述
# 若要退出当前环境，使用source deactivate，默认回到base 环境
# 在这里插入图片描述
# 这里提示命令“source deactivate”已经废弃了，使用“conda deactivate”

# 6 进入环境安装依赖包
# 进入环境后，可使用如下命令安装依赖的包，使用的是已经配置好的清华的源，这里以“opencv-python”包为例，由于使用了清华大学的镜像源，下载速度很快。

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple opencv-python

# pytorch已发布1.1.0版本，升级至pytorch最新版本命令。

# pip install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple torch torchvision
# 1
# 2019.11.08记录
# 最近发现清华的镜像源关闭了。
# 换回conda默认的源，访问起来可能有些慢，但总比无法访问好。。

# conda config --remove-key channels