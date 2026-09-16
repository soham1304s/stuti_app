# MeshTalk — Offline-First Messaging Application

> A Flutter-based messaging application that works normally over the internet and automatically switches to nearby device-to-device communication when internet connectivity is unavailable.

## 📱 Overview

**MeshTalk** is an offline-first communication platform designed to allow users to communicate even when there is no internet connection.

The application provides familiar messaging features such as:

* One-to-one messaging
* Group messaging
* Text messages
* Images
* Voice messages
* File sharing
* Voice calls over supported networks
* User profiles
* Message delivery/read status
* Online/offline presence

### 🚀 Core Innovation

When the internet is unavailable, MeshTalk automatically searches for nearby MeshTalk users using Bluetooth.

If another user is nearby and has MeshTalk installed:

```text
                 INTERNET AVAILABLE
                         │
                         ▼
                ┌─────────────────┐
                │  MeshTalk Cloud │
                └────────┬────────┘
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
           User A                User B


                 INTERNET OFFLINE
                         │
                         ▼
              Bluetooth Discovery
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
           User A  ◄────────────► User B
                    Bluetooth
```

The application should automatically choose the best available communication transport.

---

# 🎯 Product Goal

Create a communication application where:

> **Internet is preferred, but communication does not completely stop when the internet disappears.**

The system should intelligently switch between:

1. Internet
2. Nearby Bluetooth
3. Nearby local device networking
4. Multi-hop mesh/store-and-forward communication

---

# 🧠 Communication Architecture

The application should use a **hybrid communication architecture**.

```text
                    ┌──────────────────┐
                    │   MeshTalk App   │
                    └────────┬─────────┘
                             │
                    Transport Manager
                             │
             ┌───────────────┼───────────────┐
             │               │               │
             ▼               ▼               ▼
        INTERNET           BLE          LOCAL NETWORK
             │               │               │
             ▼               ▼               ▼
         WebSocket       Discovery      Wi-Fi Direct /
         HTTPS/API       + Transport     Local Transport
             │
             ▼
          Server
```

The application should never tightly couple messaging logic to one transport.

Instead:

```text
Message
   ↓
Message Service
   ↓
Transport Manager
   ↓
┌──────────────┬──────────────┬──────────────┐
│ Internet     │ Bluetooth    │ Local Mesh   │
└──────────────┴──────────────┴──────────────┘
```

---

# 🏗️ Recommended Technology Stack

## Frontend

```text
Flutter
Dart
Material 3
Riverpod / Bloc
GoRouter
Drift / SQLite
```

## Backend

Implemented & Recommended Architecture:

```text
Rust (tokio + axum)
Stateless WebSocket P2P Signaling Relay
(No database required for core messaging)
```

Alternative cloud-synced backend:

```text
Firebase / Supabase (Optional for Authentication & Sync)
```

---

# 📡 Offline Communication Layer

This is the most important component of the application.

## Bluetooth Discovery

The application should advertise:

```text
MeshTalk device
```

and scan for nearby MeshTalk devices.

Each device should expose a temporary discovery identity.

Example:

```json
{
  "protocol": "meshtalk",
  "version": 1,
  "deviceId": "device-uuid",
  "publicKey": "public-key",
  "capabilities": [
    "text",
    "image",
    "file"
  ]
}
```

### Important

Do **not** broadcast:

* phone number
* email
* real name
* message contents
* private encryption keys

Bluetooth discovery should expose only the minimum information necessary.

---

# 🔐 Identity System

Every installation should generate a cryptographic identity.

```text
Installation
      │
      ▼
Generate Key Pair
      │
 ┌────┴─────┐
 ▼          ▼
Private     Public
Key         Key
```

The private key must remain on the device.

The server can know the public identity.

Example:

```text
User ID
   ↓
Public Key
   ↓
Device IDs
```

This makes secure offline communication possible without requiring a central server during the offline period.

