---
title: 给 Hugo 博客装上可视化后台：Pages CMS 接入实战
date: 2026-09-08
draft: false
summary: 不用搬家、不用自建服务器，为 Hugo + GitHub Pages 接入 Pages CMS：从 GitHub
  授权、文章表单和图片配置，到草稿发布与常见问题。
categories:
  - 博客折腾
tags:
  - Pages CMS
  - Hugo
  - GitHub Pages
  - Blowfish
showTableOfContents: true
---
博客搭好以后，真正影响更新频率的，往往不是主题够不够好看，而是写一篇文章要经过多少步骤：新建文件、填写 Front Matter、整理图片，再提交 Git。

这次给博客接入了 **Pages CMS**，把常用操作变成网页表单。底层仍然是 Markdown 和 Git，网站也继续由 Hugo 与 GitHub Pages 发布。

本文使用本站的实际结构举例：仓库为 `kody-black/blog`，网站位于 `https://kody-black.github.io/blog/`，主题为 Blowfish。配图均为说明原理的自制示意图，不是后台截图；不同版本的界面可能有变化。

## 一、先分清：接入后台，不是迁移网站

![Pages CMS、GitHub、Hugo 与 GitHub Pages 的职责分工](/blog/uploads/pages-cms-guide/workflow.svg)

*图 1：编辑、存储、构建、托管分别由四个环节完成。*

