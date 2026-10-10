# Neovim LSP / Formatter 管理 (mason 非使用)

mason は使わず、LSP / フォーマッタを以下のように管理する。

| 管理元                      | 用途                                                                  |
| --------------------------- | --------------------------------------------------------------------- |
| Homebrew (`Brewfile`)       | ネイティブ系 (lua_ls / ty / stylua / shfmt / taplo)                   |
| uv (`uv tool`)              | Python 系 (ruff)                                                      |
| rustup (`rustup component`) | Rust 系 (rust_analyzer / rustfmt)                                     |
| bun (`nvim/lsp`)            | JS/TS 系 (ts_ls / yamlls / bashls / cssls / jsonls / html / prettier) |

関連ファイル:

| ファイル                             | 役割                                                            |
| ------------------------------------ | --------------------------------------------------------------- |
| `nvim/lua/plugins/lsp.lua`           | LSP の有効化と `cmd` 定義 (`vim.lsp.config` / `vim.lsp.enable`) |
| `nvim/lua/plugins/conform.lua`       | フォーマッタ設定 (prettier を bun 経由に)                       |
| `nvim/lua/lsp_bin.lua`               | bun プロジェクトの bin パスを共有                               |
| `nvim/lsp/package.json` + `bun.lock` | JS/TS 系ツールの固定 (lockfile)                                 |
| `Brewfile`                           | ネイティブ系ツール                                              |
| `nvim/scripts/install-lsp.sh`        | まとめてインストール                                            |

## インストール

### まとめて

```
nvim/scripts/install-lsp.sh
```

### 個別

```
brew bundle --file Brewfile
uv tool install ruff
rustup component add rust-analyzer rustfmt
cd nvim/lsp && bun install --frozen-lockfile
```

※ brew の ts_ls / prettier / bashls / yamlls / ruff は node 依存などの理由で使わない。

## 管理一覧 (どのコマンドがどのファイルの LSP / Formatter か)

| コマンド                       | 管理元 | LSP / Formatter             | 対象                                   |
| ------------------------------ | ------ | --------------------------- | -------------------------------------- |
| `lua-language-server`          | brew   | lua_ls (LSP)                | *.lua                                  |
| `ty`                           | brew   | ty (LSP)                    | *.py                                   |
| `ruff`                         | uv     | ruff (LSP + formatter)      | *.py                                   |
| `stylua`                       | brew   | stylua (formatter)          | *.lua                                  |
| `shfmt`                        | brew   | shfmt (formatter)           | *.sh, *.bash                           |
| `taplo`                        | brew   | taplo (formatter)           | *.toml                                 |
| `rust-analyzer`                | rustup | rust_analyzer (LSP)         | *.rs                                   |
| `rustfmt`                      | rustup | rustfmt (formatter)         | *.rs                                   |
| `typescript-language-server`   | bun    | ts_ls (LSP)                 | *.ts, *.tsx, *.js, *.jsx               |
| `yaml-language-server`         | bun    | yamlls (LSP)                | *.yaml, *.yml                          |
| `bash-language-server`         | bun    | bashls (LSP)                | *.sh, *.bash                           |
| `vscode-langservers-extracted` | bun    | cssls / jsonls / html (LSP) | *.css, *.json, *.html                  |
| `prettier`                     | bun    | prettier (formatter)        | css / html / js / json / markdown / ts |

## 設定キー ↔ 実行ファイル

`ts_ls` と `typescript-language-server` のように名前が一致しないものがあるが、これは別物。