### Optional Cloud Authentication
While the core messaging is based on pure cryptographic identities, the architecture includes a decoupled **Authentication Wrapper** (e.g. Firebase Auth).
This allows users to sign in via Google or Apple to link their identities across devices or sync settings, while leaving the core Bluetooth mesh completely independent of the backend login server.

---

# 🔒 End-to-End Encryption

All messages should be encrypted.

For online communication:

```text
User A
  ↓
Encrypt
  ↓
Server
  ↓
User B
  ↓
Decrypt
```

The server should never need access to plaintext message contents.

For offline communication:

```text
User A
  ↓
Encrypt for User B
  ↓
Bluetooth
  ↓
User B
  ↓
Decrypt
```

For mesh forwarding:

```text
User A
   │
   │ encrypted message
   ▼
User C
   │
   │ forward
   ▼
User B
```

User C should not be able to decrypt the message.

---

# 🕸️ Mesh Networking

A major feature of MeshTalk should be **store-and-forward communication**.

Suppose:

```text
Alice ─── Bob ─── Charlie
```

Alice cannot directly reach Charlie.

But Alice can reach Bob.

Therefore:

```text
Alice
  │
  │ Bluetooth
  ▼
Bob
  │
  │ Bluetooth
  ▼
Charlie
```

Alice's encrypted message can be temporarily stored by Bob.

When Charlie becomes reachable:

```text
Bob → Charlie
```

the message is forwarded.

---

# 🧩 Message Envelope

Every offline message should contain metadata similar to:

```json
{
  "messageId": "uuid",
  "senderId": "public-key-id",
  "recipientId": "public-key-id",
  "createdAt": 1758000000,
  "expiresAt": 1758600000,
  "ttl": 8,
  "hopCount": 0,
  "payloadHash": "sha256",
  "encryptedPayload": "..."
}
```

### TTL

TTL prevents messages from travelling indefinitely.

Example:

```text
TTL = 8 hops
```

After eight forwarding operations, the message should be discarded.

---

# 🔄 Message Routing

The first version should **not attempt to implement complicated routing algorithms**.

Start with controlled store-and-forward.

### Version 1

```text
Direct Bluetooth communication
```

### Version 2

```text
Bluetooth
+
Store-and-forward
```

### Version 3

```text
Multi-hop mesh
```

### Version 4

```text
Intelligent routing
```

The routing engine can eventually consider:

* device proximity
* message TTL
* hop count
* connection reliability
* battery level
* duplicate detection
* destination probability
* available storage

---

# 📲 Connectivity Manager

Create a central service:

```dart
ConnectivityManager
```

Responsibilities:

```text
Internet available?
Bluetooth available?
Nearby peers?
Local network available?
```

Example:

```text
ConnectivityManager
        │
        ├── Internet
        │
        ├── Bluetooth
        │
        └── Local Network
```

It should expose:

```dart
enum TransportType {
  internet,
  bluetooth,
  localNetwork,
}
```

---

# 🔀 Automatic Transport Selection

When sending a message:

```text
User presses Send
        │
        ▼
Message Service
        │
        ▼
Transport Manager
        │
        ├── Internet available?
        │       │
        │       └── YES → Internet
        │
        ├── Nearby recipient?
        │       │
        │       └── YES → Bluetooth
        │
        └── No connection
                │
                ▼
          Queue message
```

---

# 📥 Offline Message Queue

Messages must be stored locally.

Example:

```text
SQLite / Drift

messages
────────────────────────
id
conversation_id
sender_id
receiver_id
content
encrypted_content
status
transport
created_at
retry_count
```

Possible states:

```text
PENDING
SENDING
SENT
DELIVERED
READ
FAILED
QUEUED_OFFLINE
FORWARDED
```

---

# 📡 Nearby User Discovery

Create a dedicated service:

```dart
NearbyDeviceService
```

Responsibilities:

```text
Start Bluetooth scanning
        ↓
Find MeshTalk devices
        ↓
Read handshake information
        ↓
Verify identity
        ↓
Establish secure connection
```

