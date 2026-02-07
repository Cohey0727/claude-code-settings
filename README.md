# claude-code-settings

Claude Code のスキル・設定を管理するリポジトリ。

## セットアップ

```bash
git clone <this-repo>
cd claude-code-settings
./setup.sh
```

`setup.sh` は `skills/` 配下の各スキルを `~/.claude/skills/` にシンボリックリンクで配置します。

- 既存のシンボリックリンク → 更新
- 既存のディレクトリ（非シンボリックリンク） → スキップ（上書きしない）
- 新規 → 作成

スキルを追加・変更した後は `./setup.sh` を再実行してください。

## スキル一覧

| スキル | 呼び出し | 説明 |
|--------|----------|------|
| [commit](skills/commit/SKILL.md) | `/commit` | git の変更を分析し、conventional commit 形式のメッセージを自動生成してコミット |

### commit

変更内容を解析して以下のフォーマットでコミットメッセージを生成します。

```
<type>: <日本語コメント> @<ブランチ名>
```

**type**: `feat` / `fix` / `refactor` / `chore`

```
feat: パスワードリセットメール機能を追加 @feature/auth
fix: 決済プロバイダのnullレスポンスを処理 @fix/payment-webhook
refactor: クエリビルダーをリポジトリパターンに抽出 @main
```

## ディレクトリ構成

```
claude-code-settings/
├── README.md
├── setup.sh          # セットアップスクリプト
└── skills/
    └── commit/
        └── SKILL.md  # /commit スキル定義
```
