# Development Standards — Greetings Invitation App

> **Source of truth for all contributors (human + AI).**
> Read this before writing any code. If this doc
> conflicts with the PRD, the PRD wins — file an
> issue to reconcile.

- **Version:** 1.1 — 2026-09-08
- **Stack:** Flutter 3.13.2 / Riverpod / GoRouter /
  Firebase / Hive (offline-first)
- **Formatting:** `dart format --line-length 80`
- **Branch model:** Trunk-based — single protected
  `main`
- **Language:** English only (code, comments, docs,
  commits, PRs)
- **File length:** Max 250 lines per file (§3.4)

---

## 1. Principles & PRD Gates (Non-negotiable)

These are product-level invariants. Do not ship code
that violates them.

1.  **Offline-first.** Hive is the source of truth.
    Every write must persist locally first, then sync
    via `offline_queue_service` + `connectivity_plus`.
    Conflict rule: **local wins**
    (`lib/core/constants/app_constants.dart:19`).

2.  **True WYSIWYG.** `canvasPixelRatio = 2.0`
    (`app_constants.dart:10`). Preview must be
    pixel-identical to the exported/shared output.

3.  **Occasion-first & 3-tap guard.** IA has 9
    screens max, Home → Preview ≤ 3 taps. If a
    screen does not serve PRD §6, it does not exist.
    See `lib/core/router/app_router.dart:15`.

4.  **Hard quality gates** (`app_constants.dart:7-13`):

    | Gate | Value | Enforcement |
    |------|-------|-------------|
    | `maxImageSizeMB` | 5 MB | Reject before upload |
    | `compressedImageWidth` | 1080px WebP | `image_compress_service` |
    | `mailTesterGate` | 9.0/10 | CI / QA check |
    | `maxFreeEventsPerMonth` | 3 | Billing guard |
    | `maxFreeCardsPerMonth` | 5 | Billing guard |

5.  **Premium pricing tokens** are placeholders
    (`₹149` / `₹999` in `app_constants.dart:16`)
    — never hardcode prices in widgets.

6.  **Cost of change.** Prefer additive, backward-
    compatible changes. No breaking migration without
    a `docs/migration.md` note.

---

## 2. Architecture — Folder Contract

```
lib/
  main.dart                 # Hive.initFlutter + ProviderScope
  app.dart                  # MaterialApp.router + AppTheme
  core/
    constants/              # AppConstants, occasions — no deps
    router/                 # AppRouter only — single GoRouter
    theme/                  # AppColors, AppTheme, AppTypography
  features/
    <feature>/              # home, gallery, editor, preview,
      screens/              #   guest_list, send, rsvp, my_cards,
      widgets/              #   account
      providers/            # Riverpod providers for this feature
  models/                   # Cross-feature DTOs + Hive adapters
  services/                 # Singletons (template, offline_queue,
                            # image_compress) — interface + impl
assets/
  images/ templates/ stickers/ fonts/
test/
  features/<feature>/  core/  services/
```

**Rules:**

- `core` must never import from `features`,
  `models`, or `services`. Dependency direction:
  `features → core`, `features → models/services`,
  never the reverse.
- No `features/a` → `features/b` direct import.
  Share via `core` or `models/services` + Riverpod
  provider.
- Each feature owns its `providers`. Global
  providers live in `core` or `services`.
- New model → add Hive `@HiveType` + run
  `dart run build_runner build --delete-conflicting-outputs`
  (see `pubspec.yaml:42-43`).
- New service → define abstract interface, provide
  via Riverpod, add unit test.
- New route → add only in `lib/core/router/app_router.dart:17`
  (`AppRouter.router`). No `Navigator.push` elsewhere.

---

## 3. Code Style & Formatting

### 3.1 Formatter

- **Line length 80.** Enforced by
  `dart format --line-length 80`.
- CI gate: `dart format --set-exit-if-changed .`
  must pass.
- `.editorconfig` enforces LF, 2-space indent,
  trim trailing whitespace.

### 3.2 Analyzer

Base: `package:flutter_lints/flutter.yaml`
(`analysis_options.yaml:10`).

Required lints (enabled in `analysis_options.yaml:31`):

