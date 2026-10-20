# Template Style Guide — "GI-class" look, legally clean

Goal: every template in the app should be visually indistinguishable in quality
from top-store card apps (Greetings Island / Punchbowl) — built entirely from
original or permissively-licensed material. **Never copy artwork from those
apps** (their ToS forbids scraping for competing products and their templates
are copyrighted). Match the *recipe*, not the pixels.

## 1. Composition rules (the unseen 80% of the "premium" feel)

| Rule | Value |
| --- | --- |
| Canvas sizes | 1050×1470 (5×7" @150dpi portrait) · 1470×1050 landscape · 1050×1050 square |
| Margins | ≥ 6% inset on all sides; never place art over the text zone |
| Text zone | Keep the central 60% visually quiet — art lives on edges/corners |
| Focal point | One dominant motif per template, positioned upper-third or corner |
| Elements per card | ≤ 3 (motif + ornament + texture). More = clutter |
| "Foil" accent | One thin gold metallic element max (border, line, or speck cluster) |
| No words in art | AI prompts must end with "no text, no words, no letters". All lettering is an editable canvas layer |

## 2. Typography recipes (Google Fonts, free)

- **Festive/Hebrew-script feel**: display = Great Vibes / Parisienne /
  Pinyon Script; body = Inter
- **Editorial serif**: display = Fraunces; body = Inter
- **Indian-language support**: Noto Sans Devanagari as body where needed
- Headline ≈ 6.2% of canvas width; body ≈ 2.5%; line-height 1.25–1.4
- Every text element stays an editable `texts[]` layer — never baked into art

## 3. Palette tokens (start from app accent colors)

Pair one deep base + one accent + one cream + one bridge + one foil gold:

| Occasion | Base | Accent | Cream | Bridge |
| --- | --- | --- | --- | --- |
| Diwali | `#1A0B0F` | `#E8A33D` | `#FFF4E0` | `#FF8C42` |
| Wedding (Indian) | `#3B2452` | `#F2B53C` | `#FFF3E4` | `#942F49` |
| Wedding (classic) | `#2C1E2E` | `#D8B4C8` | `#FBF5F0` | `#5A3B54` |
| Birthday | `#2A2440` | `#E8A33D` | `#FFF6E5` | `#F2726F` |
| Eid | `#0F2A25` | `#F2B53C` | `#FFF7E8` | `#2E9E6D` |
| Christmas | `#1E2A26` | `#D64550` | `#FFF8EF` | `#2E7D32` |
| Get Well / Thank You (sage) | `#33403A` | `#2E9E6D` | `#FFF8EE` | `#C9A24B` |

Muted, low-saturation washes read as "premium"; neon reads as "clip-art".

## 4. Catalog math (how 40K templates really happen)

Base art (≈12) × layout variant (3) × palette (5) × occasion text set (8)
= 1,440 catalog entries from 12 paintings. Ship volume through multiplication,
not unique art. Weekly drops stay cheap.

## 5. Asset production — free pipeline

1. **AI art (primary)**: `node tools/template_factory/generate.js`
   - `--provider pollinations` — keyless, free, no account (default)
   - `--provider gemini` — free tier; `GEMINI_API_KEY` required
2. **Stock photos (alternate)**: Pexels / Unsplash / Pixabay — free licenses,
   no attribution required (keep a copy of the license page anyway)
3. **CC0 ornaments**: OpenClipart, Google Fonts icons
4. Record origin of every file in `tools/template_factory/art_provenance.csv`

## 6. Cultural review gate (PRD)

Occasions flagged `needsCulturalReview` (`diwali`, `holi`, `raksha_bandhan`,
`navratri`, `ganesh_chaturthi`) require a human sign-off before
`culturalReviewPassed: true`. Checklist: correct iconography (diyas lit,
crescent direction, deity imagery respectful), palette appropriateness, no
mismatched holiday symbols mixed in.

## 7. Wiring into the app

- `tools/template_factory/generate.js` writes `assets/templates/catalog.json`
  entries matching `TemplateModel.fromJson` exactly
- `CanvasRenderer`/`template_model` need a `backgroundImagePath` render path
  (planned upgrade — see roadmap)
- Offline-first: bundled assets render with zero network; sync newer catalog
  entries from Firestore pipeline (Phase B) when online
