# histrangled — Hexo Blog

Hexo-Blog, der per GitHub Actions automatisch auf GitHub Pages deployed wird.

## Setup (einmalig)

1. **Dateien in das Repo pushen** (Default-Branch `main`):

   ```bash
   git init
   git add .
   git commit -m "Hexo blog + Pages workflow"
   git branch -M main
   git remote add origin https://github.com/histrangled/histrangled.git
   git push -u origin main
   ```

   > Achtung: Im Repo `histrangled/histrangled` liegt aktuell ein Jekyll-Issue-Blog.
   > Entweder ersetzt du ihn (dann vorher die alten Dateien `_config.yml`, `_layouts/`,
   > `index.html`, `404.html`, `scripts/` und den alten Workflow löschen), oder du legst
   > ein neues Repo an – siehe „Anderes Repo“ weiter unten.

2. **GitHub Pages umstellen**: Repo → *Settings* → *Pages* → *Build and deployment* →
   **Source: GitHub Actions**.

3. Fertig. Jeder Push auf `main` baut und veröffentlicht. Der Workflow lässt sich auch
   manuell über den Tab *Actions* starten (`workflow_dispatch`).

Ergebnis: <https://histrangled.github.io/histrangled/>

## Anderes Repo / andere URL

In `_config.yml` müssen `url` und `root` zur Pages-URL passen:

| Fall | url | root |
| --- | --- | --- |
| Project Page (`github.com/user/blog`) | `https://user.github.io/blog` | `/blog/` |
| User Page (`github.com/user/user.github.io`) | `https://user.github.io` | `/` |
| Eigene Domain | `https://example.com` | `/` |

Bei eigener Domain zusätzlich eine Datei `source/CNAME` mit der Domain anlegen –
Hexo kopiert sie beim Build nach `public/`.

## Lokal arbeiten

```bash
npm install
npx hexo server        # http://localhost:4000
npx hexo new post "Titel"
npx hexo clean && npx hexo generate   # Build nach public/
```

## Was der Workflow macht

`.github/workflows/pages.yml`

- Trigger: Push auf `main` + manuell
- Job **build**: Checkout (inkl. Submodules für Themes) → `actions/configure-pages`
  → Node 20 mit npm-Cache → `npm ci` (Fallback `npm install`) → `hexo clean && hexo generate`
  → `upload-pages-artifact` mit `./public`
- Job **deploy**: `actions/deploy-pages@v4` mit den Rechten `pages: write` und `id-token: write`
- `concurrency: pages` sorgt dafür, dass sich Deployments nicht überholen

## Struktur

```
_config.yml          # Site-Konfiguration (Titel, url/root, Theme)
source/_posts/       # Blogposts als Markdown
scaffolds/           # Vorlagen für neue Posts
themes/              # Themes (Standard: landscape via npm)
public/              # Build-Output (nicht committen, steht in .gitignore)
```
