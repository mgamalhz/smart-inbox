# Deployment guide

How the landing page at <https://smart-inbox.mgamalhz.com> is built and
released. The skill itself (`skills/`) needs no deployment: people install it
straight from GitHub with `npx skills add mgamalhz/smart-inbox`.

## How it works

- The site is static: `site/index.html`, `site/style.css` and `site/favicon.svg`.
  No server code, no database, no build step on the server.
- The server keeps a git clone of this repository and serves only the `site/`
  folder. Releasing means pushing to `main` and pulling on the server.
- Tailwind is compiled locally into `site/style.css`, and that file is
  committed. `site-build/` holds the sources and is never served.

| What | Where |
| --- | --- |
| Repository | `github.com/mgamalhz/smart-inbox`, branch `main` |
| Server | `mgamalhz-server` (SSH host alias), shared with other sites |
| Clone on the server | `/var/www/smart-inbox` (HTTPS clone, read only) |
| Web root | `/var/www/smart-inbox/site` |
| Nginx config | `/etc/nginx/sites-enabled/smart-inbox.mgamalhz.com` |
| TLS | Let's Encrypt through Certbot, renews automatically |
| DNS | `A` record for `smart-inbox` on `mgamalhz.com` |

## Access you need

- Push access to the GitHub repository.
- SSH access to `mgamalhz-server`. Ask Mohamed to add your key; the host alias
  and address are not kept in this public repository.
- Node.js locally, only if you change CSS classes (the build uses `npx`).

## Release a change

### 1. Edit and rebuild the CSS

If you changed any class in `site/index.html` or anything in
`site-build/style.src.css`, rebuild the stylesheet:

```bash
./site-build/build-css.sh
```

It compiles `site/style.css` with Tailwind 3.4.19 and stamps a content hash
into the stylesheet link (`/style.css?v=<hash>`). The hash makes every browser
fetch the new file instead of a cached one that no longer matches the HTML.
Never edit `site/style.css` or the `?v=` value by hand.

Text-only changes do not need a rebuild.

### 2. Check it locally

Serve the folder and open it in a browser:

```bash
python3 -m http.server 8031 --directory site
```

Check light and dark mode, a phone width (375px) with no sideways scroll, the
hero animation for a full loop, and the browser console for errors.

### 3. Commit and push

```bash
git add site site-build
git commit -m "fix(site): short description"
git push
```

Commits are a single line, `type(module): message`, with no body or footer.

### 4. Pull on the server

```bash
ssh mgamalhz-server 'git -C /var/www/smart-inbox pull'
```

That is the whole release. Nginx serves the new files immediately; no reload
is needed for content changes.

### 5. Verify the live site

```bash
curl -s https://smart-inbox.mgamalhz.com/ | grep -o 'style.css?v=[a-z0-9]*'
shasum -a 256 site/style.css | cut -c1-10
```

The two hashes must match. Then open the site in a private window and look at
the page and the console.

## Roll back

Revert on GitHub and pull again, so the server never drifts from `main`:

```bash
git revert <commit>
git push
ssh mgamalhz-server 'git -C /var/www/smart-inbox pull'
```

## If the pull fails on the server

`git pull` refuses when the clone has local edits. Nobody should edit files on
the server, so first look at what changed:

```bash
ssh mgamalhz-server 'cd /var/www/smart-inbox && git status --short && git diff --stat'
```

If the changes are already in `main` or are not wanted, back them up and reset
to GitHub:

```bash
ssh mgamalhz-server 'cd /var/www/smart-inbox && git stash && git pull'
```

If `main` was force-pushed, use
`git fetch && git reset --hard origin/main` instead, after checking
`git status` shows nothing worth keeping.

## Nginx and TLS

The server hosts other sites, so every change there must be additive:

- Touch only `/etc/nginx/sites-enabled/smart-inbox.mgamalhz.com`.
- Test before applying, and reload, never restart:

  ```bash
  sudo nginx -t && sudo nginx -s reload
  ```

What the config does:

- Serves `/var/www/smart-inbox/site` and returns 404 for anything missing.
- Sends `X-Content-Type-Options`, `Referrer-Policy` and `X-Frame-Options`.
- Caches `/style.css` for one hour (the `?v=` hash handles updates).
- Denies dotfiles, so `.git` is never served.
- Redirects HTTP to HTTPS (added by Certbot).

The certificate renews on its own. To check it:

```bash
ssh mgamalhz-server 'sudo certbot certificates 2>/dev/null | grep -A4 smart-inbox'
```

## Do not

- Do not copy files to the server with `scp` or `rsync`. Always go through git,
  or the next pull fails.
- Do not commit secrets. The site has none: the Calendly, WhatsApp and Google
  Analytics values in `index.html` are public by design.
- Do not restart Nginx or change other sites' configs.