```yaml
linter:
  rules:
    avoid_print: true
    prefer_single_quotes: true
    require_trailing_commas: true
    use_key_in_widget_constructors: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_empty_else: true
    avoid_type_to_string: true
    cancel_subscriptions: true
    close_sinks: true
```

- `flutter analyze` must be **0 warnings / 0 errors**
  before push / PR.
- `// ignore: name_of_lint` allowed only on the
  offending line with a `// TODO(#issue): reason`
  comment. `// ignore_for_file:` at file top only
  with linked issue.

### 3.3 General Dart / Flutter

- `useMaterial3: true` always.
- Use `const` constructors wherever possible.
- Prefer `final` over `var`; `late final` only
  when unavoidable.
- No `print` / `debugPrint` in production code —
  use `debugPrint` behind `kDebugMode` or a logger
  service.
- No `dynamic` without justification; prefer
  explicit types on public APIs.
- Keep widgets small (<150 lines). Extract
  `*_widget.dart` when a `build` grows.

### 3.4 File Length Limit — 250 Lines (Readability)

- **Hard limit: 250 lines per file** (excluding
  generated `*.g.dart`, `*.freezed.dart`,
  `*.gr.dart` and `l10n` outputs).
- Applies to all `lib/**/*.dart` and
  `test/**/*.dart` hand-written files.
- **Enforcement:**
  - Local: `find lib test -name '*.dart' ! -name '*.g.dart' -exec wc -l {} + | awk '$1>250'`
    must return empty before push.
  - CI gate: same check fails the PR.
  - Analyzer: no native lint for file length —
    this rule is enforced via the shell check
    above + code review.
- **If you hit 250:**
  1.  Split by responsibility: extract
      `*_widget.dart`, `*_controller.dart`,
      `*_provider.dart`, or `*_utils.dart`.
  2.  Split large `Screen` into `View` + `Widgets`
      folder (`features/<feature>/widgets/`).
  3.  Move constants / helpers to
      `core/constants` or a feature `utils`.
  4.  Never cheat by removing docs / compressing
      lines — readability wins.
- **Exceptions:** Only with Tech Lead approval +
  `// ignore_for_file: file_length_limit` comment
  at top with linked issue `// TODO(#123): split
  after Phase X`. Exceptions expire in 2 sprints.
- **Rationale:** Keeps files reviewable (<1 screen
  scroll context), enforces single responsibility,
  and aligns with your `Development_standards.md:59`
  feature isolation.

---

## 4. Naming & File Conventions

| What | Convention | Example |
|------|------------|---------|
| Files | `snake_case.dart` | `guest_list_screen.dart` |
| Widgets | `PascalCase` + suffix | `GuestListScreen`, `CardPreviewWidget` |
| Providers | `*Provider` / `*Notifier` | `templateListProvider` |
| Hive models | `*Model` | `EventModel`, `TemplateModel` |
| Routes | `kebab-case` path | `/my-cards`, `/editor/:templateId` |
| Assets | `kebab-case` | `assets/stickers/diwa-lamp.svg` |
| Constants | `AppConstants.*` | `AppConstants.maxImageSizeMB` |
| Colors | `AppColors.*` | `AppColors.marigoldGold` |

- No hardcoded colors, strings, or dimensions outside
  `app_colors.dart`, `app_typography.dart`,
  `app_constants.dart`, or `l10n` (when added).
- Test files mirror source:
  `lib/features/editor/editor_screen.dart` →
  `test/features/editor/editor_screen_test.dart`.

---

## 5. State, Navigation & Data Rules

### 5.1 State — Riverpod Only

- Dependencies: `flutter_riverpod: ^2.6.1`
  (`pubspec.yaml:14`).
- No business logic in `setState` / `StatefulWidget`
  for shared state. Use `Provider`, `StateProvider`,
  `StateNotifierProvider`, or `AsyncNotifier`.
- `ProviderScope` at root only (`lib/main.dart:12`).
  Do not nest another `ProviderScope` without
  review.

### 5.2 Navigation — GoRouter Only

- Dependency: `go_router: ^15.1.2`.
- All navigation via `AppRouter.router`
  (`lib/core/router/app_router.dart:17`).
- Bottom nav uses `StatefulShellRoute.indexedStack`
  (`app_router.dart:20`) with 4 branches:
  `/` (Home), `/gallery`, `/my-cards`, `/account`.
