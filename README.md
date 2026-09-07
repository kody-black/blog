# Kody Blog

[![Deploy Hugo site to Pages](https://github.com/kody-black/blog/actions/workflows/pages.yml/badge.svg)](https://github.com/kody-black/blog/actions/workflows/pages.yml)
[![Blowfish](https://img.shields.io/badge/Blowfish-v2.105.0-0284c7)](https://blowfish.page/)

Kody Black 的个人博客，记录网络安全、开发与学习笔记。

- 站点：[kody-black.github.io/blog](https://kody-black.github.io/blog/)
- 生成器：[Hugo](https://gohugo.io/)
- 主题：[Blowfish](https://blowfish.page/)

## 网页写作

访问 [Pages CMS](https://app.pagescms.org/)，用 GitHub 登录后选择本仓库的 `main` 分支。
支持新建文章、草稿、可视化正文和图片上传；首次授权与发布流程见 [写作指南](docs/writing.md)。

## 本地运行

建议使用与 CI 一致的 Hugo Extended **0.159.1**，并初始化主题子模块：

```bash
git submodule update --init --recursive
hugo server --minify -D -E -F
```

推送到 `main` 后，GitHub Actions 会自动构建并发布到 GitHub Pages。
面向 `main` 的 Pull Request 只验证构建，不部署、不申请发布权限。
构建后运行 `python scripts/check_links.py` 检查站内链接和资源路径；CI 也会执行。
检查覆盖 HTML 的 href/src/poster，不请求外部网站或验证页面内锚点。

## 主题升级

在干净的工作区中，用 Git Bash 执行 `bash update.sh`，升级到最新稳定 tag。
脚本会构建验证，但不会自动提交或推送，也不会打包无关改动。
构建失败时保留主题变更供排查；检查主题的 Hugo 版本要求，并同步调整 CI 后再测试。
预览中英文首页、文章、搜索和评论后，按脚本提示单独提交主题指针并推送。

