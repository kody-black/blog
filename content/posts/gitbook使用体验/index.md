---
title: gitbook使用体验
date: 2024-09-20
summary: gitbook并没有本地化的接口 /(ㄒoㄒ)/~~
categories:
  - 生活分享
tags:
  - 工具
draft: false
---

想要把[HackTricks](https://book.hacktricks.xyz/v/cn)本地化，因为该项目是使用gitbook完成的，所以也去了解了一下相关的知识。

比较遗憾的是，最后发现要本地使用的话，**并没有本地化的接口**，唯一的方法就是导出为PDF，但这个还是个gitbook的付费功能~

首先，[gitbook-cli](https://github.com/GitbookIO/gitbook-cli) 已经停止维护了，如果要使用该工具的话，node大概得用14以下的版本，但是很多的新组件或者新的文档是用不了的，已经过时了。

目前GitBook主推他们的在线平台[GitBook](https://www.gitbook.com)，这是一个纯线上的文档管理平台。创建账号后有新手指南，跟着可以直接创建docs。导入资源的方法有两种，一是Import，而是使用github sync功能，前者有容量限制，稍微大点的图书就只能用后面的方法。

我们需要使用HackTricks自己构建Gitbook，可以将[HackTricks-wiki/hacktricks (github.com)](https://github.com/HackTricks-wiki/hacktricks) fork下来，然后在gitbook中将该仓库github sync，经过一些简单配置后，就可以将其变成可以自己管理的gitbook了。当然也可以发布出来[HackTricks](https://angelica.gitbook.io/hacktricks)

最后，为了保持我自己管理的HackTricks跟随主仓库自动更新，可以配置如下的Github Action

```
name: Sync with Upstream

on:
  schedule:
    - cron: '0 0 * * *'  # 每天凌晨 0 点执行
  push:
    branches:
      - master  # 当主分支有变化时也触发同步

jobs:
  sync:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
        with:
          repository: kody-black/hacktricks
          ref: master

      - name: Set up Git
        run: |
          git config --global user.email "kodyblack@example.com"
          git config --global user.name "Kody Black"

      - name: Fetch upstream
        run: |
          git remote add upstream https://github.com/HackTricks-wiki/hacktricks.git
          git fetch upstream

      - name: Merge upstream changes
        run: |
          git merge upstream/master --allow-unrelated-histories
          git push origin master
```
