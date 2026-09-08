# Release Gates Checklist — Greetings v1.0

> Source: PRD Appendix A • Must be GREEN before store submission.
> Owner: Engineering + QA + Product + Cultural Reviewer

## Pre-Launch Gates (Must be GREEN)

- [ ] **WYSIWYG parity verified** on iPhone SE, Pixel 7, iPad Mini — 0 reported “preview ≠ sent” bugs
  - Evidence: `lib/services/export_service.dart:14` `canvasPixelRatio 2.0` + `lib/features/editor/widgets/canvas_renderer.dart:11` shared renderer
  - Test: `ExportService.verifyIdentical` + manual 3-device QA` - [ ] **Fonts preloaded via CDN — no FOUT** on canvas init
  - Evidence: `AppTypography` `GoogleFonts.fraunces`/`inter` preloaded before `CanvasRenderer`
  - Test: Cold launch canvas, no flash
- [ ] **5 MB → 1080p WebP compression verified**
  - Evidence: `lib/services/image_compress_service.dart:22` `FlutterImageCompress` `minWidth 1080`
  - Test: Upload 6 MB image → compressed <5 MB WebP
- [ ] **Mail-Tester ≥ 9/10** on all transactional templates
  - Evidence: `functions/index.js` SendGrid + SPF/DKIM/DMARC domain
  - Test: `mail-tester.com` 9.0+ for `noreply@greetings.app`
- [ ] **SPF / DKIM / DMARC configured & verified**
  - Evidence: DNS TXT records for `greetings.app`
- [ ] **Cultural review signed off** for all 5 Indian festival sets (Diwali, Holi, Raksha Bandhan, Navratri, Ganesh Chaturthi)
  - Evidence: `lib/services/template_service.dart:8` `culturalReviewPassed` + domain-expert sign-off sheet
- [ ] **“Saved — will send when back online”** copy in-app
  - Evidence: `lib/core/constants/app_constants.dart:20` `offlineLabel` + `lib/services/connectivity_service.dart:1`
- [ ] **Offline queue local wins verified**
  - Evidence: Airplane mode → create draft → back online → `connectivity_service` flushes `offline_queue` → Firestore overwrites
- [ ] **Analytics Spec companion delivered (Week 3)**
  - Evidence: `lib/services/analytics_service.dart:1` 7 KPIs logged
- [ ] **Firestore/Storage rules deny-by-default deployed**
  - Evidence: `firestore.rules` `storage.rules` in repo root

## Post-Launch Health (First 30 Days)

- [ ] 0 “preview ≠ sent” bug reports (KPI)
- [ ] Activation ≥ target within 24h window (`AnalyticsService.activation`)
- [ ] RSVP response rate tracked with vs without reminder (`AnalyticsService.rsvpResponse`)
- [ ] Free → Premium conversion by occasion (`AnalyticsService.conversionPremium`)
- [ ] App Store rating ≥ 4.5 trend
- [ ] Chatbot deflection rate weekly (`AnalyticsService.chatbotDeflected`)
- [ ] Template usage: which festivals/evergreen over-index
- [ ] Weekly template drops to reach 200 total

## Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product | | | |
| Design | | | |
| Engineering | | | |
| QA | | | |
| Cultural Reviewer | | | |

*In Jesus name we pray. Amen.*