The UI should show:

```text
Nearby MeshTalk Users

🟢 Rahul
   3 meters away

🟢 Priya
   7 meters away

🟢 Anonymous Device
   Nearby
```

Do not expose exact distance unless the platform/device capabilities make it reliable.

Use approximate proximity instead.

---

# 🤝 Secure Handshake

Before communication:

```text
Device A
   │
   │ Hello
   ▼
Device B
   │
   │ Public identity
   ▼
Device A
   │
   │ Verify
   ▼
Secure session
```

The handshake should establish:

* protocol version
* supported capabilities
* public identity
* session key
* device information required for routing

---

# 📨 Messaging Features

## 1. Text Messaging

Support:

```text
Plain text
Emoji
Replies
Reactions
Mentions
Message editing
Message deletion
```

## 2. Local P2P Stories / Statuses

Users can post temporary status updates ("Stories") completely offline:
* The poster's device spins up an embedded HTTP Server (acting as the backend).
* Nearby peers dynamically discover and fetch the JSON/Media payloads directly from the poster's local IP or Bluetooth endpoint.
* No central database is involved in hosting or serving the status.

---

# 🖼️ Media Messages

Support:

```text
Images
Videos
Audio
Documents
```

Offline media should be chunked.

Example:

```text
10 MB image

Chunk 1
Chunk 2
Chunk 3
...
Chunk N
```

Each chunk should have:

```json
{
  "fileId": "uuid",
  "chunkIndex": 4,
  "totalChunks": 20,
  "hash": "sha256",
  "encryptedData": "..."
}
```

If the connection breaks:

```text
Resume from chunk 5
```

instead of restarting the entire transfer.

---

# 🎤 Voice Messages

Voice messages should:

```text
Record
 ↓
Compress
 ↓
Encrypt
 ↓
Split into chunks
 ↓
Transfer
```

For offline mode, prioritize smaller compressed files.

---

# 👥 Group Messaging

Online:

```text
Group
 │
 └── Server
```

Offline:

```text
             ┌── Bob
             │
Alice ───────┼── Charlie
             │
             └── David
```

The application should queue encrypted group messages until group members become reachable.

Group encryption should be designed separately from simple one-to-one encryption.

---

# 📞 Calls

Internet calling can use:

```text
WebRTC
```

Offline Bluetooth calling should **not be part of the first MVP**.

Real-time voice communication over Bluetooth mesh introduces substantial challenges involving:

* bandwidth
* latency
* connection stability
* routing
* platform restrictions
* background execution

Build messaging first.

---

# 🗺️ Nearby Mode

The home screen can include:

```text
┌──────────────────────────────┐
│        MeshTalk              │
│                              │
│    🟢 Offline Mesh Mode      │
│                              │
│    5 Nearby Users            │
│                              │
│ ┌──────────────────────────┐ │
│ │ 👤 Rahul                 │ │
│ │    Nearby                │ │
│ │                          │ │
│ │ 👤 Priya                │ │
│ │    Nearby                │ │
│ └──────────────────────────┘ │
│                              │
│ [ Start Nearby Chat ]        │
└──────────────────────────────┘
```

---

# 🎨 Application UI

The UI is built to production-grade standards, strictly aligning with iOS-style dark mode aesthetics featuring an orange accent color. It supports dynamic Light/Dark mode toggling on the fly.

## Main Navigation

Use:

```text
Chats
Calls
Nearby
Contacts
Settings
```

Example:

```text
┌──────────────────────────────┐
│ MeshTalk              🔍 ⚙️  │
├──────────────────────────────┤
│                              │
│ 🟢 Offline Mesh Active       │
│ 4 nearby users               │
│                              │
│ ┌──────────────────────────┐ │
│ │ 👤 Rahul                 │ │
│ │ Last message...           │ │
│ │ 10:32 AM                  │ │
│ └──────────────────────────┘ │
│                              │
│ ┌──────────────────────────┐ │
│ │ 👤 Priya                 │ │
│ │ Image                     │ │
│ │ Yesterday                │ │
│ └──────────────────────────┘ │
│                              │
├──────────────────────────────┤
│ 💬 Chats  📡 Nearby  👤 Me  │
└──────────────────────────────┘
```