这里选择的是 **Pages CMS 官方托管版本**。不需要在自己的服务器上安装它，也不需要把原有博客迁移到另一套系统。按照[官方快速开始](https://pagescms.org/docs/quick-start/)，登录、授权仓库并添加配置文件，即可开始接入。

它和 GitHub Pages 名字很像，但职责不同：

- **Pages CMS**：提供写作和内容管理界面。
- **GitHub 仓库**：保存文章、图片和修改历史。
- **Hugo**：把内容生成静态网页。
- **GitHub Pages**：把构建结果提供给读者访问。

本文假设你已经有能正常构建、发布的 Hugo 仓库。Pages CMS 本身不会替你搭建 Hugo 发布工作流。需要自托管后台的读者，可以另看[官方自托管指南](https://pagescms.org/docs/guides/installing/self-host/)；本文不涉及服务器部署。

## 二、准备工作与仓库授权

开始前，确认三件事：你对博客仓库有写权限；文章保存在 `content/posts`；推送到 `main` 能触发现有的发布流程。

1. 打开 [Pages CMS 后台](https://app.pagescms.org/)。
2. 使用拥有博客仓库权限的 GitHub 账号登录。
3. 按提示安装 Pages CMS GitHub App。
4. 授权时优先选择指定仓库，只选自己的博客，例如 `kody-black/blog`。
5. 回到后台，打开仓库并选择 `main` 分支。

登录和仓库授权是两件事。如果成功登录却看不到仓库，先检查 GitHub App 是否安装到了正确账号，以及授权范围里是否包含该仓库。

配置文件、文章和图片会写入所选分支。在本文的流程中，保存到 `main` 将触发构建，因此新文章一定要默认设为草稿。

## 三、用一个配置文件定义写作界面

在仓库根目录创建 `.pages.yml`。注意开头的点，不要放到 Hugo 的 `config` 目录里。

下面是一份适用于本文站点的完整基础配置。其他站点复制时，至少要修改媒体输出路径中的 `/blog` 前缀。字段、文件名等选项可查阅[内容配置文档](https://pagescms.org/docs/configuration/content/)。

```yaml
media:
  - name: inline
    label: 正文图片
    input: static/uploads
    output: /blog/uploads
    rename: random
    extensions: [jpg, jpeg, png, webp, gif]
  - name: covers
    label: 文章封面
    input: assets/uploads/covers
    output: uploads/covers
    rename: random
    extensions: [jpg, jpeg, png, webp]

content:
  - name: posts
    label: 博客文章
    type: collection
    path: content/posts
    format: yaml-frontmatter
    subfolders: true
    exclude: [_index.md, _index.en.md]
    filename:
      template: "{year}-{month}-{day}-{primary}.md"
      field: create
    view:
      primary: title
      sort: date
      order: desc
    operations:
      rename: false
      delete: false
    fields:
      - name: title
        label: 标题
        type: string
        required: true
      - name: date
        label: 发布日期
        type: date
        required: true
        options:
          format: yyyy-MM-dd
      - name: draft
        label: 草稿（关闭后保存即发布）
        type: boolean
        default: true
      - name: summary
        label: 摘要
        type: text
      - name: categories
        label: 分类
        type: string
        list: true
      - name: tags
        label: 标签
        type: string
        list: true
      - name: featureimage
        label: 封面
        type: image
        options:
          media: covers
      - name: showTableOfContents
        label: 显示目录
        type: boolean
        default: true
      - name: body
        label: 正文
        type: rich-text
        options:
          format: markdown
          media: inline
          switcher: true
```

这份配置主要做了以下几件事：

- 将 `content/posts` 映射成文章列表，排除中英文栏目首页。
- 把标题、摘要、日期、分类等 Front Matter 字段变成表单。
- 用 `body` 对应 Markdown 正文，保留源码切换入口。
- 默认启用 `draft`，减少误发布。
- 新文章使用带日期的文件名，旧文章目录保持不变。
- 禁用后台的删除和重命名操作，减少破坏链接的风险。这只是界面操作限制，不是 GitHub 权限隔离。

配置提交到所选分支后，刷新后台。现在应该能看到“博客文章”入口。若使用本地 Git，先同步远端，再只提交本次文件：

```bash
git pull --ff-only
git add .pages.yml
git commit -m "feat: configure Pages CMS"
git push origin main
```

如果后台已创建同名文件，应编辑现有文件，不要用强制推送覆盖远端内容。

## 四、图片配置：正文和封面不能混为一谈

![正文图片与封面图片的存储路径和读取方式](/blog/uploads/pages-cms-guide/media.svg)

*图 2：这是本站 Blowfish 配置下的两条图片处理路径，并非所有 Hugo 主题通用的规则。*

Pages CMS 的 `input` 表示文件存进仓库的位置，`output` 表示编辑器写入内容的路径。两者不必相同，详见[媒体配置文档](https://pagescms.org/docs/configuration/media/)。

### 正文图片

本站把正文图片存到 `static/uploads`。例如：

```text
仓库文件：static/uploads/example.png
文章引用：/blog/uploads/example.png
```

Hugo 发布静态目录时不会在 URL 中保留 `static`。同时本站部署在 `/blog/` 下，不能写成 `/uploads/example.png`，否则会请求域名根目录，造成 404。

如果你的站点直接部署在独立域名根目录，应相应改成 `/uploads`；不要照抄本站前缀。

### 文章封面

本站当前 Blowfish 模板通过页面资源或 Hugo 全局资源读取 `featureimage`，所以封面放在 `assets/uploads/covers`：

```text
仓库文件：assets/uploads/covers/example.png
封面字段：uploads/covers/example.png
```

这个字段是资源标识，不是直接提供给浏览器的静态 URL。主题读取图片后，再生成封面和缩略图地址。因此正文上传入口和封面上传入口分开配置，不能把正文 URL 直接填到封面字段里。

上传前建议压缩大图。图片进入 Git 历史后，仅删除当前文件并不会自动消除历史体积。

## 五、创建第一篇文章

![从新建文章到线上发布的检查流程](/blog/uploads/pages-cms-guide/publish.svg)

*图 3：先验证草稿，再进入发布流程。*

打开“博客文章”，创建新条目：

1. 填写标题、日期和摘要。
2. 添加分类、标签，按需选择封面。
3. 在正文编辑器里写作，插入图片和代码块。
4. 保持“草稿”开启，保存。
5. 到 GitHub 检查这次提交，确认正文和图片写到了预期目录。

[富文本编辑器](https://pagescms.org/docs/configuration/fields/rich-text/)支持 Markdown 输出和可视化／源码切换。不过，编辑器里的效果不等于最终 Hugo 页面，尤其是主题特有的排版。

建议文件名使用稳定、简短的英文，例如 `2026-09-08-pages-cms-guide.md`。发布后尽量不改文件路径，避免影响外链和基于路径关联的评论。

### 先做一次本地预览

已有本地 Hugo 环境时，先同步后台保存的内容：

```bash
git pull --ff-only
hugo server --buildDrafts --buildFuture
```

访问终端显示的本地地址，检查标题、目录、代码块、封面和正文图片。这里的预览参数允许显示草稿和未来日期文章，不应照搬到正式发布命令。

本站还可以在构建后运行：

```bash
hugo --environment production --minify
python scripts/check_links.py
```

其中 `scripts/check_links.py` 是本站额外添加的站内链接检查脚本，不是 Pages CMS 或 Hugo 自带功能。

### 确认后发布

关闭“草稿”并保存，等待 GitHub Actions 的构建和部署任务都成功，再打开线上文章检查。保存成功、构建成功、部署成功是三个不同状态。

如果日期设在未来，正式构建可能排除该文章。本文站点没有定时触发构建的任务，因此即使时间到了，也不保证自动上线；需要重新触发部署。

## 六、几处容易踩坑的地方

### 草稿不等于私密

`draft: true` 只是让正式 Hugo 构建跳过文章。若 GitHub 仓库公开，文章源文件、上传的图片以及提交历史仍可能被访问。不要把密码、个人隐私或尚不能公开的材料写进仓库。

### 含短代码的旧文章先别直接保存

Blowfish 的特殊排版、Hugo 短代码和复杂 HTML，不保证在富文本编辑器里往返转换后保持原样。首次接入时，先使用测试文章；复杂旧文章优先继续通过源码编辑，并检查 Git 差异。不要为了体验后台而批量重存旧文章。

### 本地和网页编辑要同步

在网页后台保存后，本地仓库不会自动更新。继续本地写作前先执行 `git pull --ff-only`。出现冲突时应比较两边内容，不要用强制推送跳过同步。

### 快速排查表


| 现象 | 优先检查 |
| ------------- | -------------------------------------- |
| 登录后找不到仓库 | GitHub App 授权账号和仓库范围 |
| 后台没有文章表单 | 所选分支是否有完整的根目录 `.pages.yml` |
| 正文图片 404 | `input` 是否正确，`output` 是否包含部署前缀 |
| 正文图片正常，封面没有变化 | 是否用了封面入口，`featureimage` 是否指向 assets 资源 |
| 保存后首页没有新文章 | 草稿、未来日期，以及 Actions 构建／部署状态 |
| 修改后链接或评论对应不上 | 是否改过文章文件名、slug 或目录 |
| 编辑后旧排版发生变化 | 短代码、HTML 是否被富文本转换；检查提交差异 |


## 七、这次接入的边界与小结

本站已经配置文章表单、双媒体目录和默认草稿，并通过本地构建检查了封面、正文图片路径及草稿排除行为。这不代表所有富文本内容都已通过后台端到端测试：首次使用仍应完成“新建草稿—上传图片—保存—预览”的验收。

对已经有 Hugo 博客的人来说，这套方案的价值是少做一些重复操作：不必每次手填文章元数据，也不必手动整理所有图片路径。内容仍在自己的 Git 仓库里，熟悉的本地编辑方式也保留下来。

先把第一篇文章顺畅地写出来，比继续折腾一套更复杂的发布系统更重要。