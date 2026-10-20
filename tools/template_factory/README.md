# Template Factory

Generates template background art and `assets/templates/catalog.json`
entries compatible with `lib/models/template_model.dart`.
Zero npm dependencies (Node 18+).

## Providers

| Provider | Free capacity | Setup |
| --- | --- | --- |
| **cloudflare** (recommended) | ~120+ images/day, resets 00:00 UTC, commercial OK | 1. Free account at dash.cloudflare.com → Workers & Pages → AI section: copy **Account ID**. 2. Create an **API token** (My Profile → API Tokens → permission: Workers AI). 3. Export env vars below. |
| **pollinations** | ~1 image/IP/hour keyless; more with a free account + Quest credits | none |
| **gemini** | Image output not available on free tier (2026-10); paid keys | `GEMINI_API_KEY` |

## Run

PowerShell:

```powershell
$env:CLOUDFLARE_ACCOUNT_ID = 'xxxxxxxxxxxxxxxxxxxxxxxx'
$env:CLOUDFLARE_API_TOKEN = 'xxxxxxxxxxxxxxxxxxxxxxx'
node tools\template_factory\generate.js --provider cloudflare
```

Options: `--provider cloudflare|pollinations|gemini`, `--limit N`,
`--occasion <id>`, `--dry-run`, `--model <id>`.

Finished images are skipped, so rerun anytime to resume.

## Output

- `assets/templates/<occasion>/<job-id>.jpg`
- `assets/templates/catalog.json` (TemplateModel-compatible)
- `tools/template_factory/art_provenance.csv` (license trail)

Then add jobs in `catalog.config.json` following
`docs/template_style_guide.md` (prompt rules: "no text, no words,
no letters" ends every prompt; text lives in editable canvas layers).