---

# 📴 Offline Status

The application should clearly communicate connectivity.

Example:

```text
🟢 Online
```

```text
🟡 Connecting
```

```text
🔵 Nearby Mesh
```

```text
⚫ Offline
```

A message can display:

```text
✓ Sent via Internet
```

or:

```text
✓ Sent via Bluetooth
```

or:

```text
↗ Forwarded through 2 devices
```

---

# 🏛️ Flutter Architecture

Use **Clean Architecture**.

```text
lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── crypto/
│   ├── permissions/
│   └── utils/
│
├── features/
│
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── chat/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── nearby/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── mesh/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── contacts/
│   ├── profile/
│   ├── calls/
│   └── settings/
│
├── services/
│   ├── connectivity_service.dart
│   ├── bluetooth_service.dart
│   ├── message_service.dart
│   ├── encryption_service.dart
│   └── sync_service.dart
│
└── main.dart
```

---

# 🧱 Core Services

## ConnectivityService

```dart
abstract class ConnectivityService {
  Stream<bool> get internetStatus;
  bool get isInternetAvailable;
}
```

---

## NearbyDeviceService

```dart
abstract class NearbyDeviceService {
  Future<void> startScanning();
  Future<void> stopScanning();

  Stream<NearbyDevice> get nearbyDevices;

  Future<SecureConnection> connect(
    NearbyDevice device,
  );
}
```

---

## TransportService

```dart
abstract class TransportService {
  Future<SendResult> send(Message message);
}
```

Implement:

```text
InternetTransport
BluetoothTransport
LocalNetworkTransport
```

---

# 🧠 Transport Manager

```dart
class TransportManager {

  Future<SendResult> send(Message message) async {

    if (internetAvailable) {
      return internetTransport.send(message);
    }

    if (recipientIsNearby) {
      return bluetoothTransport.send(message);
    }

    return queueForMesh(message);
  }
}
```

The production implementation should be more sophisticated, but this demonstrates the architecture.

---

# 💾 Local Database

Use SQLite through Drift.

Tables:

```text
users
devices
conversations
conversation_members
messages
message_chunks
attachments
delivery_receipts
nearby_devices
routing_records
encryption_keys
```

---

# 🔄 Synchronization

When internet becomes available:

```text
Internet detected
       ↓
Sync Manager
       ↓
Upload pending messages
       ↓
Download new messages
       ↓
Resolve duplicates
       ↓
Update message status
```

Example:

```text
Offline:

Message A
   ↓
Queued

Internet returns

Message A
   ↓
Server
   ↓
Delivered
```

---

# ♻️ Duplicate Prevention

Mesh networking can easily create duplicates.

Every message therefore needs a globally unique:

```text
messageId
```

Each device maintains:

```text
seenMessageIds
```

If:

```text
messageId already exists
```

discard the duplicate.

---

# 🧭 Mesh Routing Algorithm

Initial algorithm:

```text
1. Discover nearby devices
2. Perform secure handshake
3. Exchange message IDs
4. Identify messages missing on peer
5. Transfer required messages
6. Increment hop count
7. Store forwarded messages temporarily
8. Remove expired messages
```

Example:

```text
Alice has:

A
B
C

Bob has:

B
C
D

Exchange:

Alice → Bob:
A

Bob → Alice:
D
```

---

# ⏳ Message Expiration

Offline messages should not live forever.

Example:

```text
TTL:
24 hours
```

or:

```text
Maximum hops:
8
```

After expiration:

```text
Delete encrypted payload
Delete routing record
```

---

# 🔋 Battery Optimization

Bluetooth scanning can consume significant battery.

Do not scan continuously at maximum intensity.

