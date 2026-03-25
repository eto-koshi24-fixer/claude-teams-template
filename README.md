# Claude Teams Template

Claude Codeでサブエージェントチームを活用するためのテンプレートです。

## 導入手順

### Step 1. コピー

```bash
cp -r .claude/ /path/to/your-project/.claude/
cp CLAUDE.md /path/to/your-project/CLAUDE.md
```

これだけで動きます。Hooks、エージェント、コマンド、進捗管理がすべて `.claude/` に入っています。

### Step 2. CLAUDE.md をカスタマイズ

プロジェクトルートの `CLAUDE.md` を開き、`<!-- TODO -->` をプロジェクトに合わせて埋めてください。

| セクション | 書くこと | 例 |
|-----------|----------|-----|
| Architecture | アーキテクチャ概要 | モノレポ、マイクロサービス等 |
| Tech Stack | 使用技術 | TypeScript, Next.js, PostgreSQL等 |
| Build & Test Commands | ビルド・テストコマンド | `npm test`, `npm run build` 等 |
| Coding Standards | コーディング規約 | ESModules使用、named export推奨等 |
| Git Workflow | Git運用ルール | ブランチ命名、コミット規約等 |

### Step 3. Hooks をカスタマイズ（任意）

`.claude/hooks/post-edit.sh` を開き、lint/format コマンドを設定してください。

```bash
# 例: Node.js
LINT_COMMAND="npx eslint --fix"
FORMAT_COMMAND="npx prettier --write"

# 例: Python
LINT_COMMAND="ruff check --fix"
FORMAT_COMMAND="black"
```

設定しなくてもエラーにはなりません（スキップされます）。

### Step 4. 使い始める

```bash
cd /path/to/your-project
claude
```

### 前提条件

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) がインストール済み
- `jq` がインストール済み（hookスクリプトが使用）

---

## 使い方

### 1日の流れ

```
朝来る  →  /start   →  進捗を読み込み、今日のタスクを提示
作業    →  /plan    →  設計確認 → AI主導で実装
区切り  →  /save    →  作業レポート + 進捗更新
確認    →  /status  →  いつでも進捗一覧
```

### 覚えるコマンドは3つだけ

| コマンド | いつ使う | やること |
|----------|----------|----------|
| `/start` | 朝来たとき | 進捗を読み込み、今日のタスクを提示 |
| `/save` | 中断/完了時 | 作業レポート書き出し + 進捗更新 + clear案内 |
| `/status` | いつでも | 進捗一覧を表示 |

### Claude Code標準コマンド（よく使うもの）

| コマンド | 用途 |
|----------|------|
| `/plan` | 設計モード。コードを変更せずに調査・計画する |
| `/clear` | コンテキストをリセット。`/save` の後に使う |
| `/memory` | CLAUDE.mdやメモリファイルの確認・編集 |

### サブエージェントの使い方

Claudeが自動で委譲しますが、明示的に指示もできます。

```
# 自然言語で指示
「reviewerでレビューして」
「testerでテスト走らせて」
「documenterでREADME更新して」

# @メンションで確実に委譲
@implementer この機能を実装して
@reviewer 認証周りの変更をレビューして
```

---

## アーキテクチャ

### サブエージェント（4つ）

| エージェント | モデル | 役割 |
|-------------|--------|------|
| **implementer** | Sonnet | 実装・バグ修正。テストも書く |
| **reviewer** | Opus | コードレビュー。読み取り専用で安全 |
| **tester** | Sonnet | テスト実行・診断。大量出力をメインから隔離 |
| **documenter** | Sonnet | ドキュメント生成・更新 |

Claude（メインセッション）がオーケストレーターとして各エージェントに委譲します。
サブエージェントはそれぞれ独立したコンテキストで動作するため、メインの会話を汚しません。

### Hooks（3つ）

| Hook | タイミング | やること |
|------|-----------|----------|
| PreToolUse (Bash) | コマンド実行前 | 危険なコマンドをブロック |
| PostToolUse (Write\|Edit) | ファイル編集後 | lint/format自動実行 |
| Stop | 応答完了時 | 未コミット変更の警告 |

### 進捗管理

作業状態は `.claude/docs/progress/` に保存されます。

```
.claude/docs/progress/
├── current-sprint.md          ← タスク一覧
└── reports/
    └── 2026-03-25-1430.md     ← 作業レポート
```

---

## カスタマイズ

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

---

## 設計原則

1. **土台優先** — CLAUDE.md + Hooks が基盤。エージェントはその上に載る
2. **compact不使用** — `/save` でファイルに状態を書き出し、`/clear` でリセット
3. **ビルトイン活用** — Explore, Plan, General-purpose はそのまま使う
4. **最小限のロール** — 4エージェントで過不足ない構成
5. **技術スタック非依存** — TODO箇所を埋めるだけで任意のプロジェクトに適用可能

---

## ファイル構成

```
your-project/
├── CLAUDE.md                        # プロジェクト文脈（要カスタマイズ）
└── .claude/
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
    ├── hooks/
    │   ├── validate-command.sh     # 危険コマンドブロック
    │   ├── post-edit.sh            # lint/format（要カスタマイズ）
    │   └── quality-gate.sh         # 未コミット変更警告
    ├── rules/                       # パス固有ルール（任意追加）
    ├── skills/                      # オンデマンドスキル（任意追加）
    └── docs/
        └── progress/                # 進捗管理
```