- Full-screen flows (`/editor/:templateId`,
  `/preview`, `/guest-list`, `/send`,
  `/rsvp/:eventId`) live outside the shell.

### 5.3 Data & Offline

- Hive + `hive_flutter` (`pubspec.yaml:23-24`) is
  the offline source of truth.
  `Hive.initFlutter()` in `lib/main.dart:9`.
- Firebase (`firebase_core`, `firebase_auth`,
  `cloud_firestore`, `firebase_storage`,
  `google_sign_in`) is sync / auth layer — Phase B.
- Label for queued sends:
  `AppConstants.offlineLabel`
  (`app_constants.dart:20`):
  `"Saved — will send when you're back online"`.
- Every network write must enqueue via
  `offline_queue_service.dart` when offline and
  replay on `connectivity_plus` restore.

---

## 6. Design System & WYSIWYG Contract

- Theme: `AppTheme.light` / `AppTheme.dark`
  (`lib/core/theme/app_theme.dart:8`).
  Marigold accent `#E8A33D` (`AppColors.marigoldGold`)
  stays identical in both modes for brand
  continuity (`app_theme.dart:106`).
- Typography: `GoogleFonts.inter` (body) +
  `GoogleFonts.fraunces` (display) via
  `app_typography.dart`. No ad-hoc `TextStyle`
  outside theme.
- Radii: `14` (buttons), `16` (cards), `12`
  (inputs), `20` (chips) — from `app_theme.dart`.
- Use theme tokens, not magic numbers:
  `Theme.of(context).colorScheme.primary` etc.
- Any new color must be added to `AppColors`
  with a semantic name and reviewed in PR.

---

## 7. Git — Branching, Commits, PRs & Review

### 7.1 Branch Model — Main Only (Trunk-Based)

- `main` is **protected**. No direct pushes.
- Create short-lived branches off `main`:
  - `feature/<ticket>-<slug>` — e.g.,
    `feature/42-editor-text-layer`
  - `fix/<slug>` — e.g., `fix/offline-queue-replay`
  - `chore/<slug>` / `docs/<slug>`
- Keep branches < 3 days; rebase on `main` before
  PR (`git fetch && git rebase origin/main`).
- Merge via **Squash and merge** on GitHub. Delete
  branch after merge.
- Release tags: `v1.0.0+1` matching
  `pubspec.yaml:4` (`version: 1.0.0+1`).

### 7.2 Commits — Conventional Commits

```
<type>(<scope>): <short summary>

[optional body]
[optional footer: Closes #123]
```

- Types: `feat`, `fix`, `chore`, `docs`,
  `refactor`, `test`, `style`, `perf`, `ci`.
- Scope is a feature: `editor`, `gallery`,
  `router`, `theme`, `offline`.
- Summary: imperative, lowercase, no period,
  ≤ 72 chars.
- Examples:
  - `feat(editor): add drag-to-reposition text layer`
  - `fix(offline): replay queued events on reconnect`
  - `chore: bump flutter_lints to 6.0.0`

### 7.3 Pull Requests

Checklist (must pass before requesting review):

- [ ] `flutter analyze` — 0 issues
- [ ] `flutter test` — all green
- [ ] `dart format --set-exit-if-changed .` — clean
- [ ] File length ≤ 250 lines per file (§3.4) —
      `find lib test -name '*.dart' ! -name '*.g.dart' -exec wc -l {} + | awk '$1>250'` empty
- [ ] No secrets / keys / `.jks` committed
      (see `.gitignore:57-58`)
- [ ] Linked issue (`Closes #123`)
- [ ] Screenshots / screen recording for UI changes
- [ ] Updated `Development_standards.md` if a rule
      changed

- Require **1 reviewer** minimum.
- PR title follows Conventional Commits (used as
  squash message).
- Keep PRs < 400 lines diff where possible; split
  large features.

### 7.4 Code Review Expectations

- Review within 24h; author pings if blocked.
- Comment categories: `nit:`, `suggestion:`,
  `issue:` (must fix), `question:`.
- Check: folder contract, Riverpod/GoRouter
  compliance, theme tokens, offline handling,
  tests, naming, PRD gate adherence,
  file length ≤ 250 (§3.4).

---

## 8. Testing & Quality Gates

