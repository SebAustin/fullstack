# 🚀 Push to GitHub

## Current Status

- ✅ Git repository initialized
- ✅ Changes committed
- ✅ Remote added: https://github.com/SebAustin/fullstack.git
- ⏳ Ready to push to `master` branch

## 🔑 Authentication Required

GitHub requires a **Personal Access Token** (not your password).

### Step 1: Create Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click: **"Generate new token"** → **"Generate new token (classic)"**
3. Fill in:
   - **Note**: `Udagram Deployment`
   - **Expiration**: 90 days (or your preference)
   - **Scopes**: ✅ Check `repo` (full control of private repositories)
4. Click: **"Generate token"** (scroll to bottom)
5. **IMPORTANT**: Copy the token immediately (looks like: `ghp_xxxxxxxxxxxxxxxxxxxx`)
6. Save it somewhere safe - you won't see it again!

### Step 2: Configure Git Credential Helper (Optional)

To avoid entering the token every time:

```bash
# Cache credentials for 1 hour
git config --global credential.helper 'cache --timeout=3600'

# Or store permanently (less secure but convenient)
git config --global credential.helper store
```

### Step 3: Push to GitHub

```bash
cd "/Users/shenry/Documents/Personal/Training/Project/Udacity/Full Stack JavaScript Developper/Hosting a Full Stack Application/nd0067-c4-deployment-process-project-starter-master"

# Push to master branch
git push -u origin master
```

**When prompted:**
- **Username**: `SebAustin`
- **Password**: Paste your Personal Access Token (ghp_...)

### Step 4: Verify Push

Once successful, verify at:
```
https://github.com/SebAustin/fullstack
```

You should see all your code!

## 🔄 For Future Pushes

After the first push:

```bash
# Make changes
git add .
git commit -m "Your commit message"

# Push (will use cached credentials)
git push
```

## 🆘 Troubleshooting

### "Authentication failed"
- Make sure you're using the **token** as password, not your GitHub password
- Check token has `repo` scope enabled
- Verify token hasn't expired

### "Repository not found"
- Verify repository exists: https://github.com/SebAustin/fullstack
- Check you have write access to the repository

### "Permission denied"
- Your token may not have correct permissions
- Regenerate token with `repo` scope

## 🔐 Alternative: SSH Key Setup

If you prefer SSH (more secure, no passwords):

### Generate SSH Key

```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Press Enter to accept default location
# Optional: Set a passphrase

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

### Add to GitHub

1. Go to: https://github.com/settings/keys
2. Click: **"New SSH key"**
3. Title: `MacBook` (or your computer name)
4. Key: Paste the public key
5. Click: **"Add SSH key"**

### Update Remote to SSH

```bash
git remote set-url origin git@github.com:SebAustin/fullstack.git
git push -u origin master
```

---

**After pushing, CircleCI will automatically detect your repository and you can set up the pipeline!** 🎉

