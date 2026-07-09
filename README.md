# animeko-noad

[open-ani/animeko](https://github.com/open-ani/animeko) 的个人去广告构建（macOS aarch64）。

**唯一修改**（见 [noad.patch](noad.patch)，2 个文件）：

1. 过滤播放页「相关推荐」中由服务器 (`api.animeko.org`) 下发的广告项
   （带外链 `uri`、`subjectId <= 0` 的条目）—— 复用官方首页 `RecommendationRepository`
   已有的过滤规则；
2. 禁用应用内更新检查，避免自动升级回官方包。

## 工作方式

`noad-ci` 分支（默认分支）只包含 CI 配置与 patch，不含上游代码。
[noad-autobuild workflow](.github/workflows/noad-autobuild.yml) 每天 4 次检查上游
最新 release，有新版则自动：拉取 tag → 套 patch → 对齐版本号 → 构建 dmg →
发布到本仓库 [Releases](../../releases)（tag 形如 `v5.7.1-noad`）。

手动触发：Actions → noad autobuild → Run workflow（可指定 tag）。

## 安装

从 Releases 下载 dmg 拖入 Applications。首次打开若提示「无法验证开发者」：

```bash
xattr -dr com.apple.quarantine /Applications/Ani.app
```

或用 [`install-latest.sh`](install-latest.sh) 一步到位（需 `gh` CLI）。

## 许可

与上游一致：AGPL-3.0。每个 release 的完整对应源码 = 上游对应 tag + 本仓库 `noad.patch`。
