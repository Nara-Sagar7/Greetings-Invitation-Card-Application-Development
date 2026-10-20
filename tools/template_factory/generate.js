#!/usr/bin/env node
/**
 * Template Factory - generates template background art (via free AI providers)
 * and emits catalog entries that match lib/models/template_model.dart.
 *
 * Zero npm dependencies (Node 18+ global fetch; tested on Node 24).
 *
 * Usage:
 *   node tools/template_factory/generate.js --provider pollinations --limit 2
 *   node tools/template_factory/generate.js --provider gemini
 *   node tools/template_factory/generate.js --dry-run
 *
 * Providers:
 *   pollinations  Keyless, free, no signup (https://pollinations.ai). Default.
 *   gemini        Free tier. Set GEMINI_API_KEY (https://aistudio.google.com).
 */

'use strict';

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', '..');
const CONFIG = require(path.join(__dirname, 'catalog.config.json'));
const { width: W, height: H } = CONFIG.imageSize;

const EVERGREEN = [
  'birthday', 'wedding', 'anniversary', 'thank_you', 'congratulations',
  'get_well_soon', 'new_baby', 'housewarming', 'farewell',
];
const INDIAN = ['diwali', 'holi', 'raksha_bandhan', 'navratri', 'ganesh_chaturthi'];
const BROAD = ['eid', 'christmas', 'new_year', 'valentines'];

function categoryOf(occasionId) {
  if (EVERGREEN.includes(occasionId)) return 'evergreen';
  if (INDIAN.includes(occasionId)) return 'indianFestival';
  if (BROAD.includes(occasionId)) return 'broadFestival';
  throw new Error(`Unknown occasionId: ${occasionId}`);
}

// CLI
const args = process.argv.slice(2);
const get = (name, dflt) => {
  const i = args.indexOf(`--${name}`);
  return i >= 0 && args[i + 1] && !args[i + 1].startsWith('--') ? args[i + 1] : dflt;
};
const has = (name) => args.includes(`--${name}`);
const provider = get('provider', 'pollinations').toLowerCase();
const limit = parseInt(get('limit', '0'), 10);
const onlyOccasion = get('occasion', null);
const dryRun = has('dry-run');

let jobs = CONFIG.jobs.filter((j) => !onlyOccasion || j.occasion === onlyOccasion);
if (limit > 0) jobs = jobs.slice(0, limit);

function pollinationsUrl(job) {
  const p = encodeURIComponent(`${job.prompt}. Composition suits a ${W}x${H}`);
  return (
    `https://image.pollinations.ai/prompt/${p}` +
    `?width=${W}&height=${H}&nologo=true&model=flux&seed=${job.seed ?? 0}`
  );
}

async function fetchImage(job) {
  if (provider === 'pollinations') {
    const res = await fetch(pollinationsUrl(job), {
      signal: AbortSignal.timeout(180_000),
      redirect: 'follow',
    });
    if (!res.ok) throw new Error(`HTTP ${res.status} for ${job.id}`);
    const type = res.headers.get('content-type') || '';
    if (!type.startsWith('image/')) throw new Error(`Not an image (${type}) for ${job.id}`);
    return Buffer.from(await res.arrayBuffer());
  }
  if (provider === 'gemini') {
    const key = process.env.GEMINI_API_KEY;
    if (!key) throw new Error('Set GEMINI_API_KEY env var to use --provider gemini');
    const model = get('model', 'gemini-2.5-flash-image-preview');
    const url =
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${key}`;
    const body = {
      contents: [{ parts: [{ text: `${job.prompt}. Aspect ratio ${W}:${H}.` }] }],
    };
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(180_000),
    });
    if (!res.ok) throw new Error(`Gemini HTTP ${res.status}: ${await res.text()}`);
    const json = await res.json();
    const part = (json.candidates?.[0]?.content?.parts || []).find((p) => p.inlineData);
    if (!part) throw new Error(`No image in Gemini response for ${job.id}`);
    return Buffer.from(part.inlineData.data, 'base64');
  }
  throw new Error(`Unknown provider: ${provider} (use pollinations|gemini)`);
}

function toTemplateEntry(job, assetPath) {
  return {
    id: job.id,
    occasionId: job.occasion,
    name: job.title,
    category: categoryOf(job.occasion),
    thumbnailUrl: assetPath,
    isPremium: Boolean(job.isPremium),
    culturalReviewPassed: false, // set true after human review (PRD gate)
    canvasJson: {
      size: { w: W, h: H },
      backgroundImagePath: assetPath,
      texts: [
        {
          text: job.title,
          dx: 0.5,
          dy: 0.16,
          fontSize: Math.round(W * 0.062),
          font: job.displayFont || 'Fraunces',
          color: '#FFFFFF',
          maxLines: 2,
        },
      ],
      palette: job.palette || CONFIG.defaults.colors5,
    },
    fonts: [job.displayFont || 'Fraunces', 'Inter'],
    colors: job.palette || CONFIG.defaults.colors5,
  };
}

function upsertCatalog(entry) {
  const file = path.join(ROOT, 'assets', 'templates', 'catalog.json');
  const list = fs.existsSync(file)
    ? JSON.parse(fs.readFileSync(file, 'utf8'))
    : [];
  const i = list.findIndex((t) => t.id === entry.id);
  if (i >= 0) list[i] = entry;
  else list.push(entry);
  fs.writeFileSync(file, JSON.stringify(list, null, 2));
}

function logProvenance(job, note) {
  const file = path.join(__dirname, 'art_provenance.csv');
  if (!fs.existsSync(file)) {
    fs.writeFileSync(file, 'asset,provider,model_or_url,seed,date,license_note\n');
  }
  fs.appendFileSync(
    file,
    [
      job.id, provider,
      provider === 'gemini' ? get('model', 'gemini-2.5-flash-image-preview')
        : 'pollinations/flux',
      job.seed ?? '', new Date().toISOString().slice(0, 10),
      note ?? 'AI-generated original (no source artwork copied)',
    ].join(',') + '\n',
  );
}

(async () => {
  console.log(
    `Template Factory: provider=${provider} jobs=${jobs.length}` +
      (limit ? ` (limit ${limit})` : ''),
  );
  let ok = 0;
  for (const job of jobs) {
    const dir = path.join(ROOT, 'assets', 'templates', job.occasion);
    const file = path.join(dir, `${job.id}.jpg`);
    const assetPath = `assets/templates/${job.occasion}/${job.id}.jpg`;
    fs.mkdirSync(dir, { recursive: true });
    if (fs.existsSync(file)) {
      console.log(`  skip (exists): ${assetPath}`);
      continue;
    }
    if (dryRun) {
      console.log(`  planned: ${assetPath}  template id=${job.id} (${categoryOf(job.occasion)})`);
      continue;
    }
    process.stdout.write(`  render ${job.id} ... `);
    try {
      const buf = await fetchImage(job);
      fs.writeFileSync(file, buf);
      upsertCatalog(toTemplateEntry(job, assetPath));
      logProvenance(job);
      console.log(`ok (${(buf.length / 1024) | 0} KB)`);
      ok += 1;
    } catch (e) {
      console.log(`FAILED: ${e.message}`);
    }
  }
  console.log(`Done. ${ok} new images. Catalog: assets/templates/catalog.json`);
})();
