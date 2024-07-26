---
title: Linux系统配置常用链接列表
date: 2024-07-26
summary: Linux系统配置常用链接列表，以Ubuntu为主，包括了apt镜像、docker、python、zsh等
categories:
  - 资料汇总
tags:
  - linux
  - 工具
---
### Ubuntu

- [Ubuntu Releases](https://www.releases.ubuntu.com/)
- [Ubuntu 22.04.3 LTS (Jammy Jellyfish)](https://www.releases.ubuntu.com/jammy/)
- [Ubuntu 20.04.6 LTS (Focal Fossa)](https://www.releases.ubuntu.com/focal/)
- [Ubuntu 18.04.6 LTS (Bionic Beaver)](https://www.releases.ubuntu.com/bionic/)

### CentOS

[Download (centos.org)](https://www.centos.org/download/)

### 镜像仓库

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak #最好还是先备份一下，真的~

sudo vi /etc/apt/sources.list
```

[ubuntu | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)

[上海交通大学 Linux 用户组 软件源镜像服务 (sjtu.edu.cn)](https://mirrors.sjtug.sjtu.edu.cn/docs/ubuntu)

常用软件：tmux；ssh；build-essential；

### python和pip

- `sudo ln -sf /usr/bin/python3 /usr/bin/python` #给python链接到python3
- python要安装别的版本直接问gpt就行
- [Installation - pip documentation v23.3 (pypa.io)](https://pip.pypa.io/en/stable/installation/#get-pip-py)
  - `wget https://bootstrap.pypa.io/get-pip.py`
  - sudo python get-pip.py

- pip源：
  - [上海交通大学 Linux 用户组 软件源镜像服务 (sjtu.edu.cn)](https://mirrors.sjtug.sjtu.edu.cn/docs/pypi/web/simple)

### docker

- 安装docker

  [Install Docker Engine on Ubuntu | Docker Docs](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

- run without sudo

  [Linux post-installation steps for Docker Engine | Docker Docs](https://docs.docker.com/engine/install/linux-postinstall/)

- docker源

  [上海交通大学 Linux 用户组 软件源镜像服务 (sjtu.edu.cn)](https://mirrors.sjtug.sjtu.edu.cn/docs/docker-registry)

- docker-compose

  [Install Compose standalone | Docker Docs](https://docs.docker.com/compose/install/standalone/#on-linux)

### 代理

[Releases · trojan-gfw/trojan (github.com)](https://github.com/trojan-gfw/trojan/releases)

### zsh相关

- [Installing ZSH · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#install-and-set-up-zsh-as-default)
- [ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh#prerequisites)

ohmyzsh没有代理安装起来总是失败，可以换用下面的方法：

```bash
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
chmod +x install.sh
vim install.sh
# 修改git仓库为gitee,找到下面两行并进行修改
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
==>
REPO=${REPO:-mirrors/oh-my-zsh}
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
# 保存后执行
sh install.sh
```

- [powerlevel10k: A Zsh theme (github.com)](https://github.com/romkatv/powerlevel10k#oh-my-zsh)

- 插件

  ```
  # zsh-syntax-highlighting 需要代理
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  # zsh-autosuggestions 需要代理
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```

  ```
  # vim ~/.zshrc
  plugins=(
          git
          zsh-autosuggestions
          zsh-syntax-highlighting
          z
          sudo
          # tmux
  )
  ```

***

### 待续~