Use:

```text
Adaptive scanning
```

Example:

```text
Active chat
    ↓
High-frequency scanning

Nearby screen open
    ↓
Medium scanning

Background
    ↓
Low-frequency discovery
```

---

# 🔐 Security Requirements

The application must protect against:

### Device impersonation

Use public-key identity.

### Message interception

Use end-to-end encryption.

### Replay attacks

Use:

```text
messageId
timestamp
nonce
```

### Duplicate flooding

Use message IDs and TTL.

### Malicious forwarding

Limit:

```text
hop count
message size
storage
rate
```

### Spam

Implement:

```text
rate limiting
peer reputation
block user
report user
connection throttling
```

---

# 🛡️ Privacy

The application should minimize metadata.

Avoid storing:

```text
exact location
Bluetooth history
unnecessary device identifiers
message plaintext
```

Nearby discovery should not reveal the user's phone number.

---

# 📱 Platform Considerations

## Android

Android should be the initial target for the offline mesh MVP.

Required permissions may include Bluetooth-related permissions depending on Android version and implementation.

The app must properly handle:

```text
Bluetooth enabled
Bluetooth disabled
Nearby device permission
Location-related platform requirements where applicable
Background restrictions
Battery optimization
```

---

# 🍎 iOS

iOS should be implemented separately because Apple's background execution and Bluetooth behavior differ significantly from Android.

Do not assume that a Bluetooth implementation designed for Android will behave identically on iOS.

Build a platform abstraction:

```text
Flutter
   │
   ├── Android Bluetooth implementation
   │
   └── iOS Bluetooth implementation
```

---

# 📦 Suggested Flutter Packages

Evaluate packages for:

```text
BLE
Bluetooth communication
SQLite
State management
WebSocket
HTTP
Encryption
Permissions
Audio recording
File handling
WebRTC
```

Do not select packages solely because they have many downloads.

Before production:

* check maintenance status
* inspect Android compatibility
* inspect iOS compatibility
* review permissions
* review security
* test background behavior
* test on real devices

---

# 🌐 Online Backend Architecture

```text
                 ┌───────────────┐
                 │ Flutter App   │
                 └───────┬───────┘
                         │
                 HTTPS / WebSocket
                         │
                         ▼
                ┌────────────────┐
                │ API Gateway    │
                └───────┬────────┘
                        │
             ┌──────────┼───────────┐
             ▼          ▼           ▼
          Auth       Messaging     Media
             │          │           │
             └──────────┼───────────┘
                        ▼
                   PostgreSQL
                        │
                      Redis
```

---

# 👤 Authentication

Support:

```text
Phone number
Email
Username
Passkey
```

For the first MVP:

```text
Phone number + OTP
```

can be used.

However, offline communication should rely on the cryptographic device identity rather than requiring authentication with the server every time.

---

# ☁️ Cloud Message Flow

```text
Sender
  ↓
Encrypt
  ↓
WebSocket/API
  ↓
Backend
  ↓
Recipient
  ↓
Decrypt
```

The backend handles:

```text
authentication
message routing
presence
push notifications
offline cloud storage
media storage
device synchronization
```

---

# 📡 Offline Message Flow

```text
Sender
  ↓
Encrypt
  ↓
Message Queue
  ↓
Bluetooth Discovery
  ↓
Recipient found?
  │
  ├── YES → Secure connection
  │             ↓
  │          Transfer
  │
  └── NO → Store locally
```

---

# 🕸️ Multi-Hop Flow

```text
Alice

Message:
"Hello Charlie"

      │
      ▼

     Bob
      │
      │ encrypted forwarding
      ▼

   Charlie
```

Bob never receives the plaintext if the message is encrypted end-to-end for Charlie.

---

# 🧪 Testing Strategy

## Unit Tests

Test:

```text
Message creation
Encryption
Decryption
TTL
Hop count
Duplicate detection
Queue management
Routing
Sync
```

---