| 名前                         | 正体                                                                                                                                                              |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ts_ls`                      | **設定キー / クライアント名** (論理名)。`vim.lsp.enable("ts_ls")` で使う識別子。`:LspInfo` や `vim.lsp.get_clients()[i].name`、`LspAttach` 通知にもこの名前が出る |
| `typescript-language-server` | **実行ファイル名** (プロセス)。OS が起動する実際のコマンド                                                                                                        |

`vim.lsp.config("<名前>")` / `vim.lsp.enable("<名前>")` は**名前をキーにして設定を引く**。
nvim-lspconfig は runtimepath の `lsp/<名前>.lua` に各サーバの設定を置いており、
Neovim はその名前のファイルを読み込む。

`lsp/ts_ls.lua` の中身 (実際のファイル):

```lua
---@type vim.lsp.Config
return {
  init_options = { hostInfo = 'neovim' },
  cmd = function(dispatchers, config)
    local cmd = 'typescript-language-server'          -- ← 実行ファイルはここで指定
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then cmd = local_cmd end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  -- 以下 filetypes / root_markers / settings などが続く
}
```

このように `lsp/ts_ls.lua` には `cmd` (実行ファイル) 以外にも
`filetypes` / `root_markers` / `init_options` / `settings` が入っている。他サーバの実例:

```lua
-- lsp/ruff.lua
cmd = { 'ruff', 'server' }, filetypes = { 'python' },
root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' }
-- lsp/ty.lua
cmd = { 'ty', 'server' }, filetypes = { 'python' }, root_markers = { 'ty.toml', ... }
-- lsp/bashls.lua
cmd = { 'bash-language-server', 'start' }
```

**キー (`ts_ls`) を合わせて初めて、これらの既定設定を継承できる。**
もし `vim.lsp.config("typescript-language-server", ...)` と書いても
`lsp/typescript-language-server.lua` は存在しないため、`filetypes` や `root_markers` を
自分で全部書く必要がある。

`ts_ls` のような名前は nvim-lspconfig の命名規則 (安定した識別子) であり、
実行ファイル名とは独立に決められている (実際 `ts_ls` は以前 `tsserver` というキーだった)。

### 現在の対応表

| 設定キー        | 実行ファイル                  |
| --------------- | ----------------------------- |
| `ts_ls`         | `typescript-language-server`  |
| `yamlls`        | `yaml-language-server`        |
| `bashls`        | `bash-language-server`        |
| `cssls`         | `vscode-css-language-server`  |
| `jsonls`        | `vscode-json-language-server` |
| `html`          | `vscode-html-language-server` |
| `lua_ls`        | `lua-language-server`         |
| `ruff`          | `ruff`                        |
| `ty`            | `ty`                          |
| `rust_analyzer` | `rust-analyzer`               |

### `cmd` を上書きしている理由

既定の `cmd` は「PATH 上の `typescript-language-server` を直接起動する」前提。
ところがそれは node shebang なので node が必要。そこで**キーは `ts_ls` のまま**にして、
`cmd` だけを bun 経由に差し替えている。

```lua
vim.lsp.config("ts_ls", { cmd = bun_cmd("typescript-language-server", { "--stdio" }) })
--               ^^^^^ 設定を継承するキー            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 実際に起動する実行ファイル
```

対応付けを消すことはできない (nvim-lspconfig を使う限りキーは必須)。
消せるのは `cmd` の上書きだけ。bun プロジェクトの bin を PATH に通す、
または実行ファイル名のラッパーを置けば既定 `cmd` のまま動くが、その場合もキーは必要。
逆にキーと実行ファイル名を一致させたいなら nvim-lspconfig を使わず
`vim.lsp.start({ name=..., cmd=..., root_dir=..., filetypes=... })` を自分で呼ぶことになる
(既定設定を自分で全部書く必要がある)。

対応を調べる方法:

- nvim-lspconfig の `lsp/<キー>.lua` を見る (`cmd` フィールド)
- Neovim 内で `:checkhealth vim.lsp` / `:LspInfo`
- `:help lspconfig-all`

## なぜ bun で node サーバが動くのか

- npm の CLI は `#!/usr/bin/env node` を持ち、bun はデフォルトでこの shebang を尊重する
  (= node が無いと起動できない)。
- `bun --bun <script>` を付けると shebang を無視して Bun ランタイムで実行する。
  内部では bun 自身への `node` シンボリックリンクを一時 dir に作り PATH 先頭に差し込むため、
  node 未インストールでも動く。
- 本設定では lockfile で固定した実体を `bun --bun <lsp_bin>/<name>` で直接起動する
  (`bunx --bun` と違い起動時に npm 解決が走らない)。

## `--stdio` について

LSP の通信路の指定。nvim は `vim.lsp.rpc.start()` で stdin/stdout を使うため、
サーバは stdio モードで起動する必要がある。

| サーバ                                           | 起動引数                |
| ------------------------------------------------ | ----------------------- |
| `ts_ls` / `yamlls` / `cssls` / `jsonls` / `html` | `--stdio` (必須)        |
| `bashls`                                         | `start` (stdio モード)  |
| `lua_ls` / `ruff` / `ty` / `rust_analyzer`       | 引数なし (既定で stdio) |

メッセージは `Content-Length: N\r\n\r\n{json}` で framing されるため、
サーバのログは stderr に出す必要がある (stdout に出すとプロトコルが壊れる)。

## 注意

`nvim/lsp/package.json` はコメント付き (JSONC)。bun はこれを許容するが、
npm など他ツールでは不正な JSON になるため `bun add` 等で触る際は注意。
