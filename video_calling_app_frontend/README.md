# Ocean Video - Flutter App

A production-ready Flutter scaffold for free video calling with OTP login, WebRTC calling, mid-call user addition, local call history, and the Ocean Professional theme.

## Overview
This app demonstrates:
- OTP login flow (works out-of-the-box in MOCK_MODE without a backend)
- Ocean Professional theme with blue and amber accents, rounded corners, and subtle gradients
- Routing with go_router: /login, /otp, /contacts, /call, /history
- Contacts list (mock or backend-backed)
- WebRTC scaffolding via flutter_webrtc and Socket.IO signaling hooks
- Mid-call Add Participant bottom sheet to invite users
- Local call history using sqflite
- Permissions handling for camera and microphone, with graceful user feedback
- Structured logging via logger

## Getting Started
1) Environment variables
   - Copy .env.example to .env in the project root of this Flutter app.
   - Review and set the variables according to your environment and needs.

2) Install dependencies
   - Run:
     flutter pub get

3) Run the app (Android recommended for WebRTC testing)
   - Start on a connected device or emulator:
     flutter run
   - For release-like performance:
     flutter run --release

## Environment Variables
Env variables are loaded via flutter_dotenv and consumed by EnvConfig (lib/core/config/env.dart). The following keys are supported:

- API_BASE_URL
  Description: Base URL for the backend API used by OTP and contacts. When MOCK_MODE=true, the app does not call this API.
  Example: https://api.example.com

- SIGNALING_URL
  Description: Socket.IO signaling server URL for exchanging SDP offers/answers and ICE candidates. When empty, signaling is disabled and the Call screen will show an informational banner.
  Example: https://signal.example.com

- STUN_URLS
  Description: Comma-separated STUN servers for ICE gathering. If unset, no STUN servers are configured. A common default is Google’s public STUN.
  Example: stun:stun.l.google.com:19302,stun:global.stun.twilio.com:3478

- TURN_URL
  Description: TURN server URL to relay media when direct P2P is not possible. Recommended for production reliability, especially across NATs and firewalls. Requires TURN_USERNAME and TURN_PASSWORD to be effective.
  Example: turn:turn.example.com:3478

- TURN_USERNAME
  Description: Username for TURN authentication. Leave empty if you are not using a TURN server.

- TURN_PASSWORD
  Description: Password/credential for TURN authentication. Leave empty if you are not using a TURN server.

- MOCK_MODE
  Description: Enables a fully local/demo mode that avoids any external services. When true:
    • OTP request/verification returns a mock token.
    • Contacts are returned from an in-app mock list.
    • The Call screen initializes local camera preview so you can validate UI and device permissions.
    • Signaling is optional; if SIGNALING_URL is not provided, the app disables signaling and surfaces a banner in the Call screen.
  Accepted: true | false
  Default: true

## STUN/TURN Guidance
- STUN helps peers discover public-facing addresses; it is often sufficient for simple P2P connections but may fail behind restrictive NATs.
- TURN relays media through a server when peers cannot reach each other directly. For production deployments, configure a reliable TURN server with credentials and TLS if possible.
- In code, ICE servers are passed to WebRTCManager (lib/features/call/core/webrtc_manager.dart) via EnvConfig values.

## Signaling Integration
- The app includes a Socket.IO-based signaling client (lib/features/call/core/signaling_client.dart).
- To enable signaling:
  1. Set SIGNALING_URL to your Socket.IO endpoint.
  2. Ensure your server emits/handles events including joinRoom, offer, answer, ice-candidate, participant-joined, participant-left, inviteUser, joined-room, and error.
  3. In CallProvider, the app will connect and join the room when starting a call if signaling is configured.

Without a signaling server, you can still:
- Exercise the OTP flow (in MOCK_MODE).
- Load mock contacts.
- Open the Call screen and preview local media devices.
- Interact with UI controls like mute, camera toggle, switch camera, and speakerphone.

## Permissions
The app requests:
- Camera
- Microphone

Android manifests already declare:
- INTERNET
- CAMERA
- RECORD_AUDIO
- MODIFY_AUDIO_SETTINGS
- Camera and microphone features as not strictly required, to allow devices without them to install while still requesting permissions when needed.

At runtime, permission_handler is used to request camera and microphone. If denied, the app shows a banner on the Call screen indicating that permissions are required.

## Android Notes
- minSdkVersion must be >= 21 for flutter_webrtc. The project sets minSdk to maxOf(21, flutter.minSdkVersion) in android/app/build.gradle.kts, which fulfills this requirement.
- For best camera and audio performance, run on a physical device.

## Mock Mode Usage
- To run fully offline: set MOCK_MODE=true and leave API_BASE_URL and SIGNALING_URL empty.
- Features available in MOCK_MODE:
  - OTP returns a local mock token (no backend).
  - Contacts are in-app mock data.
  - Call screen initializes local camera preview and provides call controls.
- Features limited/disabled without external services:
  - No remote participants will appear without a configured signaling server.
  - No real OTP delivery or verification occurs when MOCK_MODE=true.

## Production Integration Checklist
- Backend OTP endpoints and contacts API available at API_BASE_URL.
- Socket.IO signaling server at SIGNALING_URL implementing the events referenced in SignalingClient.
- STUN/TURN servers configured and reachable from client devices.
- Review permissions and privacy disclosures per store policies.

## Quick Start Example
1. cp .env.example .env
2. Edit .env:
   - MOCK_MODE=true
   - STUN_URLS=stun:stun.l.google.com:19302
3. flutter pub get
4. flutter run

## License
MIT
