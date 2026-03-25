# Claude Teams Template

Claude Codeでサブエージェントチームを活用するためのテンプレートです。
`.claude/` フォルダをプロジェクトにコピーして使います。

## Quick Start

### 1. テンプレートをコピー

```bash
# このリポジトリの .claude/ と scripts/ をプロジェクトにコピー
cp -r .claude/ /path/to/your-project/.claude/
cp -r scripts/ /path/to/your-project/scripts/
cp CLAUDE.md /path/to/your-project/CLAUDE.md
```

### 2. CLAUDE.md をカスタマイズ

`CLAUDE.md` を開き、`<!-- TODO -->` コメントをプロジェクトに合わせて埋めてください。

- Tech Stack（使用技術）
- Build & Test Commands（ビルド・テストコマンド）
- Coding Standards（コーディング規約）
- Git Workflow（Gitワークフロー）

### 3. Hooks をカスタマイズ

`scripts/hooks/post-edit.sh` を開き、lint/format コマンドをプロジェクトに合わせて設定してください。

```bash
# 例: Node.js プロジェクト
LINT_COMMAND="npx eslint --fix"
FORMAT_COMMAND="npx prettier --write"
```

### 4. 使い始める

```bash
cd /path/to/your-project
claude
```

## Daily Workflow

```
朝来る  →  /start   →  進捗を読み込み、今日のタスクを提示
作業    →  /plan    →  設計確認 → AI主導で実装
区切り  →  /save    →  作業レポート + 進捗更新
確認    →  /status  →  いつでも進捗一覧
```

### Commands

| コマンド | いつ使う | やること |
|----------|----------|----------|
| `/start` | 朝来たとき | 進捗を読み込み、今日のタスクを提示 |
| `/save` | 中断/完了時 | 作業レポート書き出し + 進捗更新 + clear案内 |
| `/status` | いつでも | 進捗一覧を表示 |

### Built-in Commands (Claude Code標準)

| コマンド | 用途 |
|----------|------|
| `/plan` | 設計モード。コードを変更せずに調査・計画する |
| `/clear` | コンテキストをリセット。`/save` の後に使う |
| `/memory` | CLAUDE.mdやメモリファイルの確認・編集 |

## Architecture

### Subagents

| エージェント | モデル | 役割 |
|-------------|--------|------|
| **implementer** | Sonnet | 実装・バグ修正。テストも書く |
| **reviewer** | Opus | コードレビュー。読み取り専用で安全 |
| **tester** | Sonnet | テスト実行・診断。大量出力をメインから隔離 |
| **documenter** | Sonnet | ドキュメント生成・更新 |

Claude（メインセッション）がオーケストレーターとして各エージェントに委譲します。
サブエージェントはそれぞれ独立したコンテキストで動作するため、メインの会話を汚しません。

### Hooks

| Hook | タイミング | やること |
|------|-----------|----------|
| PreToolUse (Bash) | コマンド実行前 | 危険なコマンドをブロック |
| PostToolUse (Write\|Edit) | ファイル編集後 | lint/format自動実行 |
| Stop | 応答完了時 | 未コミット変更の警告 |

### Progress Tracking

作業状態は `.claude/docs/progress/` に保存されます（gitignore対象）。

```
.claude/docs/progress/
├── current-sprint.md          ← タスク一覧
└── reports/
    └── 2026-03-25-1430.md     ← 作業レポート
```

## Design Principles

1. **土台優先**: CLAUDE.md + Hooks が基盤。エージェントはその上に載る
2. **compact不使用**: `/save` でファイルに状態を書き出し、`/clear` でリセット
3. **ビルトイン活用**: Explore, Plan, General-purpose はそのまま使う
4. **最小限のロール**: 4エージェントで過不足ない構成
5. **技術スタック非依存**: TODO箇所を埋めるだけで任意のプロジェクトに適用可能

## Customization

### Rules（パス固有ルール）

`.claude/rules/` にMarkdownファイルを追加すると、特定のファイルパターンに対するルールを定義できます。

```markdown
---
paths:
  - "src/api/**/*.ts"
---
# API Rules
- All endpoints must include input validation
- Use the standard error response format
```

### Skills（オンデマンド知識）

`.claude/skills/` にスキルファイルを追加すると、必要なときだけ読み込まれるドメイン知識を定義できます。CLAUDE.mdと違い、毎セッション読み込まれないのでコンテキストを節約できます。

### Agent Memory

各サブエージェントは `memory: project` が有効なため、`.claude/agent-memory/` にプロジェクト固有の学習を蓄積します。

- **reviewer**: 過去のレビューパターン、よくある指摘
- **tester**: 失敗パターン、flaky test情報
- **documenter**: ドキュメント規約、用語集
- **implementer**: 実装パターン、アーキテクチャ判断

## File Structure

```
.claude/
├── CLAUDE.md                    # プロジェクト文脈（要カスタマイズ）
├── settings.json                # Hooks + permissions
├── agents/
│   ├── implementer.md          # 実装者
│   ├── reviewer.md             # レビュアー
│   ├── tester.md               # テスター
│   └── documenter.md           # ドキュメンター
├── commands/
│   ├── start.md                # /start
│   ├── save.md                 # /save
│   └── status.md               # /status
├── rules/                       # パス固有ルール（任意追加）
├── skills/                      # オンデマンドスキル（任意追加）
└── docs/
    └── progress/                # 進捗管理（gitignore）

scripts/
└── hooks/
    ├── validate-command.sh     # 危険コマンドブロック
    ├── post-edit.sh            # lint/format（要カスタマイズ）
    └── quality-gate.sh         # 未コミット変更警告

CLAUDE.md                        # プロジェクト文脈（要カスタマイズ）
```
