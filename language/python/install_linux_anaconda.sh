#https://mirror.tuna.tsinghua.edu.cn/help/anaconda/
# https://conda.io/projects/conda/en/latest/user-guide/overview.html
#https://blog.csdn.net/weixin_43840215/article/details/89599559
#  wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
#   bash Miniconda-3.9.1-Linux-x86_64.sh
# vim ~/.bashrc
#   export  PATH="/home/root1/anaconda3/bin/"$PATH
#   source ~/.bashrc
# conda env list
# conda create -n 3.6.7 python=3.6.7
# source activate 3.6.7
cat > /home/$USER/.condarc << EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  EOF
