# Kody Blog

[![Deploy Hugo site to Pages](https://github.com/kody-black/blog/actions/workflows/pages.yml/badge.svg)](https://github.com/kody-black/blog/actions/workflows/pages.yml)
[![Blowfish](https://img.shields.io/badge/Blowfish-v2.105.0-0284c7)](https://blowfish.page/)

Kody Black 的个人博客，记录网络安全、开发与学习笔记。

- 站点：[kody-black.github.io/blog](https://kody-black.github.io/blog/)
- 生成器：[Hugo](https://gohugo.io/)
- 主题：[Blowfish](https://blowfish.page/)

## 本地运行

需要 Hugo Extended 0.158.0 或更高版本，并初始化主题子模块：

```bash
git submodule update --init --recursive
hugo server --minify -D -E -F
```

推送到 `main` 后，GitHub Actions 会自动构建并发布到 GitHub Pages。