# 🔌 Integration Tests

Test:

```text
Internet → Internet
Internet → Offline
Offline → Offline
Bluetooth discovery
Bluetooth connection
Message transfer
Interrupted transfer
Resume transfer
Device reconnect
```

---

# 📱 Real Device Testing

Do not rely only on Flutter emulators.

Test with:

```text
Android A
Android B
Android C
```

Test:

```text
A ↔ B
B ↔ C
A ↔ B ↔ C
```

Then disable internet on all devices.

Verify:

```text
A → B
A → C through B
```

---

# 🧪 Important Offline Test Cases

### Test 1

```text
Internet ON

A → B

Expected:
Instant server delivery
```

### Test 2

```text
Internet OFF

A → B
B nearby

Expected:
Bluetooth delivery
```

### Test 3

```text
Internet OFF

A → B
B far away

Expected:
Message remains queued
```

### Test 4

```text
A → C

A cannot reach C
B can reach both

Expected:

A → B → C
```

### Test 5

```text
Bluetooth connection interrupted

Expected:
Transfer resumes
```

### Test 6

```text
Same message received twice

Expected:
Duplicate discarded
```

---

# 🚀 Development Roadmap

## Phase 1 — UI

Build:

```text
Splash
Login
Home
Chat
Contacts
Profile
Settings
Nearby
```

No networking yet.

---

# Phase 2 — Online Messaging

Implement:

```text
Authentication
User profiles
1-to-1 chat
WebSocket
Message persistence
Push notifications
Media upload
```

---

# Phase 3 — Bluetooth Discovery

Implement:

```text
Bluetooth permission
Bluetooth scanning
Device advertising
Nearby user list
Secure handshake
```

---

# Phase 4 — Bluetooth Messaging

Implement:

```text
Text messages
Encryption
Message queue
Bluetooth transfer
Delivery status
Retry
```

---

# Phase 5 — Mesh

Implement:

```text
Store-and-forward
Message TTL
Hop count
Duplicate prevention
Peer exchange
Multi-hop delivery
```

---

# Phase 6 — Media

Implement:

```text
Images
Audio
Documents
Chunked transfer
Resume support
```

---

# Phase 7 — Advanced Features

Implement:

```text
Groups
Voice messages
WebRTC calls
Advanced routing
Background synchronization
Battery optimization
```

---

# 🧩 Recommended MVP

Do NOT attempt to build everything simultaneously.

The first production MVP should contain only:

```text
✓ User registration
✓ Profile
✓ 1-to-1 chat
✓ Internet messaging
✓ Offline message queue
✓ Bluetooth discovery
✓ Bluetooth text messaging
✓ End-to-end encryption
✓ Nearby users
✓ Automatic transport switching
```

Then add mesh routing.

---

# 📐 MVP Architecture

```text
                     Flutter
                        │
              ┌─────────┴─────────┐
              │                   │
           Online              Offline
              │                   │
         WebSocket              BLE
              │                   │
              ▼                   ▼
          Backend             Nearby Peer
              │                   │
              └─────────┬─────────┘
                        │
                  Message Service
                        │
                     SQLite
```

---

# 🎯 User Experience

The user should **not need to manually select Bluetooth mode**.

For example:

```text
User types:

"Are you nearby?"

Press Send
```

The application determines:

```text
Internet?
   ↓
No

Nearby recipient?
   ↓
Yes

Bluetooth?
   ↓
Yes

Send via Bluetooth.
```

The user sees:

```text
✓ Sent via Nearby Mesh
```

---

# 🔄 Smart Transport

The transport priority should be:

```text
                    Send
                      │
                      ▼
              Internet available?
                 /           \
               YES            NO
                │              │
                ▼              ▼
            Internet      Recipient nearby?
                              /      \
                            YES       NO
                             │         │
                             ▼         ▼
                         Bluetooth   Queue
```

Later:

```text
Queue
  ↓
Find relay
  ↓
Forward
  ↓
Find destination
  ↓
Deliver
```

