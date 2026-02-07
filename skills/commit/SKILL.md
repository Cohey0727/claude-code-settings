---
name: commit
description: ステージ済み・未ステージの変更を分析し、conventional commit形式のメッセージを自動生成してコミットを実行する。ユーザーが「コミット」「変更を保存」と言ったとき、または /commit を実行したときに使用。
tools: Bash
disable-model-invocation: true
---

# Auto Commit

Analyze git changes and create a commit with an auto-generated conventional commit message.

## Workflow

### Step 1: Check Repository State

Run these commands in parallel to gather context:

```bash
# Staged and unstaged changes
git diff --cached --stat
git diff --stat

# Detailed diffs for message generation
git diff --cached
git diff

# Untracked files
git status --short

# Recent commit messages for style reference
git log --oneline -10
```

### Step 2: Stage Changes (if needed)

If there are no staged changes but there are unstaged changes or untracked files:
- Ask the user which files to stage
- Do NOT blindly run `git add -A` or `git add .`
- Prefer staging specific files by name
- Never stage files that likely contain secrets (`.env`, `credentials.json`, etc.)

If there are already staged changes, proceed with those.

### Step 3: Analyze Changes

Analyze all staged changes to determine:

1. **Change type** - What kind of change is this?
   - `feat`: New feature or functionality
   - `fix`: Bug fix
   - `refactor`: Code restructuring without behavior change
   - `chore`: Maintenance, dependencies, config

2. **Comment** - 変更理由の簡潔な要約
   - 「何を変えたか」ではなく「なぜ変えたか」に焦点を当てる
   - 日本語で書く
   - 40文字以内に収める

3. **Body** (optional) - Additional context if the change is non-trivial
   - What problem does this solve?
   - What approach was taken and why?

### Step 4: Generate and Execute Commit

Format the commit message following conventional commits:

```
<type>: <comment> @<branch name>

<optional body>
```

Get the current branch name with `git branch --show-current` and append it with `@` prefix.

Execute the commit using a HEREDOC for proper formatting:

```bash
BRANCH=$(git branch --show-current)
git commit -m "$(cat <<EOF
<type>: <comment> @${BRANCH}

<optional body>
EOF
)"
```

### Step 5: Verify

Run `git status` after commit to confirm success. Show the user the commit hash and message.

## Rules

- NEVER commit files containing secrets (`.env`, API keys, tokens, passwords)
- NEVER use `git add -A` or `git add .` without user confirmation
- NEVER amend previous commits unless explicitly asked
- NEVER push to remote unless explicitly asked
- NEVER skip pre-commit hooks (no `--no-verify`)
- If pre-commit hook fails, fix the issue and create a NEW commit (do not amend)
- If there are no changes to commit, inform the user and stop
- Always show the generated commit message to the user before executing

## Examples

### Simple feature
```
feat: パスワードリセットメール機能を追加 @feature/auth
```

### Bug fix with body
```
fix: 決済プロバイダのnullレスポンスを処理 @fix/payment-webhook

Stripeのwebhookがキャンセルされたサブスクリプションに対してnullを返し、
コールバックエンドポイントで500エラーが発生していた。
```

### Refactor
```
refactor: クエリビルダーをリポジトリパターンに抽出 @main
```

### Multiple file types
```
feat: ベクトル埋め込みによるセマンティック検索を追加 @feature/search

OpenAIの埋め込み生成とRedisのベクトル類似検索を実装。
Redis未接続時は部分文字列検索にフォールバックする。
```
