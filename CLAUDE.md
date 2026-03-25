# Project: [TODO: プロジェクト名]

> このファイルはClaude Codeが毎セッション読み込むプロジェクト文脈です。
> 200行以内に収めてください。詳細は `.claude/rules/` や `.claude/skills/` に分割できます。

## Architecture

<!-- TODO: プロジェクトのアーキテクチャ概要を記述 -->
<!-- 例: モノレポ構成、マイクロサービス、フロントエンド+バックエンド等 -->

## Tech Stack

<!-- TODO: 使用技術を列挙 -->
<!-- 例:
- Language: TypeScript
- Framework: Next.js (App Router)
- Database: PostgreSQL + Prisma
- Testing: Vitest
- Linting: ESLint + Prettier
-->

## Build & Test Commands

<!-- TODO: Claudeがそのまま使えるコマンドを記述 -->
<!-- 例:
- Install: `npm install`
- Dev: `npm run dev`
- Build: `npm run build`
- Test all: `npm test`
- Test single: `npm test -- --testPathPattern="foo"`
- Lint: `npm run lint`
- Format: `npm run format`
-->

## Coding Standards

<!-- TODO: プロジェクト固有のルールを記述 -->
<!-- 例:
- Use ES modules (import/export), not CommonJS (require)
- Prefer named exports over default exports
- Error messages in English, comments in Japanese OK
-->

## Git Workflow

<!-- TODO: ブランチ命名、コミットメッセージ規約を記述 -->
<!-- 例:
- Branch: feature/<issue-number>-<short-description>
- Commit: conventional commits (feat:, fix:, docs:, etc.)
- PR: require 1 approval before merge
-->

## AI Team Workflow

このプロジェクトではClaude Codeのサブエージェントチームを使用しています。

### Commands
- `/start` — 朝の開始。進捗を読み込みタスクを提示する
- `/save` — 中断/完了。作業レポートと進捗を書き出す
- `/status` — 進捗一覧を表示する

### Subagents
- **implementer** — 実装タスクの委譲先。実装+テストを一体で行う
- **reviewer** — コードレビュー。実装とは別コンテキストで品質を確認する
- **tester** — テスト実行・修正の委譲先。大量出力をメインから隔離する
- **documenter** — ドキュメント生成・更新の委譲先

### Workflow Rules
- 設計は `/plan` モードで行い、人間が方針を確認してから実装に入ること
- 実装後は必ず reviewer エージェントでレビューを実施すること
- タスク区切りでは `/save` を実行し、`/clear` で次のタスクに移ること
- `/compact` は使用しない。状態はファイルに書き出して `/clear` する

## Known Issues & Gotchas

<!-- TODO: プロジェクト固有の注意点を記述 -->
<!-- 例:
- The test database must be running locally before running integration tests
- Environment variables are in .env.local (not committed)
-->