---

# 🧠 Future Intelligence

Future versions can implement intelligent routing.

Example:

```text
Alice wants to contact David.

Nearby:

Bob
Charlie
Eve
```

The application can estimate:

```text
Bob → frequently encounters David
Charlie → rarely moves
Eve → battery low
```

The system can select an appropriate relay based on routing rules.

This should be introduced only after the basic mesh system is reliable.

---

# 📊 Developer Dashboard

For development/debug builds, create:

```text
Mesh Debug Console
```

Show:

```text
Internet: OFF
Bluetooth: ON

Nearby Devices: 4

Connections:
A → B
A → C

Queued Messages: 3
Forwarded Messages: 7
Successful Transfers: 15
Failed Transfers: 1

Mesh Hops:
Maximum: 4
Average: 1.7
```

This will make debugging the mesh system significantly easier.

---

# 🛠️ Project Setup

Create the Flutter project:

```bash
flutter create meshtalk
cd meshtalk
```

Recommended development structure:

```text
development/
│
├── flutter_app/
├── backend/
├── documentation/
└── infrastructure/
```

---

# 🌳 Git Branch Strategy

```text
main
│
├── develop
│
├── feature/auth
├── feature/chat
├── feature/bluetooth
├── feature/offline-messaging
├── feature/mesh
└── feature/encryption
```

---

# 📋 Definition of Done — MVP

The MVP is complete when:

```text
[ ] User can create an account
[ ] User can search contacts
[ ] User can start a conversation
[ ] User can send messages online
[ ] Messages are persisted locally
[ ] Internet loss is detected
[ ] Nearby MeshTalk devices are discovered
[ ] Devices perform secure handshake
[ ] Users can exchange encrypted text over Bluetooth
[ ] Messages show correct status
[ ] Messages retry after connection failure
[ ] Messages synchronize after internet returns
[ ] Duplicate messages are prevented
[ ] App handles Bluetooth permission denial
[ ] App handles Bluetooth being disabled
[ ] App handles internet returning
[ ] Real-device testing completed
```

---

# ⚠️ Important Technical Limitation

The phrase **"WhatsApp but through Bluetooth when there is no internet"** should not be interpreted as unlimited communication over Bluetooth.

Bluetooth communication is primarily useful for **nearby devices**.

For communication beyond Bluetooth range, the application needs:

```text
Multi-hop mesh
```

and participating devices need to relay messages.

For example:

```text
User A
  │
  │ 20m
  ▼
User B
  │
  │ 20m
  ▼
User C
  │
  │ 20m
  ▼
User D
```

This can extend communication beyond a single Bluetooth connection, but it introduces significant engineering challenges.

---

# 🔥 Long-Term Vision

MeshTalk can eventually become a **hybrid communication network**:

```text
                 INTERNET
                    │
              ┌─────┴─────┐
              │           │
           User A       User D
              │
            Mesh
              │
       ┌──────┼──────┐
       ▼      ▼      ▼
      B       C      E
       │      │
       └──┬───┘
          ▼
          F
```

When internet exists:

```text
Cloud communication
```

When internet disappears:

```text
Nearby mesh communication
```

When some devices have internet:

```text
Mesh → Internet gateway → Cloud
```

This creates a **hybrid resilient messaging network**.

---

# 🚀 Final Product Concept

MeshTalk should feel like a normal modern messaging application.

The complexity should remain invisible to the user.

The user simply sees:

```text
             MESSAGING
                 │
        ┌────────┴────────┐
        │                 │
      ONLINE            OFFLINE
        │                 │
     Internet           Nearby
        │                 │
        │              Bluetooth
        │                 │
        └────────┬────────┘
                 │
             Same Chat
```

The core principle is:

> **One conversation. Multiple transports. Automatic switching.**

Build the system around this principle from the beginning so that internet messaging, Bluetooth messaging, and future mesh networking remain separate transport implementations behind the same messaging layer.