- Framework: `flutter_test` (`pubspec.yaml:39`).
- Locations:
  - `test/features/<feature>/*_test.dart`
  - `test/core/*_test.dart`
  - `test/services/*_test.dart`
- Types:
  - **Unit** — `services`, `models`, pure logic
  - **Widget** — `features/*_screen.dart`,
    `*_widget.dart`
  - **Golden** — theme / card rendering (Phase C)
- Run: `flutter test`
- Coverage goal: Phase A ≥ 40% → Phase C ≥ 70%.
- Gate before merge (local + CI):

  ```sh
  flutter analyze
  flutter test
  dart format --line-length 80 --set-exit-if-changed .
  # File length guard — §3.4 (250 lines)
  find lib test -name '*.dart' ! -name '*.g.dart' -exec wc -l {} + | awk '$1>250 {print $2": "$1" lines"}' | (! grep -q .)
  dart run build_runner build --delete-conflicting-outputs # if models changed
  ```

---

## 9. Security, Secrets & Offline Contract

- **Never commit** secrets: `firebase_options.dart`
  (after `flutterfire configure`), `.env`,
  `android/key.properties`, `*.jks`, `*.p8`,
  `google-services.json` if sensitive.
  All are covered by `.gitignore:55-58`.
- Use `--dart-define` or env for keys; never
  inline in `lib/`.
- Image pipeline: validate `maxImageSizeBytes`
  (`5 * 1024 * 1024`) in `image_compress_service.dart`
  before any upload; compress to WebP `1080` wide.
- Firebase rules: deny by default; PR must include
  rule diff when touching Firestore/Storage.
- Offline contract: every user action must succeed
  offline and reflect queued state in UI with
  `AppConstants.offlineLabel`.

---

## 10. AI Agent Rules

Applies to all AI contributors (Muse, Cursor,
Copilot, etc.).

1.  Read `Development_standards.md` + PRD PDF
    (`PRD - Invitation & Greeting Card App - V1.0 Professional.pdf`)
    before any edit.
2.  Respect folder contract (§2), Riverpod/GoRouter
    rules (§5), and theme tokens (§6). Do not invent
    routes, colors, or constants.
3.  Run `flutter analyze` after every substantive
    edit; fix before finishing.
4.  Keep line length `80`; run
    `dart format --line-length 80 .`.
5.  Never add a new top-level folder or dependency
    without human approval + updating this doc.
6.  Keep language English; keep commits Conventional
    (§7.2).
7.  If a request conflicts with this doc, surface
    the conflict and ask — do not silently violate.

---

## Appendix A — Pre-Commit Checklist

```sh
# 1. Format (80)
dart format --line-length 80 .

# 2. Analyze
flutter analyze

# 3. Test
flutter test

# 4. File length ≤ 250 (§3.4)
find lib test -name '*.dart' ! -name '*.g.dart' -exec wc -l {} + | awk '$1>250 {print $2": "$1" lines"}' | (! grep -q .)

# 5. Build generated files (if models changed)
dart run build_runner build --delete-conflicting-outputs

# 6. Verify no secrets staged
git diff --cached --name-only | grep -E "keystore|key\.properties|\.jks|\.env|firebase_options"
```

## Appendix B — Command Reference

| Task | Command |
|------|---------|
| Get deps | `flutter pub get` |
| Format | `dart format --line-length 80 .` |
| Check format | `dart format --line-length 80 --set-exit-if-changed .` |
| Analyze | `flutter analyze` |
| Test | `flutter test` |
| File length | `find lib test -name '*.dart' ! -name '*.g.dart' -exec wc -l {} + | awk '$1>250'` |
| Build Hive | `dart run build_runner build --delete-conflicting-outputs` |
| Run app | `flutter run` |
| Generate firebase | `flutterfire configure` |

## Appendix C — Doc Maintenance

- Owner: Tech Lead (assign CODEOWNER for this file).
- Review cadence: every 4 weeks or on any Phase
  transition (A→B→C→E).
- Change process: PR with `docs:` prefix, reviewer
  = Tech Lead, update `Version` + `Date` at top.
- AI agents must re-read this file at session start.

---

*End of Development Standards v1.1 (added §3.4 — 250 lines/file). Questions → file
an issue with label `standards`.*
