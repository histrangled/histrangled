---
title: Hallo Hexo
date: 2026-08-21 12:00:00
tags:
  - hexo
  - github-pages
categories:
  - Meta
---

Dieser Blog wird mit [Hexo](https://hexo.io/) gebaut und über GitHub Actions automatisch
auf GitHub Pages deployed.

<!-- more -->

## Wie es funktioniert

1. Du schreibst eine Markdown-Datei in `source/_posts/`.
2. Push auf `main`.
3. Der Workflow `.github/workflows/pages.yml` läuft: `npm ci` → `hexo generate` → Upload des
   `public/`-Ordners als Pages-Artifact → Deploy.
4. Ein bis zwei Minuten später ist der Beitrag online.

## Neuen Beitrag anlegen

```bash
npx hexo new post "Mein neuer Beitrag"
npx hexo server   # lokale Vorschau auf http://localhost:4000
```

Viel Spaß!
