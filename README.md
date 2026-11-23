# ASSAMPEDIA

Explore Assam. Learn. Prepare. Succeed.

A bilingual (Assamese and English) Android app for Assam GK, exam syllabuses,
government job profiles, current affairs, vacancies and practice tests.

## Stack

- Flutter (app and in-app admin screens)
- Supabase (database, storage, login), from Phase 2
- Firebase Cloud Messaging (job alerts only), from Phase 5
- Google Play Billing with RevenueCat (Premium subscription), from Phase 6

## Getting the test app

Every push to `main` builds an installable APK on GitHub Actions.
Open the **Actions** tab, choose the latest **Build test app (APK)** run,
and download `assampedia-test-apk` at the bottom of the page.

## Project layout

```
lib/
  core/theme/      brand colours, colour-code meanings, light and dark themes
  features/        one folder per part of the app
assets/brand/      logo, icon and splash images
assets/fonts/      Noto Sans and Noto Sans Bengali (SIL Open Font License)
```
