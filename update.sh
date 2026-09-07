#!/bin/bash
set -euo pipefail

# 按 tag 升级 Blowfish 主题。
# 不直接跟 main 分支：主题一有新提交就自动跟进，容易把线上站点用未经测试的变更打挂。
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$ROOT"
if [[ -n $(git status --porcelain) ]]; then
  echo "请先提交或暂存现有改动，再升级主题。" >&2
  exit 1
fi
command -v hugo >/dev/null || { echo "需要安装 Hugo Extended。" >&2; exit 1; }
git submodule update --init --recursive
cd themes/blowfish

git fetch origin --tags
TAG=$(git tag --list "v*" --sort=-v:refname | awk '/^v[0-9]+\.[0-9]+\.[0-9]+$/ {tags[++n]=$0} END {if(n) print tags[1]}')

if [ -z "$TAG" ]; then
  echo "没有找到 v* 标签，终止升级" >&2
  exit 1
fi

echo "升级 Blowfish 到 $TAG"
git checkout --detach "refs/tags/$TAG"

cd "$ROOT"
hugo --environment production --minify

# 构建失败时保留主题变更供排查；成功后也先预览，再显式提交发布。
echo "构建通过，请用 hugo server 预览，再执行："
echo "git add themes/blowfish"
echo "git commit -m 'chore: 升级 Blowfish 主题至 $TAG'"
echo "git push"
