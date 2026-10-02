# Give On — An AI Platform That Protects Livestock Farms from Climate Disasters

> A climate-disaster response and civic-solidarity platform that uses AI to pre-emptively predict and warn livestock farms of extreme heat/cold events, and connects damaged farms with citizen donors through a local-currency reward loop.

**Project period:** April 24 – May 18, 2026 (4-week MVP)
**Team:** 1 macOS/iOS engineer + 1 frontend engineer
**Built for:** *2026 Ministry of Climate Change AX (AI Transformation) Idea Competition*

<!-- 🖼️ IMAGE SUGGESTION #1
Location: right below the title, as a hero banner (1200×600, same aspect ratio as the repo's OG image)
Content: A composite hero showing a livestock farm (chicken/cattle barn) overlaid with a heat-wave temperature gradient and a small "risk alert" push-notification mockup, to visually establish the problem (climate) + solution (AI alert) in one image. -->

---

## Table of Contents

1. [Why This Project Exists](#1-why-this-project-exists)
2. [Concept & Value Proposition](#2-concept--value-proposition)
3. [What the Platform Does](#3-what-the-platform-does)
4. [System Architecture](#4-system-architecture)
5. [Repository Structure](#5-repository-structure)
6. [AI Agent Design](#6-ai-agent-design)
7. [Public Data Sources](#7-public-data-sources)
8. [Tech Stack](#8-tech-stack)
9. [Getting Started](#9-getting-started)
10. [Business Model](#10-business-model)
11. [Development Roadmap](#11-development-roadmap)
12. [Team & Tooling](#12-team--tooling)
13. [Collaboration Rules](#13-collaboration-rules)

---

## 1. Why This Project Exists

Climate change is no longer a future risk for Korean livestock farming — it is a recurring, structural crisis.

**Scale of the problem (2025 data referenced in the project proposal):**

- Roughly **1.46 million livestock deaths** were reported nationwide from heat waves (Jul–Aug 2025).
- Poultry (chickens/ducks) accounted for about **88%** of all losses.
- In a single region (Jeonbuk), **166,453 animals died** across 401 farms.
- Heavy snowfall in Gyeonggi-do in the fall of 2024 caused an estimated **₩181.1 billion** in livestock-sector damage.

**Why existing responses fall short:**

| Existing response | Limitation |
|---|---|
| Korea Meteorological Administration (KMA) heat-wave advisories | Issued at a broad regional level; no farm-specific action guidance |
| Ministry of Agriculture text alerts | Often arrive *after* the risk window has already opened |
| Livestock disaster insurance | Purely compensatory — does not prevent the deaths in the first place |
| Local government support | Budget execution is slow; emergency in-kind aid is hard to mobilize quickly |

On top of this, ordinary citizens who want to help farms hit by climate disasters have **no immediate, trustworthy channel** to act — donation intent exists, but there's no clear "where" or "how."

Give On was built to close both gaps at once: give farms a **golden-hour early warning**, and give citizens a **direct, transparent way to help** the moment damage occurs.

---

## 2. Concept & Value Proposition

> In a climate crisis, farms need a "golden hour." Give On delivers a warning to farms **2–3 hours before** a critical threshold is crossed, and connects citizens to affected farms **within 24 hours** of a damage report.

The platform is deliberately split into three purpose-built surfaces sharing one backend, so that each stakeholder — farmer, donor, and administrator — gets an experience shaped for their context (rural/mobile-first for farmers, consumer-web for donors, ops dashboard for administrators/local government).

| Product | Platform | Primary user |
|---|---|---|
| **Give On Farm** | iOS (SwiftUI) | Livestock farmers |
| **Give On Give** | Web (Next.js) | General public / donors |
| **Give On Admin** | PWA (responsive web) | Operations team / local government staff |
| **Give On API** | Python FastAPI | Shared backend for all three |

<!-- 🖼️ IMAGE SUGGESTION #2
Location: end of Section 2
Content: A 3-column "who uses what" diagram — farmer holding a phone with a red/yellow/green risk gauge, a citizen browsing a donation feed on a laptop, and an admin looking at a national risk map on a tablet — to make the three-sided platform concept immediately legible. -->

---

## 3. What the Platform Does

### 3.1 End-to-end flow

```
[KMA weather API] ──→ [AI Agent risk scoring]
                             │
                 ┌───────────┼───────────┐
                 ↓           ↓           ↓
            [No risk]   [Caution]    [Danger]
                 │           │           │
          Routine report  Prevention  Immediate alert
                                       + response guide
                                          │
                                 [Livestock loss occurs]
                                          │
                              [Auto-registered on Give On Give]
                                          │
                     ┌────────────────────┼────────────────────┐
                     ↓                    ↓                    ↓
              Citizen donation      Supply delivery      Reward points issued
                     │                    │                    │
              Tax-deduction receipt  On-site confirmation  Local-currency conversion
```

### 3.2 Give On Farm (farmer-facing iOS app)

- Real-time, **dong/myeon-level (neighborhood-level)** weather forecast tied to the farm's registered location.
- Automatic comparison against **species-specific temperature/humidity thresholds** → a traffic-light risk indicator.
- **Immediate push notification** plus an AI-generated, farm-specific response guide once a danger threshold is reached.
- A response checklist whose completion is **automatically logged** as an insurance-relevant response record.
- **One-tap damage report** that auto-generates a donation page for that farm.
- **SMS / Kakao AlimTalk fallback** for older farmers who may not rely on push notifications.

**Rule-based risk thresholds:**

| Species | Caution | Danger | Emergency |
|---|---|---|---|
| Chicken (broiler/layer) | ≥ 30°C | ≥ 33°C | ≥ 36°C |
| Pig | 28°C + 65% humidity | 30°C + 70% humidity | ≥ 33°C |
| Cattle (Hanwoo/dairy) | ≤ -5°C | ≤ -10°C | ≤ -15°C |
| Duck | ≥ 32°C | ≥ 35°C | ≥ 38°C |

### 3.3 Give On Give (citizen donation web)

- A live map of currently affected farms — "a farm near you needs help right now."
- Item-based donations (cooling fans, feed, quarantine/disinfection supplies, etc.).
- One-click checkout via KakaoPay / Naver Pay.
- **Instant tax-deduction receipt** issuance (Korea's annual ₩50,000 donation deduction threshold).
- Local-currency (지역화폐) reward points proportional to the donation amount.
- Social sharing ("I just helped this farm").

### 3.4 Give On Admin (operations PWA)

- A real-time national/regional map of at-risk farms.
- A priority-sorted list of at-risk farms for field visits.
- Donation-to-delivery matching and fulfillment tracking.
- Automated weekly/monthly damage-statistics reports.
- A shareable link for local-government staff that requires no app install.

<!-- 🖼️ IMAGE SUGGESTION #3
Location: within Section 3, right after the end-to-end flow diagram
Content: An actual (or wireframed) screenshot/mockup of the Give On Farm home screen — risk traffic light, current weather, AI alert text, response checklist — since this is the emotional core of the product and static ASCII diagrams under-sell it. -->

<!-- 🖼️ IMAGE SUGGESTION #4
Location: within Section 3.3, after the Give On Give bullet list
Content: A screenshot/mockup of the citizen donation web landing page, especially the "urgent donation card" and the national damage map, to show the consumer-facing product. -->

---

## 4. System Architecture

```
[Give On Farm iOS]        [Give On Web]           [Give On Admin PWA]
  (farmer app)           (donation web)           (admin dashboard)
        │                       │                          │
        └───────────────────────┼──────────────────────────┘
                                 │ REST API
                                 ▼
                       [FastAPI Backend]
                       (Python + Claude AI)
                                 │
                ┌────────────────┼────────────────┐
                ▼                ▼                 ▼
         [KMA Weather API]  [Claude API]     [Supabase (PostgreSQL)]
```

All three client surfaces talk to a single FastAPI backend over REST. The backend is the only component that talks to the Korea Meteorological Administration (KMA), the Claude API, and the Supabase-hosted PostgreSQL database — this keeps API keys and business logic (risk scoring, message generation, reward calculation) centralized and out of client code.

<!-- 🖼️ IMAGE SUGGESTION #5
Location: immediately after this architecture diagram
Content: A polished, rendered version of this ASCII diagram (boxes/arrows) using the project's brand colors, for anyone skimming the README who won't parse the text-art. -->

---

## 5. Repository Structure

This is a **monorepo** containing three client applications and one shared backend:

```
give-on/
├── packages/
│   ├── backend/                 # FastAPI backend (owned by the macOS engineer)
│   │   ├── app/
│   │   │   ├── main.py
│   │   │   ├── config.py
│   │   │   ├── database.py
│   │   │   ├── api/             # Routers
│   │   │   ├── agent/           # AI agent: risk scoring, Claude integration
│   │   │   ├── data/            # Public-data API clients
│   │   │   ├── models/          # SQLAlchemy ORM models
│   │   │   ├── schemas/         # Pydantic schemas
│   │   │   └── notifications/   # FCM push, AlimTalk (Kakao) messaging
│   │   ├── tests/
│   │   ├── migrations/          # DB migrations
│   │   ├── requirements.txt
│   │   ├── .env.example
│   │   └── Dockerfile
│   │
│   ├── ios/                     # SwiftUI iOS app (owned by the macOS engineer)
│   │   ├── GiveOnFarm/
│   │   │   ├── Core/            # Networking, notifications, storage
│   │   │   ├── Features/        # Onboarding, home, alerts, settings
│   │   │   ├── DesignSystem/    # Colors, typography, shared components
│   │   │   └── Resources/       # Assets, plist
│   │   └── GiveOnFarm.xcodeproj
│   │
│   └── web/                     # Next.js web app (owned by the frontend engineer)
│       ├── app/                 # App Router
│       │   ├── layout.tsx
│       │   ├── page.tsx         # Main landing page
│       │   ├── donate/          # Donation flow
│       │   ├── admin/           # Admin PWA
│       │   └── map/             # Damage-status map
│       ├── components/
│       ├── lib/                 # API client, utilities
│       ├── types/
│       ├── public/               # Static assets + PWA manifest
│       ├── package.json
│       └── next.config.ts
│
├── docs/
│   ├── drafts/                  # Planning documents (proposal, dev plan, schedule)
│   ├── architecture/            # Architecture diagrams
│   ├── api/                     # API specification
│   └── deployment/               # Deployment guide
│
├── .github/
│   └── workflows/               # CI/CD pipelines
│
├── infra/
│   ├── docker/                  # Docker Compose
│   └── terraform/               # IaC (optional)
│
├── .env.example
├── README.md
├── CLAUDE.md                    # Guide for working with Claude Code on this repo
└── package.json                 # Monorepo management
```

---

## 6. AI Agent Design

The project deliberately splits intelligence into two tiers, to keep the system fast, cheap, and predictable where possible, and reserve the LLM for what only an LLM can do well:

```
Anything a rule can decide      → deterministic rule engine (fast, cheap)
Anything that needs human language → Claude API (personalized, natural)
```

### Where Claude is used

**① Generating risk-alert messages.**
Rather than a generic "heat wave warning," the agent generates a message tailored to the specific farm's species, herd size, and local forecast.

```
[Rule engine]  Chicken barn exceeds 33°C
        ↓
[Claude API call]
Input:  farm profile (50,000 layer hens, Pocheon), current temp (34°C), forecast (37°C tomorrow)
Output: "Current temperature in Pocheon is 34°C, forecast to reach 37°C tomorrow.
         For a 50,000-hen layer operation, run ventilation fans at maximum now
         and keep drinking-water temperature below 20°C.
         Today's highest-risk window is 2–4 PM."
```

**② Auto-generating damage-report stories for donation pages.**
When a farmer submits a damage report, the agent turns structured input into a donation-page narrative.

**③ A donor-facing chatbot** that answers common questions ("Where does my donation actually go?", "How does the tax deduction work?", "When do local-currency points arrive?").

### Agent execution cadence

| Timing | Task | Technology |
|---|---|---|
| Every 30 minutes | Collect weather data | APScheduler + KMA API |
| Immediately on threshold breach | Determine risk level | Rule engine (Python) |
| On risk detection | Generate a personalized alert message | Claude API (`claude-haiku-4-5`) |
| On risk detection | Send push notification | Firebase Cloud Messaging |
| On damage report | Generate donation-page story | Claude API (`claude-haiku-4-5`) |
| Daily at 07:00 | Send a daily risk-forecast summary | Claude API + FCM |
| Every Monday | Generate weekly statistics report | Claude API + PDF generation |

The choice of `claude-haiku-4-5` throughout is deliberate cost optimization — the agent is designed to run frequent, small, latency-sensitive calls (target: alert generation in under 2 seconds) rather than a small number of large ones.

<!-- 🖼️ IMAGE SUGGESTION #6
Location: within Section 6, next to the "AI Agent execution cadence" table
Content: A simple timeline/sequence diagram showing the 30-min polling loop, the branch into "no risk / alert / report," and where Claude is invoked at each branch — helps readers who skim tables understand the agent's control flow at a glance. -->

---

## 7. Public Data Sources

Give On cross-references **six public data APIs**:

| # | Dataset | Provider | Format | Purpose |
|---|---|---|---|---|
| 1 | Village-level forecast | Korea Meteorological Administration (KMA) | OpenAPI | Neighborhood-level temperature/humidity forecast |
| 2 | Weather advisory service | KMA | OpenAPI | Immediate trigger for heat-wave/cold-wave advisories |
| 3 | Living weather index | KMA | OpenAPI | Perceived temperature and heat-index calculation |
| 4 | Livestock farm registry | Ministry of Agriculture, Food and Rural Affairs | File | Building the national farm database |
| 5 | AirKorea air-quality data | Korea Environment Corporation | OpenAPI | Compound risk scoring including air quality |
| 6 | Regional local-currency data | Individual local governments | OpenAPI / file | Linking donation rewards to local-currency systems |

**Data fusion approach:** temperature/humidity from the village forecast, the heat-index from the living weather index, and air-quality data from AirKorea are combined into a single composite risk score per species — the premise being that temperature alone is a weaker predictor of livestock mortality than temperature combined with humidity and air quality.

---

## 8. Tech Stack

| Layer | Technology | Owner |
|---|---|---|
| Frontend (Web) | Next.js 15, Tailwind CSS | Frontend engineer |
| iOS App | Swift 6, SwiftUI, Firebase Cloud Messaging | macOS engineer |
| Backend | Python FastAPI, Claude API, LangChain | macOS engineer |
| Database | PostgreSQL (Supabase) | Shared |
| Deployment | Railway (backend), Vercel (web) | Shared |

**Full breakdown (from the project's technical appendix):**

```
Frontend (frontend engineer)
├── Framework: Next.js 15 (App Router)
├── Styling: Tailwind CSS
├── Maps: Kakao Maps SDK
├── Payments: KakaoPay SDK, Toss Payments
└── Deployment: Vercel

iOS App (macOS engineer)
├── Language: Swift 6
├── UI: SwiftUI
├── Push: Firebase Cloud Messaging (FCM)
├── Networking: URLSession / Alamofire
└── Distribution: TestFlight → App Store

Backend (macOS engineer)
├── Framework: Python FastAPI
├── AI: Anthropic Claude API (claude-haiku-4-5)
├── Agent orchestration: LangChain
├── Scheduler: APScheduler
├── Database: PostgreSQL (Supabase)
├── Push: FCM Admin SDK
├── SMS: Kakao AlimTalk API
└── Deployment: AWS EC2 or Railway.app
```

---

## 9. Getting Started

### Backend

```bash
cd packages/backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload --port 8000
```

### Web

```bash
cd packages/web
npm install
npm run dev
# http://localhost:3000
```

### iOS

```bash
cd packages/ios/GiveOnFarm
open GiveOnFarm.xcodeproj
```

---

## 10. Business Model

Give On is designed as a **privately operated service built on top of public data** — the government provides data and policy linkage; a private team captures the resulting value. Three revenue tracks:

1. **Farm subscriptions (core revenue).** Tiered plans (Basic: weather alerts + app notifications; Pro: + AI response guidance and automatic insurance-history logging; Enterprise: negotiated contracts with agricultural cooperatives). Against Korea's ~90,000 registered livestock farms, even a 3% penetration rate at the Basic tier is modeled at roughly ₩8.1B/month.
2. **Donation platform fees.** A 5–7% intermediary fee on citizen donations, plus corporate ESG-linked giving programs.
3. **Insurer / local-government (B2G).** Data-partnership fees with agricultural disaster insurers (early warning → lower mortality → lower claims), and paid Admin PWA subscriptions for local governments.

The proposal explicitly frames *why* this should be a private venture rather than a government service: a public agency charging subscription fees would compete unfairly with the private market, and the competition itself is designed to seed private-sector commercialization of public data — public data opened → private innovation → new market, which is the outcome the sponsoring ministry is optimizing for.

**Year-1 targets (proposal goals):** 5,000 subscribed farms, ≥85% alert accuracy, a 30%+ reduction in mortality among alert-receiving farms (vs. prior year), 50,000 citizen donors, ₩500M in annual donations, and local-currency circulation active in 10 participating regions.

---

## 11. Development Roadmap

### Phase 1 — MVP (competition demo, 4 weeks)

- **Week 1:** Backend foundation — FastAPI server, KMA API integration + scheduler, species-specific rule engine, Claude-generated alert messages.
- **Week 2:** Farmer iOS app (SwiftUI) — risk home screen, FCM push handling, response checklist UI.
- **Week 3:** Citizen web + admin PWA — donation flow (test-mode payments), damage map (Kakao Maps), basic admin dashboard.
- **Week 4:** Integration testing + demo prep — end-to-end flow testing, demo scenario, presentation materials.

### Phase 2 — Public launch (post-competition, 3 months)

Real KakaoPay/Naver Pay payment integration, real local-currency API integration (starting with Gyeonggi-do), a tax-deduction receipt issuance system, an Android app, and a 100-farm pilot.

### Phase 3 — Scale-up (6+ months)

Nationwide farm outreach (via agricultural cooperatives), insurer data-partnership agreements, paid B2G contracts with local governments, and corporate ESG donation programs.

<!-- 🖼️ IMAGE SUGGESTION #7
Location: within Section 11, above the Phase 1/2/3 breakdown
Content: A horizontal roadmap/Gantt-style graphic spanning the 4-week MVP sprint and the two post-launch phases, so the timeline reads visually rather than as three separate paragraphs. -->

---

## 12. Team & Tooling

| Role | Core skills | Primary responsibilities |
|---|---|---|
| macOS / iOS engineer | Swift, SwiftUI, Python | iOS farmer app + FastAPI backend + AI agent |
| Frontend engineer | React, Next.js, TypeScript | Citizen web + admin PWA + Kakao Maps integration |

**Tooling used to build this in 4 weeks:**

- **Claude Code** — backend boilerplate and public-API integration code generation.
- **GitHub Copilot** — in-editor code assistance.
- **Supabase** — database and authentication (free tier during MVP).
- **Vercel** — web deployment, optimized for Next.js.
- **Xcode + TestFlight** — iOS build and beta distribution.

---

## 13. Collaboration Rules

**Branching:** `main → dev → feature/<description>`

**Commit convention:**

```
feat: new feature
fix: bug fix
docs: documentation changes
```

**Daily sync:** 22:00 daily (after work hours), over Slack/KakaoTalk — progress and blockers only.

---

## Further Reading

| Document | Description |
|---|---|
| [`docs/drafts/give-on_schedule.md`](https://github.com/Ahn-s-Know/give-on/blob/main/docs/drafts/give-on_schedule.md) | Detailed development schedule |
| [`docs/drafts/give-on_dev_plan.md`](https://github.com/Ahn-s-Know/give-on/blob/main/docs/drafts/give-on_dev_plan.md) | Technical design (API spec, DB schema, env vars) |
| [`docs/drafts/give-on_proposal.md`](https://github.com/Ahn-s-Know/give-on/blob/main/docs/drafts/give-on_proposal.md) | Full competition proposal |
| [`CLAUDE.md`](https://github.com/Ahn-s-Know/give-on/blob/main/CLAUDE.md) | Guide for using Claude Code on this repo |

---

**Last updated:** 2026-04-26
**Competition submission deadline:** 2026-05-18
