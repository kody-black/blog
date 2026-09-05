#!/bin/bash
set -e

# 按 tag 升级 Blowfish 主题。
# 不直接跟 main 分支：主题一有新提交就自动跟进，容易把线上站点用未经测试的变更打挂。
cd "$(dirname "$0")/themes/blowfish"

git fetch --tags --force
TAG=$(git tag --list "v*" --sort=-v:refname | head -n 1)

if [ -z "$TAG" ]; then
  echo "没有找到 v* 标签，终止升级" >&2
  exit 1
fi

echo "升级 Blowfish 到 $TAG"
git checkout "$TAG"

cd - > /dev/null

# 用 git add -A 而不是 git add *：后者会漏掉所有点开头的隐藏文件（比如 .gitignore）
git add -A
git commit -m "chore: 升级 Blowfish 主题至 $TAG"
git push
