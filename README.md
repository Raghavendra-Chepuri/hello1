# TeleVault — Unlimited Cloud Storage Powered by Telegram

A complete cloud-storage ecosystem: **Web / PWA + Node.js MTProto Backend + Mobile App (Android & iOS) + TV App**, powered directly by **Telegram's unlimited cloud storage** (your Saved Messages).

---

## How it works

```
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  Web / PWA  │   │  Android /  │   │  iOS app    │   │  TV app     │
│  (/web)     │   │  iOS (RN)   │   │  (RN)       │   │  (/tv)      │
└──────┬──────┘   └──────┬──────┘   └──────┬──────┘   └──────┬──────┘
       └─────────────────┴────────┬────────┴─────────────────┘
                                  ▼
                        ┌──────────────────┐
                        │  TeleVault API   │  Node.js + Express
                        │  (/server)       │  GramJS (MTProto)
                        └────────┬─────────┘
                                 ▼
                        ┌──────────────────┐
                        │ Telegram cloud   │  Your Saved Messages ("me")
                        │ (unlimited)      │  = the actual storage
                        └──────────────────┘
```

- **Real Telegram OTP**: Sign in with your country dial code (default `+91`) + phone number; Telegram delivers the login OTP directly inside your Telegram app (with optional Telegram 2FA password support).
- **Real Saved Messages Storage**: Every uploaded photo, video, and file is sent directly to your Telegram **Saved Messages** (`"me"`). Deleting forever removes the message from your Telegram Saved Messages.
- **Zero Exposed Secrets**: Your `api_id`, `api_hash`, and encrypted GramJS `StringSession` stay strictly on the backend server (`server/config.json` + AES-256-GCM encrypted SQLite database) — never in browser JS or the browser Network tab.
- **Sharing**: WhatsApp, Telegram, native share sheet, public links, key-protected links, or direct Telegram sharing (accept-to-receive).
- **Recycle Bin**: Auto-purges deleted items from Telegram Saved Messages after a configurable number of days (default `30`).
- **TV Mode & Slideshow**: D-pad navigation and timed album slideshows.

---

## Folder structure

| Folder | What it is |
|---|---|
| `web/` | Web / PWA frontend (`index.html`, `manifest.json`, `sw.js`). Served directly by `/server` on same-origin. |
| `server/` | Node.js + Express + GramJS MTProto backend (`server.js`). Serves `web/` and handles Telegram login, OTP, and Saved Messages uploads/streams. |
| `mobile/` | React Native / Expo app (`App.js`, `package.json`) for Android & iOS. |
| `tv/` | TV interface (`index.html`) for Android TV / smart TVs. |
| `docs/` | Security architecture notes (`SECURITY.md`). |

---

## Quick start (Live Telegram Cloud)

1. Get free Telegram API credentials at **https://my.telegram.org** → **API development tools** → note your `api_id` and `api_hash`.
2. Install & start the TeleVault server:
   ```bash
   cd server
   npm install
   npm start
   ```
   The server starts on port `8787` (or `PORT` env var) and serves the web app directly (`http://localhost:8787`).
3. Open the web app in your browser:
   - On first run, TeleVault prompts once to save your `api_id` & `api_hash` securely onto the server (or you can pre-fill `server/config.json` / set `TG_API_ID` & `TG_API_HASH`). Once saved, setup locks automatically.
   - Enter your phone number (e.g. `+91 …`), receive the OTP directly inside your Telegram app, enter it, and upload photos, videos, and files straight into your Telegram **Saved Messages**.

### Deploy Outside Arena (24/7 Permanent Public URL)

You can host TeleVault permanently on free cloud platforms so it stays online 24/7:

1. **Hugging Face Spaces (Free, No Credit Card, Docker)**:
   - Create a new Space → choose **Docker (Blank)** → Public or Private.
   - Upload/push the contents of this `televault/` folder (must include `Dockerfile`, `server/`, `web/`).
   - In Space **Settings → Variables & Secrets**, add `TG_API_ID`, `TG_API_HASH` (from https://my.telegram.org), and `SESSION_ENCRYPTION_KEY` (any random secret string).
   - Once built, your permanent URL is `https://<username>-<space-name>.hf.space`.

2. **Render.com / Railway / Koyeb**:
   - Push `televault/` to a GitHub repo (`config.json`, `televault.db*`, and `thumbs/` are ignored by `.gitignore`).
   - Connect the repo to Render (`render.yaml` is included) or Railway/Koyeb, set `TG_API_ID` and `TG_API_HASH` as environment variables, and deploy.

3. **Run on Android (Termux) or Your PC**:
   - `cd server && npm install && npm start` → open `http://localhost:3000`.

### Mobile apps (Android + iOS)
```bash
cd mobile
npm install
npx expo start        # preview on your phone with Expo Go
npx expo run:android  # build Android app
npx expo run:ios      # build iOS app (needs macOS + Xcode)
```

### TV app
Open `tv/index.html` in an Android TV / smart TV browser and point it to your running TeleVault server.

---

## Important notes

- **Account safety**: Your photos, videos, and files live in your Telegram Saved Messages. If Telegram bans or deletes your account, stored content cannot be restored. TeleVault displays an explicit acknowledgement before first use.
- **No fake local fallback**: All authentication and uploads connect to real Telegram via MTProto.
