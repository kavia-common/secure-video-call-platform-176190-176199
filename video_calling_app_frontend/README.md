# Ocean Video - Flutter App

Production-ready scaffold for a free video calling app with OTP login, contacts, WebRTC video calls with mid-call invite, local call history, and an Ocean Professional theme.

Features:
- OTP login (works fully in MOCK_MODE without backend)
- Ocean Professional theme (blue & amber accents, subtle gradients, rounded corners)
- go_router navigation: /login, /otp, /contacts, /call, /history
- Contacts list (mock or backend)
- WebRTC scaffolding (flutter_webrtc) and Socket.IO signaling hooks
- Mid-call Add Participant bottom sheet to invite users
- Local call history with sqflite
- Permissions handling (camera/microphone), graceful denials
- Logging via logger

Getting Started:
1) Copy .env.example to .env and configure:
   - API_BASE_URL=
   - SIGNALING_URL=
   - STUN_URLS=stun:stun.l.google.com:19302
   - TURN_URL=
   - TURN_USERNAME=
   - TURN_PASSWORD=
   - MOCK_MODE=true

2) Install deps:
   flutter pub get

3) Run:
   flutter run

Notes:
- When MOCK_MODE=true:
  * OTP request/verify returns a mock token.
  * Contacts are mocked.
  * Call UI shows local camera preview; signaling is optional.
- If SIGNALING_URL is empty, app disables signaling and shows a banner in Call screen. You can still preview local camera and test UI.

Android:
- AndroidManifest includes INTERNET, CAMERA, RECORD_AUDIO, MODIFY_AUDIO_SETTINGS, and uses-feature hints.
- Ensure minSdkVersion >= 21 (configured by Flutter tooling). If you update minSdk manually, keep it >= 21 for WebRTC.

License: MIT
