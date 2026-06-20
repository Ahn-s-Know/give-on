# Give On — Stitch 화면별 프롬프트 모음

> 복붙용. 각 프롬프트는 독립적으로 사용 가능.  
> 공통 지시사항을 먼저 Stitch에 등록한 후 각 화면 프롬프트를 사용할 것.

---

## 공통 Design Context (모든 프롬프트 앞에 붙이거나 Stitch 프로젝트 설정에 등록)

```
Design system context:
- Platform: Give On — Korean climate-disaster donation platform connecting farmers with citizens through ugly produce rewards
- Canvas: #fafaf8 (warm off-white, never pure white)
- Primary color: #2d6a4f (Earth Green) — all positive CTAs, brand moments, progress fills
- Urgency color: #e63946 (Harvest Red) — disaster alerts ONLY, never decorative
- Warning color: #f4a261 (Amber) — caution level alerts
- Text ink: #1c1c1a (near-black, warm undertone)
- Muted text: #6b6862
- Surface soft: #f2f0ed
- Surface dark: #1a2e1e (emergency full-screen state)
- Primary light: #d8f3dc (positive notification background)
- Urgency light: #fde8e8 (alert panel background)
- Font: Pretendard (Korean variable font), fallback Noto Sans KR
- Body line-height: 1.7 (Korean text needs room)
- Border radius: cards 12px, CTAs full pill (9999px), photos 16px, alerts 4px
- Shadow: rgba(0,0,0,0.04) 0 1px 3px, rgba(0,0,0,0.08) 0 4px 12px (one tier only)
- All UI labels and button text in Korean
- Primary CTA shape: always full pill, never square
- No gradients (exception: Climate Journey Card background only)
```

---

## iOS App 화면 (8개)

---

### Screen 0 — 로그인 / 초기 등록

```
Design a Korean-language iOS login/registration screen for Give On Farm app at 375×812px. Entry point. Simple mode selection.

Design system: [공통 context 붙이기]

Layout (top to bottom):
- Status bar (iOS standard)
- Logo section: Give On logotype center, 24px top padding
- Headline: "농장 등록" 26px/700/#1c1c1a center, 32px top margin

- ACCESSIBILITY QUESTION (prominent, 48px top margin):
  - Question text: "입력이 어려우신가요?" 18px/600/#1c1c1a center
  - Sub-question: "글자 입력 대신 음성으로도 등록할 수 있습니다" 14px/400/#6b6862 center, 1.6 line-height
  - Two buttons stacked, 56px height each, full-width, 16px gap, 32px margin:
    - Top: "🎤 음성으로 등록" full pill, #2d6a4f fill, white text 16px/600. Routes to Screen 0-AS.
    - Bottom: "⌨️ 직접 입력" full pill, white fill, 1px #2d6a4f border, #2d6a4f text 16px/600. Routes to Screen 1.

Tone: Minimal, clear. No distractions. Large buttons for elderly. One choice, direct action. Skip farm search entirely (handled in Screen 2).
```

---

### Screen 0-AS — 음성 기반 등록 (어르신 모드)

```
Design a Korean-language iOS voice registration screen for Give On Farm app at 375×812px. Accessibility mode for elderly farmers using speech input. Minimal, focused UI.

Design system: [공통 context 붙이기]

Context: User selected "🎤 음성으로 등록" on Screen 0. App auto-plays question via TTS, user records answer via voice.

Layout (top to bottom):
- Status bar (iOS standard)
- Navigation bar: back chevron left, "음성 등록" title center 17px/600/#1c1c1a. Question progress: "질문 1/4" 13px/#6b6862 right.

- CENTERED CONTENT (massive, focused):
  - Large microphone icon (120px diameter, centered, #2d6a4f) with idle/listening state:
    - Idle: static, gray overlay at 30%
    - Listening: pulsing animation (1.0 → 1.12 scale, 1.5s ease-in-out infinite)
  - AI question text (below icon): "농장이 있는 지역은 어디인가요?" 20px/600/#1c1c1a center, max 2 lines, 24px top margin
  - Help hint: "(시/도와 시/군/구를 말씀해주세요. 예: 경기도 포천시)" 13px/#6b6862 center, 8px top margin

- USER ANSWER DISPLAY (white card, 12px radius, 16px padding, full-width, 48px height, 24px margin):
  - Recognized text (real-time): "경기도 포천시..." 18px/500/#1c1c1a
  - If empty/waiting: "대기 중..." 18px/#9b9792 italic
  - Do NOT show confidence meter (visual clutter)

- ACTION BUTTONS (two rows, full-width, 24px margin, 8px gap):
  - Row 1 (two side-by-side, 48px height):
    - "✓ 다음 질문으로" full pill #2d6a4f, white text 16px/600. Confirms answer and auto-plays next question.
    - "🔄 질문 다시 듣기" outline pill, 1px #2d6a4f border, #2d6a4f text 16px/600. Replays current question via TTS.
  - Row 2 (single, 48px height):
    - "✎ 직접 입력" outline pill, 1px #6b6862 border, #6b6862 text 16px/600. Switches to text input mode for current question.

Navigation flow:
1. Q1: "농장이 있는 지역은 어디인가요?" → location
2. Q2: "어떤 가축이나 농작물을 기르시나요? 예를 들어 '닭 5000마리'처럼 말씀해주세요." → livestock/crop name + quantity
3. Q3: "추가로 기르시는 다른 가축이나 농작물이 있으신가요?" (yes/no) → if yes, loop to Q2; if no, Q4
4. Q4: "농장명이나 상호는 무엇인가요?" → farm name/address
→ Confirm all data, proceed to home

Tone: Warm, patient, ultra-simple. One question at a time. Large readable text. Generous button sizes. No visual noise.
```

---

### Screen 1 — 온보딩 (농가 현황 등록)

```
Design a Korean-language iOS onboarding screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Screen: Farm registration onboarding — Step 1 of 2 (livestock + crop entry with validation). Sequential, single-screen flow.

Layout (top to bottom):
- Status bar (iOS standard)
- Step indicator: 2 dots top-center, dot 1 active in #2d6a4f, dot 2 inactive in #e0ddd8. Below: "1/2 · 농장 현황" in 13px/#6b6862

- Section title: "기르고 있는 것들을 모두 입력해주세요" in 22px/700/#1c1c1a, 24px top margin
- Helper text: "축종이나 작물명 (예: 닭, 사과) + 수량을 입력하면 됩니다" 14px/400/#6b6862, 1.6 line-height, 8px top margin

- **INPUT FORM SECTION (scrollable):**
  
  **NAME/TYPE FIELD:**
  - Label: "축종/작물명" 13px/500/#6b6862, 24px top margin
  - Input: full-width, 56px height, 8px radius, 1px #e0ddd8 border. Placeholder: "예: 닭, 사과, 당근..." in #9b9792. Focus: 2px #2d6a4f border.
  - Helper: "축종이나 작물 이름을 입력하세요" 12px/#9b9792, 4px top margin

  **QUANTITY FIELD (appears after name filled):**
  - Label: "수량" 13px/500/#6b6862, 16px top margin
  - Input row: 
    - Left input: full-width, 56px height, 8px radius, 1px #e0ddd8. Placeholder: "예: 50000" in #9b9792. Focus: 2px #2d6a4f border. Numeric keyboard.
    - Right dropdown (auto-calculated based on name validation): "마리" or "평" or "포기" etc. 14px/#6b6862, read-only. Updates after name submission.
  - Helper: "수량이 많을수록 경보 우선순위가 높아집니다" 12px/#6b6862, 4px top margin

  **ACTION BUTTONS (appears after both name + quantity filled):**
  - Row: two buttons side by side, 48px height, 8px gap, 24px margin:
    - "➕ 추가" full pill #2d6a4f, white text 16px/600. Validates name against crop/livestock database. If invalid: show error tooltip "닭은 존재하지 않습니다. 다시 입력하세요" in #e63946, 12px. If valid: adds to list below, clears form.
    - "완료" outline pill, 1px #2d6a4f border, #2d6a4f text 16px/600. Appears only if 1+ items in list. Routes to Screen 2.

- **REGISTERED LIST SECTION:**
  - Section title (appears as items added): "등록한 농산물" 17px/600/#1c1c1a, 24px top margin
  - Each entry row (white card, 12px radius, 1px #e0ddd8, 16px padding, 12px gap between rows):
    - Left: "닭 · 50,000마리" 16px/500/#1c1c1a
    - Right: "✕" delete icon (14px, #9b9792, tap removes)
  - Entry count: "등록 항목: 2개" 13px/#6b6862, 12px top margin

- Safe area bottom padding.

Validation flow:
- On "➕ 추가" tap: Send name to backend crop/livestock database. If matched: confirm unit (마리/평/etc). If unmatched: show error, user retypes.
- Multiple additions allowed; all displayed in list.
- "완료" available only if 1+ valid entries.

Tone: Simple, direct. No tabs, no presets, just text input. Validation error messages are clear and encouraging. List feedback reassures user.
```

---

### Screen 2 — 온보딩 (농장 위치 등록)

```
Design a Korean-language iOS onboarding screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Screen: Farm registration onboarding — Step 2 of 2 (location + farm name/address confirmation). Uses CLLocationManager + OpenAPI lookup.

Layout (top to bottom):
- Status bar (iOS standard)
- Step indicator: 2 dots top-center, dot 2 active in #2d6a4f, dot 1 inactive in #e0ddd8. Below: "2/2 · 농장 위치" in 13px/#6b6862

- **INITIAL LOCATION PROMPT (on first load):**
  - Section title: "현재 위치에서 시작할게요" 22px/700/#1c1c1a, 24px top margin
  - Info card (12px radius, #d8f3dc background, 1px #2d6a4f border, 16px padding):
    - "📍 정부 등록 농장 정보를 자동으로 조회합니다" 14px/500/#2d6a4f
    - "현재 위치 사용" button (full pill #2d6a4f, white 16px/600, 48px height, full-width, 24px margin)
  - OR manual address input (alternative):
    - "직접 주소 입력하기" secondary outlined button, 48px height, full-width, 24px margin

- **GOVERNMENT REGISTRATION LOOKUP (if location found in OpenAPI):**
  - Processing state: "조회 중..." 16px/400/#6b6862 center, loading spinner
  - Result card (if match found, 12px radius, 1px #2d6a4f border, #d8f3dc background, 16px padding):
    - Confirmation question: "이 농장이 맞나요?" 18px/600/#1c1c1a, 24px top margin
    - Farm details card:
      - Farm name: "김철수 농장" 16px/600/#1c1c1a
      - Address: "경기도 포천시 어딘가" 14px/400/#6b6862
      - Farm owner: "주인: 김철수" 13px/#6b6862
      - Government ID: "정부 등록 ✓" 13px/#2d6a4f
    - Two buttons (48px height, full-width, 8px gap):
      - "네, 맞습니다" full pill #2d6a4f, white text 16px/600. Proceeds to home.
      - "아니요, 다시 입력" outline #2d6a4f, 1px border, #2d6a4f text 16px/600. Routes to manual input.

- **MANUAL LOCATION ENTRY (if no match or user selects manual):**
  - Section title: "농장 주소" 17px/600/#1c1c1a, 24px top margin
  - Address input: full-width, 56px height, 8px radius, 1px #e0ddd8 border, placeholder "예: 경기도 포천시 어딘가" in #9b9792. Focus: 2px #2d6a4f border.
  - Helper text: "시/도, 시/군/구까지만 입력해도 됩니다" 13px/#6b6862, 8px top margin

  - **ADDRESS CONFIRMED, NOW FARM NAME:**
  - Section title (appears after address filled): "농장명 또는 상호" 17px/600/#1c1c1a, 24px top margin
  - Farm name input: full-width, 56px height, 8px radius, 1px #e0ddd8 border, placeholder "예: 김철수 농장" in #9b9792. Focus: 2px #2d6a4f border.
  - Helper text: "필수입력. 농가 식별용으로 사용됩니다" 13px/#6b6862, 8px top margin

  - Button (appears after both fields filled):
    - "완료" full pill #2d6a4f, white text 16px/600, 48px height, full-width, 24px margin. Validates both fields and proceeds to home.

- Safe area bottom padding.

Tone: Efficient, reassuring. Location data feels automatic and effortless. Confirmation step prevents errors for manual entry. Sequential fields reduce cognitive load.
```

---

### Screen 3 — 홈 화면 (안전 상태)

```
Design a Korean-language iOS home screen for Give On Farm app at 375×812px. Safe state — no active disaster.

Design system: [공통 context 붙이기]

Layout (top to bottom):
- Status bar
- Top bar: "내 농장" title 17px/600/#1c1c1a left. Bell icon right (notification). No border.

- **DISASTER ALERT SECTION:**
  - If regional disaster (heat/cold/hail alert): Full-width banner, 4px radius, #fde8e8 background, 1px #e63946 left border (4px wide). "⚠️ 경기 포천 폭염 특보 발령 · 7월 15일 예정" 14px/600/#e63946. Tap routes to detailed forecast.
  - If no disaster: omit banner.

- **CURRENT WEATHER CARD:**
  - Title: "오늘의 날씨" 17px/600/#1c1c1a, 24px top margin
  - Card: 12px radius, white background, 1px #e0ddd8 border, 16px padding
  - Weather chips row (3 items, dividers): "현재 기온 22°C" / "습도 58%" / "내일 최고 25°C" — each 13px/#6b6862
  - Status: "안전" large green circle (80px, #52b788) + checkmark, centered, 12px top margin
  - AI message: "오늘은 위험 수준이 아닙니다. 쾌적한 하루 보내세요." 14px/400/#3d3d3a, 1.7 line-height, 12px top margin

- **UPCOMING FORECAST CARD (if 3+ days out shows risk):**
  - Appears only if predicted disaster exists (e.g., "금주 목요일 폭염 예상")
  - 12px radius, white, 1px #fde8e8 border, 16px padding
  - Header: "📅 예정된 재해" 13px/600/#e63946
  - Body: "7월 18일(목) 전후 폭염 주의보 예상. 미리 준비하세요." 14px/400/#3d3d3a, 1.6 line-height
  - Tap for detailed timeline

- Bottom navigation bar: white, 1px top #e0ddd8 border, 64px height. **3 tabs equally spaced:**
  - 홈 (active, #2d6a4f icon+label)
  - 🎁 작은 선물 (귀여운 이름, tap routes to ugly-produce/damage-report combined screen, #9b9792 inactive)
  - ⚙️ 설정 (#9b9792 inactive)
  - Labels 13px/600.

Mood: Calm, reassuring. Green safety + amber future-warning balance. No checklists. Focus on current + predictive info.
```

---

### Screen 4 — 홈 화면 (위험 상태)

```
Design a Korean-language iOS home screen for Give On Farm app at 375×812px. Danger state — active heat/cold/hail disaster.

Design system: [공통 context 붙이기]

Layout:
- Status bar
- Top bar: "내 농장" 17px/600/#1c1c1a left. Bell icon with red dot badge right.

- **RISK INDICATOR CARD (tappable, triggers voice on elderly mode):**
  - Full-width, 16px radius, #fde8e8 (urgency-light) background, 24px padding
  - Top: "오늘 위험도" label 13px/500/#6b6862
  - Center: Large circle 100px diameter, solid #e07a5f (risk-danger terracotta) fill, white warning triangle icon inside
  - Below circle: "위험" label 14px/700/uppercase/#e07a5f
  - Weather row: "현재 기온 34°C" in #e63946 bold, "습도 71%", "내일 최고 37°C" in #e63946 bold
  - AI guidance (Claude-generated, livestock-specific): "현재 34°C입니다. 닭 위험 수준 — 즉시 환풍기를 최대로 가동하고 음수 온도를 20°C 이하로 유지해 주세요." 14px/400/#1c1c1a, 1.7 line-height, 2-3 lines max
  - **NOTE: If user registered in elderly mode (Screen 0-AS), tapping this card plays AI guidance via TTS (speaker icon appears, tap to replay)**

- **QUICK ACTION BUTTONS (3 buttons stacked, 48px height, 16px gap, 24px margin):**
  - Button 1: "📞 수의사 연락하기" full pill, white fill, 1px #e07a5f border, #e07a5f text 16px/600. Routes to phone dialer pre-filled with local vet number (handled by backend).
  - Button 2: "📞 지자체 축산과 연락하기" full pill, white fill, 1px #e07a5f border, #e07a5f text 16px/600. Routes to dialer pre-filled with regional livestock dept.
  - Button 3: "⚠️ 피해 신고하기" full pill, #e63946 fill, white text 16px/600. Routes to Screen 7 (damage report form).

- Bottom nav bar (same as Screen 3: 홈 / 🎁 작은 선물 / ⚙️ 설정)

Mood: Urgent but not panic. Clear guidance tailored to livestock type. Direct action buttons. Voice option for elderly accessibility.
```

---

### Screen 5 — 홈 화면 (긴급 상태)

```
Design a Korean-language iOS home screen for Give On Farm app at 375×812px. Emergency state — extreme disaster.

Design system: [공통 context 붙이기]

IMPORTANT: This screen uses FULL DARK MODE override. Background: #1a2e1e (surface-dark). All text: #f0f0ec (on-dark). This is the only screen in the app with a dark background.

**AUTO-VOICE PLAYBACK ON SCREEN LOAD:** AI emergency message plays via TTS immediately when screen appears. E.g., "즉시 모든 환풍기를 최대로 가동하세요. 축사 온도를 지금 당장 확인하세요." Speaker icon visible; tap to replay.

Layout:
- Status bar (light content on dark background)
- Top bar on #1a2e1e: "내 농장" white. Bell icon white with red badge.

- **EMERGENCY ALERT SECTION (full-bleed, no padding):**
  - Center of upper half: Large pulsing circle — 120px diameter, #e63946 fill. CSS animation: "scale pulse 1.5s ease-in-out infinite between 1.0 and 1.08". White exclamation mark icon inside.
  - Below circle: "긴급" label 16px/700/uppercase/#e63946, letter-spacing 1px
  - Weather (large, urgent): "현재 기온 36°C" 32px/700/#e63946. "내일 최고 38°C 예보" 16px/#f0f0ec below.
  - Separator: 1px #2d6a4f line, 24px vertical margin
  - **AUTO-PLAYING AI MESSAGE (with speaker icon):** "즉시 모든 환풍기를 최대로 가동하세요. 지금 당장 축사 온도를 확인하세요." 16px/600/#f0f0ec, 1.6 line-height, max 2 lines. Speaker icon (🔊) top-right: tap to replay message.

- **EMERGENCY ACTION BUTTONS (three full-width buttons stacked, 56px height, 16px gap, 24px margin):**
  - Button 1: "🚒 119 신고하기" full pill, #ff6b6b (bright red, distinct from app green), white text 16px/600. Routes to phone dialer with "119" pre-filled.
  - Button 2: "⚠️ 피해 신고하기" full pill, transparent fill, 1px #f0f0ec border, #f0f0ec text 16px/600. Routes to Screen 7 (damage report form).
  - Button 3: "📞 지자체 축산지원실 연락" full pill, transparent fill, 1px #f0f0ec border, #f0f0ec text 16px/600. Routes to dialer pre-filled with regional livestock support emergency number.

- Bottom of screen: soft #2d6a4f bottom nav bar (stays brand-colored — navigation must remain accessible even in emergency)

Mood: Maximum urgency. Dark, serious, immediate. Farmer feels life-critical. Auto-voice ensures message reaches even panicked user. Direct emergency contact options (119, damage report, local support). No decorative elements.
```

---

### Screen 6A — 음성 등록 여부 확인

```
Design a Korean-language iOS screen for Give On Farm app at 375×812px. Voice mode selection for damage report flow.

Design system: [공통 context 붙이기]

Context: User enters damage report flow (⚠️ 피해신고 tab). Check if they registered via voice (Screen 0-AS). If yes: skip to Screen 6B. If no: show this prompt.

Layout:
- Status bar
- Navigation: back chevron left (routes to home), title "피해 신고" 17px/600 center
- Headline: "어떤 방식으로 등록하시겠어요?" 22px/700/#1c1c1a center, 48px top margin
- Subheading: "음성으로 말씀하면 AI가 정보를 입력합니다" 14px/400/#6b6862 center, 1.6 line-height
- Two buttons stacked, 56px height, 24px gap, full-width, 24px margin:
  - Top: "🎤 음성으로 등록" full pill, #2d6a4f fill, white text 16px/600. Routes to Screen 6B with voice input enabled.
  - Bottom: "⌨️ 직접 입력" full pill, white fill, 1px #2d6a4f border, #2d6a4f text 16px/600. Routes to Screen 6B with text input.

Tone: Lightweight, quick choice. No friction. Voice option prominent.
```

---

### Screen 6B — 피해신고 (재난 상황 + 피해 종류 + 규모)

```
Design a Korean-language iOS damage report screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Context: Main damage report form. User selects damage type (from their farm list), reports severity.

Layout:
- Status bar
- Navigation: back chevron left, "피해 신고" title 17px/600 center

- **DISASTER BANNER (top alert):**
  - If regional disaster active: full-width, 4px radius, #fde8e8 background, 1px #e63946 left border.
  - "⚡ 경북 청송 폭염 특보 발령 중" 14px/600/#e63946
  - Sub: "현재 위험도: 위험" 13px/#6b6862, 4px top margin
  - If no disaster: omit banner

- **DAMAGE TYPE SELECTION:**
  - Section title: "피해를 받은 것을 선택하세요" 17px/600/#1c1c1a, 24px top margin
  - Buttons row (scrollable if 3+, or grid):
    - For each item in user's farm list (from Screen 1): "닭 · 50,000마리" as selectable button pill, 48px height, full pill radius.
    - Selected: #2d6a4f fill + white text. Unselected: white fill, 1px #e0ddd8 border.
    - If only 1 item in farm list: auto-selected, grayed out (user can't change).
  - Helper text: "처음 등록하신 항목 중에서 선택합니다" 13px/#6b6862, 8px top margin

- **DAMAGE SCALE:**
  - Section title: "피해 규모" 17px/600/#1c1c1a, 24px top margin
  - Label: "폐사/손실 수량" 13px/500/#6b6862
  - Input field: full-width, 56px height, 8px radius, 1px #e0ddd8, placeholder "예: 5000" in #9b9792, number keyboard.
  - Right unit: "마리" or "평" (auto-determined by selected item), 14px/#6b6862
  - Helper: "대략적인 수치면 충분합니다" 13px/#6b6862, 8px top margin

- **OPTIONAL NOTES:**
  - Label: "피해 원인 (선택)" 13px/500/#6b6862, 24px top margin
  - Three buttons (wrap): "폭염 🌡️" / "한파 ❄️" / "우박 🌨️", 40px height, full pill.
  - Default: unselected (user can skip).

- Bottom CTA: "다음 — 사진 등록으로" full pill #2d6a4f, white text 16px/600, 48px height, full-width, 24px margin. Disabled until damage type + scale filled.

Tone: Direct, efficient. Disaster context shown. User's farm items reused. Simple quantities only.
```

---

### Screen 6C — 사진/동영상 등록

```
Design a Korean-language iOS media upload screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Context: After confirming damage details, user uploads photo/video evidence.

Layout:
- Status bar
- Navigation: back chevron left, "사진 등록" title 17px/600 center

- **CONFIRMATION PROMPT (top card, 12px radius, #d8f3dc background, 16px padding):**
  - "📸 사진을 등록하겠습니까?" 16px/600/#2d6a4f
  - Sub: "손상된 모습을 보여주시면 검증이 더 빠릅니다" 14px/400/#6b6862, 1.6 line-height

- **UPLOAD ZONE:**
  - Full-width, 240px height, 16px radius, #f2f0ed fill, 2px dashed #c4c0b8 border, centered content.
  - Icon: camera 48px in #9b9792
  - Label: "사진 또는 동영상 추가" 16px/600/#1c1c1a
  - Sub: "최대 5개, 각 100MB 이하" 13px/#6b6862
  - Tap zone: routes to native photo picker + video recorder

- **UPLOADED ITEMS LIST (appears as files added):**
  - Each item row (white card, 12px radius, 1px #e0ddd8, 60px height, 16px padding):
    - Left: thumbnail (56×56px, 8px radius)
    - Center: filename + "2.3MB" 13px/#6b6862
    - Right: "✕" delete button, #9b9792

- **TIP CARD (small, 12px radius, white, 1px #e0ddd8, 12px padding):**
  - "💡 팁: 손상된 모습이 명확하게 보이도록 찍어주세요. 자연 채광이 최고입니다" 13px/#6b6862

- Bottom: "다음 — 캠페인 생성 확인" or "건너뛰기" (two buttons, 48px, side by side if skip allowed, or single button if required)
  - Primary: "다음" full pill #2d6a4f
  - Secondary: "건너뛰기" outline, 1px #6b6862 border, #6b6862 text (optional if user can report without photos)

Tone: Casual, encouraging. Photos help but optional. No pressure.
```

---

### Screen 6D — 캠페인 생성 확인

```
Design a Korean-language iOS confirmation dialog for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Context: After damage + photos entered, ask user if they want AI to auto-generate campaign.

Layout:
- Status bar
- Modal dialog overlay (semi-transparent dark background #000 @ 40% opacity)
- Dialog card (centered, max-width 320px, 12px radius, white background, #1c1c1a text):
  - Title: "캠페인을 생성하시겠습니까?" 18px/700/#1c1c1a
  - Body: "AI가 자동으로 기부 캠페인을 만들어 드립니다. 관리자 검토 후 공개됩니다." 14px/400/#3d3d3a, 1.6 line-height, 12px top margin
  - Subtext: "(피해 신고만 하실 수도 있습니다)" 13px/#6b6862, 4px top margin

- **ACTION BUTTONS (two side by side, 48px height, 8px gap, 16px padding):**
  - Left: "예" full pill, #2d6a4f fill, white text 16px/600. Routes to Screen 6E (campaign mode).
  - Right: "아니요" outline pill, 1px #6b6862 border, #6b6862 text 16px/600. Routes to Screen 6E (report only mode).

Tone: Clear, simple. One yes/no choice. No hidden complexity.
```

---

### Screen 6E — 완료 안내

```
Design a Korean-language iOS confirmation screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Context: Damage report submitted. Notify user of next steps based on campaign decision.

Layout:
- Status bar
- Navigation: no back button (modal completion)
- Centered content (max 600px, 80px top padding):

- **SUCCESS ICON:**
  - Large checkmark circle: 96px diameter, #2d6a4f fill, white checkmark

- **HEADING (based on mode):**
  - Campaign mode: "캠페인 생성 신청이 완료되었습니다" 22px/700/#1c1c1a center
  - Report-only mode: "피해 신고가 완료되었습니다" 22px/700/#1c1c1a center

- **NEXT STEPS (body text):**
  - Campaign mode: "관리자가 피해를 확인 후 캠페인을 승인합니다. 승인되면 기부 스토리 작성을 요청해 드리겠습니다." 14px/400/#3d3d3a, 1.6 line-height, 24px top margin
  - Report-only mode: "관리자가 피해를 확인 후 연락 드리겠습니다. 예상 소요 시간: 1-2일" 14px/400/#3d3d3a, 1.6 line-height, 24px top margin

- **CTA BUTTON (single, 48px height, full-width, 24px margin, 32px top margin):**
  - "홈으로 돌아가기" full pill #2d6a4f, white text 16px/600. Routes to home (Screen 3).

Tone: Reassuring, warm. Process is clear. User knows what to expect next.
```

---

### Screen 7 — 캠페인 스토리 작성 (관리자 승인 후)

```
Design a Korean-language iOS campaign story creation screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Context: Admin has approved damage report. User now writes campaign story (or uses voice if registered via Screen 0-AS).

FLOW ENTRY POINT: 
- Push notification: "피해 신고가 승인되었습니다. 기부 캠페인 스토리를 작성해주세요."
- Tap → routes to Screen 7
- Or: 설정 탭에서 "승인 대기 중인 캠페인" 섹션에 버튼으로 표시

Layout:
- Status bar
- Navigation: back chevron (routes to home), "캠페인 스토리" title 17px/600 center

- **AI PREVIEW SECTION (collapsed initially):**
  - Toggle header: "🤖 AI 작성 미리보기" 14px/600/#2d6a4f (tap to expand)
  - Expanded content card (12px radius, #f2f0ed background, 16px padding):
    - Title: "이번 우박으로 30년 사과 농사에 흠집이 생겼습니다" 16px/600/#1c1c1a
    - Story (3 paragraphs): AI-generated narrative 14px/400/#3d3d3a, 1.6 line-height
    - "AI 스토리는 참고용입니다. 농장주님 말씀을 추가해주세요" 12px/#9b9792 italic

- **VOICE/TEXT INPUT (based on registration mode):**
  
  **IF VOICE MODE (Screen 0-AS registration):**
  - Large microphone icon (100px, centered, #2d6a4f, pulsing when listening)
  - Prompt: "농장주님의 이야기를 말씀해주세요" 18px/600/#1c1c1a center, 24px top margin
  - Sub-prompt: "예: 30년간 키워온 사과, 이번 우박으로..." 14px/#6b6862
  - Recognized text display (real-time): white card, 12px radius, 16px padding, 56px min-height, #f2f0ed
  - Action buttons: "✓ 다음 질문으로" / "🔄 다시 듣기" / "✎ 직접 입력"

  **IF TEXT MODE (⌨️ 직접 입력):**
  - Textarea, 160px height, 8px radius, 1px #e0ddd8, placeholder "농장주님의 이야기를 입력해주세요. 예: 30년 사과 농사, 자신의 노력, 이 우박이 미친 영향 등..." in #9b9792
  - Helper: "200자 이상 작성하시면 더 효과적입니다" 12px/#6b6862, 4px top margin
  - Character count: "0/500" right-aligned, 13px/#9b9792

- **FARMER PHOTO SECTION (optional):**
  - Label: "농장주님 사진 (선택)" 13px/500/#6b6862, 24px top margin
  - Upload button: "📷 사진 추가" outline pill, 1px #6b6862 border, #6b6862 text 14px/600, 40px height
  - If uploaded: thumbnail (80px, 12px radius) with delete ✕

- **FINAL PREVIEW (appears after all fields filled):**
  - Card (12px radius, white, 1px #2d6a4f border, 16px padding):
    - "📄 최종 확인" 14px/600/#2d6a4f
    - Full story preview (14px/400/#3d3d3a, 1.6 line-height)
    - Farmer name + date 13px/#6b6862

- **BOTTOM ACTION:**
  - "동의하고 전송" full pill #2d6a4f, white text 16px/600, 56px height, full-width, 24px margin
  - Sub-text: "이 내용이 기부 캠페인에 공개됩니다" 12px/#6b6862 center, 8px top margin

Tone: Collaborative, warm. AI preview helps but farmer's voice is primary. Voice option for elderly. Final review ensures confidence.
```

---

### Screen 7 — 피해 신고

```
Design a Korean-language iOS damage report screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Layout:
- Status bar
- Navigation: back chevron, "피해 신고" title center
- Warning banner: full-width, 8px radius, #fde8e8 background, "⚠️ 피해 신고 후 AI가 기부 캠페인을 자동으로 만들어 드립니다. 농장주님의 동의 후 공개됩니다." 13px/#e63946. 
- Section: "피해 규모" label 17px/600/#1c1c1a
- Dead count input: label "폐사 두수" 13px/500/#6b6862. Input field 56px height, 8px radius, 1px #e0ddd8, number keyboard type. Right unit: "마리". 
- Cause selector: label "피해 원인" 13px/500/#6b6862. Three large selection cards in a row — "폭염 🌡️" / "한파 ❄️" / "우박 🌨️". Each: flex-grow, 80px height, 12px radius, center icon+label. Selected: 2px #e63946 border + #fde8e8 background.
- Estimated loss: label "예상 피해액 (선택)" + input field with "만원" unit suffix.
- Farmer note: label "농장주님 한마디 (선택)" 13px/500/#6b6862. Multiline textarea, 120px height, 8px radius, 1px #e0ddd8. Placeholder: "30년간 키워온 닭들을 잃어서 너무 힘드네요..." 14px/#9b9792.
- AI preview hint: "등록 후 AI가 기부 스토리를 자동으로 작성합니다." 13px/#2d6a4f, Earth Green — positive framing.
- Bottom: "AI 스토리 생성 후 공개 동의하기" full-pill #2d6a4f CTA, 48px, full-width.

Mood: Empathetic, dignified. The farmer is in distress — no bright colors, no playful elements. Earth Green for forward action, off-white canvas, clean layout.
```

---

## iOS 탭 구성 (현재 3개)

```
Primary Navigation: Bottom tab bar (64px height, white background, 1px top #e0ddd8 border).

**ACTIVE TABS (required):**

1. 🏠 홈 (Home)
   - Routes to Screen 3/4/5 (safe/danger/emergency states)
   - Displays current weather, disaster alerts, predictive forecasts
   - Current icon + label active state: #2d6a4f

2. ⚠️ 피해신고 (Damage Report)
   - Unified flow for damage report + campaign generation
   - Routes to Screen 6A (voice mode check) → 6B (damage form) → 6C (photo) → 6D (campaign confirm)

3. ⚙️ 설정 (Settings)
   - User profile, farm info edit, notification preferences
   - Push notification toggles by alert type
   - Voice mode toggle (if registered via Screen 0-AS)
   - Logout

**RECOMMENDED FUTURE ADDITIONS (not in initial MVP):**

4. 📊 통계 (Stats / My Impact)
   - Monthly/yearly donation summary
   - CO₂ reduction dashboard
   - Reward history, shipping status
   - Recommended if users want engagement/gamification

5. 💬 소식 (News / Regional Alerts)
   - Regional disaster alerts feed
   - Platform announcements
   - Seasonal farming tips
   - Recommended if push notification click-through is high

6. 👥 커뮤니티 (Community)
   - Farm-to-farm knowledge sharing
   - Seasonal best practices by region
   - Recommended for farmer engagement/retention

**Tab Appearance:**
- All inactive tabs: #9b9792 (muted) icon + label, 13px/600
- All active tabs: #2d6a4f (earth green) icon + label, 13px/600
- Tab spacing: equal distribution across 4 safe-area width
```

---

## 웹 화면 (8개)

---

### Screen 8 — 메인 화면 (재난 없음)

```
Design a Korean-language desktop web homepage for Give On at 1440px width.

Design system: [공통 context 붙이기]

Layout sections top to bottom:

TOP NAV (72px height, #fafaf8 background, 1px bottom #e0ddd8):
- Left: Give On logotype in #2d6a4f, 20px/700
- Center: filter tabs — "전체" (active, 2px bottom #2d6a4f underline) / "폭염·가뭄" / "한파" / "우박" — each 16px/500/#1c1c1a, 16px gap
- Right: "내 기부 내역" 14px/#2d6a4f link + avatar circle 36px

HERO SECTION (80px vertical padding, #fafaf8):
- Left ~55%: Headline "기후 재난이 만든 흠집 사과, 함께 구해요" 32px/700/#1c1c1a, line-height 1.3. Sub: "손상된 농산물이 폐기되지 않도록, 기부로 농가를 돕고 못난이 농산물을 직접 받아보세요." 18px/400/#3d3d3a, 1.7 line-height. Below: "지금 캠페인 보기" pill CTA #2d6a4f, 48px height + "농가 등록하기" secondary outlined pill.
- Right ~45%: A realistic photo of a hail-scarred apple (whole apple, visible dents) on a wooden surface. 16px radius. No filter. Caption below: "경북 청송 · 우박 피해 사과" 13px/#6b6862.

CAMPAIGN GRID (64px top padding):
- Section header: "지금 도움이 필요한 농가" 26px/700/#1c1c1a left + "전체보기 →" 14px/#2d6a4f right
- 3-column grid, 24px gap. Each campaign card (see campaign card spec below):
  Card 1 (urgent): Harvest Red 2px top border. Badge "긴급". Hail apple photo.
  Card 2 (active): Earth Green badge "진행중". Damaged potato photo.
  Card 3 (active): Earth Green badge "진행중". Sunburned pepper photo.
- Campaign card structure (12px radius, 1px #e0ddd8 border, white background):
  - Photo: 4:3 aspect ratio, 16px radius top corners only. Floating badge top-left. Heart icon top-right.
  - Meta block 16px padding: Title 18px/600/#1c1c1a (2 lines max). Region+cause+remaining "경북 청송 · 우박 · 사과 200kg 남음" 14px/#6b6862. Progress bar: thin 4px height, #e0ddd8 track, #2d6a4f fill, 12px radius. Below bar: "63% 달성 · 127명 참여" 13px/#6b6862. Price: "3만원 → 사과 2kg 박스 직배송" 14px/600/#1c1c1a.

HOW IT WORKS (80px padding, #f2f0ed background):
- Section title "이렇게 작동해요" 26px/700 center
- 3-step horizontal flow with arrows:
  Step 1: Cloud+lightning icon. "기상청 데이터 감지". Sub: "AI가 재난을 실시간으로 감지합니다"
  Step 2: Phone icon. "농가에 등록 알림". Sub: "손상 작물 등록 유도 푸시 발송"
  Step 3: Box icon. "기부 → 농산물 직배송". Sub: "흠집 있지만 맛은 그대로"
- Steps in Earth Green icon color, 14px/400/#6b6862 sub-text.

FOOTER (#e8e5e0 background, 3-column link grid, Earth Green logo, CO₂ impact counter "지금까지 총 823톤 CO₂ 절감에 기여했습니다" in 22px/700/#2d6a4f).

Overall mood: Warm, trustworthy, purposeful. Photography leads. No stock-photo farmers — real imperfect produce only.
```

---

### Screen 8 — 메인 화면 (재난 진행 중)

```
Design a Korean-language desktop web homepage for Give On at 1440px width. Active disaster state.

Design system: [공통 context 붙이기]

IDENTICAL to Screen 7 EXCEPT add these elements:

DISASTER BANNER (above top nav, full-width, 44px height):
- Background: #1a2e1e (surface-dark)
- Left: pulsing red dot (8px circle, #e63946, CSS pulse animation) + "경북 청송 폭염 특보 발령 중" 14px/600/#f0f0ec
- Right: "지금 기부하기 →" 14px/600/#e63946 link
- Full-width, no radius

TOP CAMPAIGN ROW change:
- First 2 cards: use campaign-card-urgent variant — 2px Harvest Red top border, #fde8e8 tint behind meta block, "긴급" badge in Harvest Red pill.

HERO change:
- Headline: "지금 경북 청송에 폭염 특보가 발령됐습니다" 32px/700/#1c1c1a
- Sub: "AI가 피해 농가를 찾아 기부 캠페인을 자동으로 열었습니다. 5분 전."
- Primary CTA color stays #2d6a4f (Earth Green) — urgency banner is Harvest Red, but the donation action itself is positive/green.
```

---

### Screen 15 — 캠페인 상세 (못난이 농산물)

```
Design a Korean-language desktop web campaign detail page for Give On at 1440px width.

Design system: [공통 context 붙이기]

This page is for an ugly produce campaign: hail-damaged apples from a 30-year farm in Gyeongbuk Cheongsong.

TOP NAV: same as main page.

HERO PHOTO (full-width below nav, 500px height):
- A 16:9 realistic photo of hail-scarred apples spread on a wooden crate, outdoors in a Korean apple orchard. Visible dents and surface marks. Good natural light.
- Caption overlay bottom-left on a semi-transparent #1a2e1e band (40px height): "김철수 농부 · 경북 청송 · 30년 농장" 13px/#f0f0ec

CONTENT AREA (1080px max-width, centered, 48px top padding):
LEFT COLUMN (~60%):

Campaign badge row: "우박 피해" dark pill + "AI 자동 생성 캠페인" outlined pill + "긴급" #e63946 pill. All 11px/700 uppercase.

Title: "이번 우박으로 30년 사과 농사에 가장 큰 흠집이 생겼습니다" 26px/700/#1c1c1a, line-height 1.35.

Story body: 3 paragraphs, 16px/400/#3d3d3a, 1.7 line-height:
P1: "경북 청송에서 30년째 사과를 키우고 있는 김철수 농부입니다. 지난 주 우박으로 올해 수확한 사과의 40%에 흠집이 생겼습니다."
P2: "외형은 달라졌지만 당도는 오히려 더 높습니다. 찬 서리를 맞은 사과가 더 달듯이, 스트레스를 받은 과일은 당분을 더 많이 만들어냅니다."
P3: "이 사과들이 폐기되지 않도록 함께해 주세요."

Climate Score Timeline section:
- Section title "이 농장의 기후 여정" 18px/600
- Horizontal timeline (full-width, 80px height):
  Node 1: red circle "우박 발생" label above, "7월 15일" below
  Connecting line →
  Node 2: orange circle "캠페인 시작"
  →
  Node 3: amber circle "127명 참여" 
  →
  Node 4: green circle (current, slightly larger, checkmark inside) "복구 중"
  Colors use risk-level tokens. Labels: 13px/#6b6862 caption above node, 12px/#9b9792 date below.

Produce photo gallery: 4 thumbnail photos (1:1, 80px, 12px radius) showing the hail-damaged apples from different angles. No filters.

RIGHT COLUMN (~36%, sticky):

Donation panel card (12px radius, 1px #e0ddd8 border, card-float shadow, 24px padding):
- "기부 금액 선택" section label 13px/500/#6b6862
- Three amount pills in a row: "1만원" / "3만원" (active: #2d6a4f fill, white text) / "5만원". Plus free input field below.
- Reward preview: small apple thumbnail (48px, 12px radius) left + "사과 2kg 박스 직배송" 14px/600/#1c1c1a + "농부 감사 사진 포함" 13px/#6b6862. Background: #d8f3dc light green tint.
- "기부하기" full-pill #2d6a4f button, full-width, 56px height, "기부하기" 16px/600 white.
- "카카오페이로 간편결제" 13px/#6b6862 center, 8px below button.
- Divider 1px #e0ddd8.
- Reward detail: "3만원 기부 시 받는 것:" header 13px/600. List: "✓ 경북 청송 사과 2kg 박스 직배송" / "✓ 농부 감사 사진 알림" / "✓ 기후 성적표 업데이트" in 13px/#3d3d3a.
- Impact preview: "예상 CO₂ 절감: 0.4톤" 13px/#0077b6 (CO2 teal).
```

---

### Screen 15 — 기부 완료 화면

```
Design a Korean-language desktop web donation completion page for Give On at 1440px width. Full-screen confirmation state.

Design system: [공통 context 붙이기]

This is a celebratory, emotionally warm confirmation screen. Center-aligned content, minimal nav.

Layout:
TOP NAV: simplified — just Give On logo left, no navigation links.

MAIN CONTENT (centered, max 600px width, 80px top padding):

Success animation area (center):
- Large checkmark circle: 96px diameter, #2d6a4f fill, white checkmark. (Describe as "completion animation — circle draws in, then checkmark appears")

Confirmation text:
- "청송 사과 2kg 박스가 배송될 예정입니다 🍎" 26px/700/#1c1c1a, center, line-height 1.35
- "김철수 농부님의 흠집 사과가 A님의 식탁으로 갑니다." 16px/400/#3d3d3a center

Delivery timeline chips (horizontal, center-aligned):
Three small rounded chips connected by dashed lines:
"기부 완료 ✓" (filled #2d6a4f) → "배송 준비 중" (#e0ddd8) → "배송 예정 D+3" (#e0ddd8)
Each chip: 32px height, full pill radius, 13px/500.

Impact preview card (full 600px width, 12px radius, #d8f3dc background, 24px padding):
- "이번 기부의 예상 임팩트" 14px/600/#2d6a4f header
- Three stat columns with thin #e0ddd8 dividers:
  "200kg" / "구제 농산물" in #2d6a4f 24px/700 + 13px/#6b6862
  "127명" / "함께한 이웃" in #1c1c1a 24px/700
  "0.4톤" / "CO₂ 절감 기여" in #0077b6 24px/700
- Sub note: "상세 리포트는 배송 완료 후 14일 뒤에 도착합니다." 13px/#6b6862

SNS share row:
- "내 기부 공유하기" 14px/600/#1c1c1a center, 24px top margin
- Two share buttons: "카카오톡 공유" (yellow fill) + "링크 복사" (outline). Both full-pill, 40px height, 14px/500.
- Below: small generated share preview text "나는 이번 우박 피해 사과를 구했어요 🍎 #GiveOn" in 13px/#6b6862.

Secondary CTA: "다른 농가 돕기 →" 14px/600/#2d6a4f text button, center.

Mood: Warm celebration, not flashy. The confirmation is quiet and dignified — matching the platform's seriousness about climate issues. No confetti. Earth Green checkmark is the visual peak.
```

---

### Screen 15 — 농부 감사 사진 알림

```
Design a Korean-language desktop web notification page for Give On at 1440px width.

Design system: [공통 context 붙이기]

This shows the notification center / activity feed page, with a gratitude photo notification as the featured item.

TOP NAV: same as main. Bell icon active (red dot).

PAGE HEADER (32px padding):
"알림" 26px/700/#1c1c1a. Tab row below: "전체" (active, #2d6a4f underline) / "기부 알림" / "배송 알림". 16px/500.

NOTIFICATION LIST (max 720px centered):

FEATURED gratitude photo notification (first item, prominent):
Card: 12px radius, 1px #2d6a4f border (Earth Green — positive news), #d8f3dc light green background, 24px padding.
Layout: Left side photo (100×100px, 12px radius, real hail apple farm photo). Right side:
- "🌱 농부님의 감사 인사가 도착했어요" 14px/600/#2d6a4f header
- "김철수 농부 · 경북 청송 · 5분 전" 13px/#6b6862
- Farmer message: "도움을 주셔서 정말 감사합니다. 흠집 사과지만 달콤하게 잘 자랐어요. 덕분에 한 상자도 버리지 않고 보낼 수 있게 됐습니다. — 김철수" 14px/400/#3d3d3a, 1.7 line-height, italic style for the quote.
- Below message: "사진 보기" #2d6a4f text link + "내 기부 현황" #2d6a4f text link.

Regular notification items below (standard, 16px/400/#1c1c1a, 1px bottom #e0ddd8 divider, 20px padding):
- "📦 배송이 시작되었습니다 — 청송 사과 2kg · CJ대한통운 · 1234567" 13 minutes ago
- "🌡️ 경북 청송 지역에 폭염 주의보가 발령되었습니다. 지난번 기부하신 농가가 걱정되시나요?" — 3 hours ago (with "기부 현황 보기 →" link)

Also show: Mobile push notification preview at top-right of screen (as a design aside/annotation). iOS notification banner style: app icon left, "Give On" title, "김철수 농부님의 감사 사진이 도착했어요 🍎" body, "방금" timestamp. White background, 12px radius, card shadow.

Mood: Positive, warm. The green border and background of the featured notification signal "good news." This is the emotional payoff moment of the donation journey.
```

---

### Screen 15 — 임팩트 리포트

```
Design a Korean-language desktop web personal impact report page for Give On at 1440px width.

Design system: [공통 context 붙이기]

Page: Personal impact report sent 14 days after donation. URL: /impact/[donation-id]

TOP NAV: simplified (logo only + "내 기부 내역" right link).

HERO SECTION (80px padding, #fafaf8):
- Small Give On logo + "A님을 위한 임팩트 리포트" 13px/500/#6b6862, center
- Headline: "A님의 3만원이 만든 변화" 32px/700/#1c1c1a center
- Sub: "기부 완료 14일 후 · 경북 청송 사과 농가" 14px/#6b6862 center

IMPACT NUMBERS BLOCK (full-width, centered, 64px padding):
3 columns with thin #e0ddd8 dividers:
- "2kg" 48px/700/#2d6a4f / "구제한 사과" 14px/#6b6862
- "0.4톤" 48px/700/#0077b6 / "CO₂ 절감 기여" 14px/#6b6862  
- "127명" 48px/700/#1c1c1a / "함께한 이웃" 14px/#6b6862
Background: white card, 12px radius, card-float shadow, max 800px centered.

CLIMATE SCORE SECTION (#f2f0ed background, 64px padding):
- "이 농장의 회복 여정" 22px/600/#1c1c1a center
- Full-width horizontal timeline (max 900px):
  4 nodes: 🔴긴급→🟠위험→🟡주의→🟢안전
  Large nodes (24px), colored circles per risk level. Labels above+below.
  Current state: "안전" with large checkmark, slightly enlarged node.
- Below timeline: "복구 완료까지 17일 걸렸습니다. 함께해 주셔서 감사합니다." 16px/400/#3d3d3a center.

GRATITUDE PHOTO SECTION (64px padding):
- "농부님의 감사 인사" 22px/600/#1c1c1a
- Full-width photo (16:9, 16px radius) — the farmer's thank-you photo of the apple orchard after recovery.
- Below photo: farmer quote in a white card, 12px radius, 1px #2d6a4f left border 4px. Quote 16px/400/#3d3d3a italic. Attribution: "— 김철수 농부, 경북 청송" 13px/600/#6b6862.

SHARE SECTION (64px padding, #fafaf8):
- "기후 여정 카드 받기" 22px/600 center
- Preview of the year-end card (400px wide, dark green card, white text, impact numbers) — as a thumbnail.
- "2026 기후 여정 카드 미리보기" caption 13px/#6b6862
- "카드 공유하기" Earth Green pill CTA + "SNS에 공유하기" secondary.

Mood: Reflective, grateful, data-driven but warm. The numbers prove impact; the photo provides emotional closure; the timeline makes the journey tangible.
```

---

### Screen 15 — 기후 여정 카드 (연말 공유용)

```
Design a shareable year-end climate journey card for Give On. Format: 1080×1080px (Instagram square). This is a standalone graphic, not a web page.

Design system: [공통 context 붙이기]

Canvas: #1a2e1e (surface-dark). This is the ONLY screen where the dark background is used on web/social.

Subtle background texture: very faint radial gradient from center — #1a2e1e center to #0f1e12 edges (5% difference only, nearly imperceptible). No bold gradients.

LAYOUT (centered content, 80px padding all sides):

TOP: Give On wordmark (white logotype) top-left. "2026 기후 여정 카드" top-right in 13px/500/#52b788 (risk-safe green).

MIDDLE (centered, dominant):
- "A님의 2026" 18px/500/#f0f0ec
- "기후 여정" 48px/700/#f0f0ec, letter-spacing -1px, line-height 1.1

4 impact stat rows, each spanning full content width, separated by thin #2d6a4f hairlines:
Row 1: "총 기부" left label 14px/#9b9792 + "9만원" right 32px/700/#f0f0ec
Row 2: "못난이 박스" left + "3개" right 32px/700/#52b788 (green — positive environmental)
Row 3: "함께한 농가" left + "3곳" right 32px/700/#f0f0ec
Row 4: "CO₂ 절감 기여" left + "0.9톤" right 32px/700/#0077b6 (CO2 teal)

BOTTOM:
- Thin #2d6a4f hairline separator
- "폭염 · 우박 · 가뭄을 함께 극복했습니다" 14px/400/#9b9792 center
- Three tiny risk indicator dots in a row: 🔴🟡🟢 — representing the disaster-to-recovery journey
- Give On wordmark bottom-right, small 14px, #52b788.

Overall mood: Dark, serious, proud. Like a personal achievement trophy for environmental action. Not celebratory or playful — dignified and intentional. This should look good as an Instagram story when shared.
```

---

## 관리자 화면 (3개)

---

### Screen 15 — 관리자 대시보드

```
Design a Korean-language Admin PWA dashboard for Give On at 1440px width. This is an internal operations tool.

Design system: [공통 context 붙이기]

LAYOUT: Left sidebar (240px, #f2f0ed background, 1px right #e0ddd8) + main content area.

LEFT SIDEBAR:
- Give On logo + "관리자" badge (small #2d6a4f pill label)
- Nav links (16px/500, 48px row height, 1px bottom #e0ddd8, 16px left padding):
  🗺️ 대시보드 (active — #d8f3dc background, #2d6a4f text, 4px left #2d6a4f bar)
  ⚠️ 캠페인 승인 (with red badge "3" — pending count)
  🚚 배송 관리
  🌾 농가 관리
  📊 통계 (separate stats page — not in main dashboard)
- Bottom: user avatar + name + "로그아웃" in small text

MAIN CONTENT (full-width below sidebar):

---

SECTION 1: WEATHER & DISASTER SUMMARY (top, 2-column 50/50, 16px gap, 24px padding, white cards, 12px radius, 1px #e0ddd8)

LEFT CARD: "지역 재난 현황"
- If active disaster: Full-width alert banner, #fde8e8 background, 1px #e63946 left border 4px width.
  - Title: "⚠️ 경기 포천 폭염 특보 발령 중" 16px/600/#e63946
  - Sub: "전국 위험 농가: 23곳 | 신규 피해신고: 3건" 14px/#6b6862, 4px top margin
  - Action link: "실시간 현황 보기 →" 13px/#2d6a4f right-aligned
- If no active disaster: Green safe state card
  - "🟢 전국 기상 안정" 16px/600/#52b788
  - "위험 농가: 2곳 (전일 대비 ↓8)" 14px/#6b6862

RIGHT CARD: "향후 7일 재해 예상"
- Section title: "예측 재해" 14px/600/#1c1c1a
- List rows (each 13px/#3d3d3a, 1px bottom #e0ddd8):
  "7월 22일(화) 경기·강원 폭염 예상"
  "7월 25일(금) 전국 우박 가능성"
  "7월 28일(월) 강원 한파"
- If no predictions: "향후 7일 안정적인 기상 예상" 13px/#52b788

---

SECTION 2: MAIN OPERATIONS AREA (two columns 60%/40%, 16px gap, 24px padding)

LEFT COLUMN (60%):

**SUBSECTION 2-1: Risk Map (12px radius white card, 1px #e0ddd8, 320px height min)**
- Label row: "전국 위험 현황" 18px/600/#1c1c1a + "실시간" small green blinking dot 8px
- Filter pills row: "전체" (active #2d6a4f) / "긴급" / "위험" / "주의" / "안전" — each 13px/500, light pill background
- 카카오맵 placeholder (full-width minus padding, 280px height, #f2f0ed background). 
- On map: colored farm markers — red (긴급), orange (위험), amber (주의), green (안전). Legend bottom-left: small color squares + count labels.

**SUBSECTION 2-2: Damage Report Status (12px radius white card, 1px #e0ddd8, 16px padding, 12px gap below map)**
- Label: "피해신고 현황" 18px/600/#1c1c1a
- 3-stat row (equal width, thin #e0ddd8 dividers):
  - "오늘 신규" 13px/#6b6862 / "3건" 24px/700/#e63946
  - "대기 중" 13px/#6b6862 / "7건" 24px/700/#f4a261 (amber)
  - "이번주 완료" 13px/#6b6862 / "24건" 24px/700/#2d6a4f
- Mini table below (white, 12px radius, 1px #e0ddd8, 16px padding):
  - Header row: "농가명" / "축종" / "피해규모" / "상태" — each 13px/500/#6b6862, 1px bottom #e0ddd8
  - Data rows (max 4 visible): 
    "김철수" / "닭" / "5,000마리" / "승인 대기" (amber pill)
    "박영희" / "사과" / "2톤" / "진행 중" (green pill)
    "이준호" / "포도" / "1톤" / "완료" (dark pill)
  - Small pagination: "1–4 / 14건" 12px/#9b9792 right

RIGHT COLUMN (40%):

**SUBSECTION 3-1: Campaign Approval Queue (12px radius white card, 1px #e0ddd8, 16px padding)**
- Label: "승인 대기 캠페인" 18px/600/#1c1c1a + "3건" #e63946 count badge
- List of pending campaigns (each row: white card, 12px radius, 1px #e0ddd8, 16px padding, 12px gap):
  Row structure:
  - Campaign type pill (우박/폭염 etc, #1c1c1a dark background, white text, 11px/700)
  - Region "경북 청송" 14px/600/#1c1c1a + urgency "긴급도 8점" #e63946 outlined pill 11px/700
  - Story excerpt 13px/#6b6862 2-line max ("이번 우박으로 30년 사과 농사에...")
  - Action row: "승인" full pill #2d6a4f 28px + "반려" outline #e63946 28px (side by side)

**SUBSECTION 3-2: Campaign Progress (12px radius white card, 1px #e0ddd8, 16px padding, 12px gap below queue)**
- Label: "캠페인 진행상황" 18px/600/#1c1c1a
- 3-stat row (thin #e0ddd8 dividers):
  - "모금 중" 13px/#6b6862 / "12개" 24px/700/#2d6a4f + mini bar chart (3 bars: 0–25% / 50–75% / 90%) below
  - "배송 준비" 13px/#6b6862 / "5개" 24px/700/#f4a261
  - "이번달 완료" 13px/#6b6862 / "18개" 24px/700/#52b788
- Below: "Top 진행 중 캠페인" 13px/600/#1c1c1a header + list (max 2):
  - "경북 청송 우박 사과" — "63% 달성 · 127명" 12px/#6b6862

---

Mood: Functional, information-dense, operational. Real-time ops focus (maps + active queues). Clean 2-column split balances geographic (left) + administrative (right) workflows. Color system matches citizen-facing: Earth Green = approve/positive, Harvest Red = urgent/action required.
```

---

### Screen 16 — 캠페인 승인 상세

```
Design a Korean-language Admin campaign approval detail screen for Give On at 1440px width.

Design system: [공통 context 붙이기]

Context: Admin is reviewing an AI-auto-generated ugly produce campaign before approving it for public launch.

TOP NAV: Admin nav bar with breadcrumb "대시보드 > 캠페인 승인 > #4721" 13px/#6b6862.

PAGE LAYOUT (max 1080px centered, 2-column):

LEFT COLUMN (60%): Campaign Preview

Section label "AI 생성 캠페인 미리보기" 18px/600 + "자동 생성됨" small outlined pill.

Preview card (simulates how the campaign card looks to citizens): mini version of campaign-card at 360px width — produce photo, title, meta, progress bar, donation button. Label above: "시민에게 보이는 모습".

Story preview:
- Title: "이번 우박으로 30년 사과 농사에 가장 큰 흠집이 생겼습니다" 22px/600/#1c1c1a
- Body: full Claude-generated story text, 3 paragraphs, 16px/400/#3d3d3a, 1.7 line-height.
- Edit pencil icon top-right of story block — admin can edit Claude's draft.

Produce photos: 4 photos in a row (1:1, 80px, 12px radius) uploaded by farmer.

RIGHT COLUMN (36%): Approval Panel

Urgency score card (#fde8e8 background, 12px radius, 24px padding):
- "긴급도 점수" 13px/500/#6b6862
- "8점" 32px/700/#e63946 center
- Score breakdown list: "기상 위험도 3점 / 농가 규모 2점 / 작물 손상 2점 / 재난 특보 1점" each 13px/#3d3d3a with thin dividers.
- "7점 이상 — 자동 공개 조건" note 12px/#6b6862. "이 캠페인은 점수 조건을 충족하나 수동 검토 대기 중입니다." note.

Farm info card (white, 12px radius, 1px #e0ddd8, 16px padding):
- Farm name + owner + region + registered date + subscription tier.

Action section:
- "승인 시 즉시 공개됩니다" note 13px/#6b6862
- "승인" button — full-width, Earth Green fill, 48px pill, "승인하여 공개하기" 16px/600 white
- "반려" button — full-width, outlined #e63946, "반려" 16px/600 #e63946, 48px pill, 8px top margin
- "보류" text link — "일단 보류하기" #6b6862 tertiary, center.

Mood: Efficient, clear. Admin needs to make a quick yes/no decision. Score card is prominent. The preview shows exactly what citizens will see.
```

---

### Screen 18 — 통계 페이지

```
Design a Korean-language Admin statistics dashboard for Give On at 1440px width. Operational insights page.

Design system: [공통 context 붙이기]

LAYOUT: Left sidebar (240px, #f2f0ed background, 1px right #e0ddd8) + main content area.

LEFT SIDEBAR: (동일 — 📊 통계 활성)
- Give On logo + "관리자" badge
- Nav links: 🗺️ 대시보드 / ⚠️ 캠페인 승인 / 🚚 배송 관리 / 🌾 농가 관리 / 📊 통계 (active — #d8f3dc background, #2d6a4f text, 4px left bar)
- Bottom: user avatar + logout

MAIN CONTENT:

---

SECTION 1: KPI CARDS (상단, 24px padding, 5-card row, 16px gap, white background, 12px radius, 1px #e0ddd8)

Card 1: "총 등록 농가"
- "342" 28px/700/#1c1c1a
- "↑12 이번달" 12px/#6b6862

Card 2: "취약 농가 (위험도 3~4)"
- "28" 28px/700/#e63946 (red urgency)
- "↑3 어제 대비" 12px/#6b6862

Card 3: "총 피해신고"
- "156" 28px/700/#1c1c1a
- "최근 30일" 12px/#6b6862

Card 4: "활성 캠페인"
- "12" 28px/700/#2d6a4f
- "총 기부액 12.8백만원" 12px/#6b6862


---

SECTION 2: VULNERABLE FARMS & DAMAGE REPORTS (two columns 50/50, 16px gap, 24px padding)

LEFT COLUMN: "취약 농가 현황" (12px radius white card, 1px #e0ddd8, 16px padding)

Sub-label: "위험도 3~4 농가 | 기상 위험 + 용수 부족 농가" 12px/#6b6862

Segmented tabs (13px/500): "위험도 기준" (active #2d6a4f) / "기상 기준" / "용수 부족"

Table (scrollable, 400px max-height):
- Header row: "농가명" / "축종" / "지역" / "위험도" / "상태" — 13px/500/#6b6862, 1px bottom #e0ddd8
- Data rows (each 13px/#3d3d3a):
  "김철수" / "닭" / "경기 포천" / "4점 긴급" (red pill #e63946) / "모니터링" 
  "박영희" / "돼지" / "충남 천안" / "3점 위험" (orange pill #e07a5f) / "피해신고 대기"
  "이준호" / "축우" / "강원 홍천" / "3점 위험" / "안전"
- Pagination: "1–3 / 28건" 12px/#9b9792 right
- Action: "📊 위험도 분석 →" link 13px/#2d6a4f bottom-right

RIGHT COLUMN: "피해신고 현황 (최근 30일)" (12px radius white card, 1px #e0ddd8, 16px padding)

3-status Kanban strip (tall, showing state flow):
Column 1: "접수" 18px/600/#1c1c1a
- Count: "23건" 24px/700/#9b9792 (muted — new)
- Mini list (3 rows, 12px/#6b6862):
  "닭 5,000마리 · 경기"
  "사과 2톤 · 경북"
  "돼지 500마리 · 충남"
- "모두 보기" link 12px/#2d6a4f

Column 2: "진행 중" 18px/600/#1c1c1a
- Count: "7건" 24px/700/#f4a261 (amber)
- Mini list (3 rows):
  "검증 중 · 내일 완료"
  "기부자 매칭 중 · 2일"
  "캠페인 생성 중 · 진행"

Column 3: "완료" 18px/600/#1c1c1a
- Count: "42건" 24px/700/#2d6a4f (green)
- Sub-stat: "캠페인 생성: 38건 / 신고만: 4건" 12px/#6b6862

Bottom: Timeline chart (thin, 200px height):
- X-axis: 일자 (7일 - 오늘)
- Y-axis: 신청 건수
- Line graph: blue line (trend), showing daily intake over last week. Area under line: light blue fill.
- Tooltip on hover: "7월 15일: 3건" style.

---

SECTION 3: CAMPAIGN & DISTRIBUTION STATS (two columns 50/50, 16px gap, 24px padding)

LEFT COLUMN: "캠페인 현황" (12px radius white card, 1px #e0ddd8, 16px padding)

3-status Kanban (same layout as damage reports, but campaign-specific):

Column 1: "접수" 18px/600/#1c1c1a
- Count: "5건" 24px/700/#9b9792
- List: 우박 사과 / 폭염 가지 / 한파 배추 등

Column 2: "승인 대기" 18px/600/#1c1c1a
- Count: "2건" 24px/700/#f4a261
- List with urgency: 
  "우박 사과 · 긴급도 8점" #e63946
  "폭염 포도 · 긴급도 6점"

Column 3: "공개 중" 18px/600/#1c1c1a
- Count: "12건" 24px/700/#2d6a4f
- Sub-stat: "모금 중: 12건 / 완료: 38건 (누적)" 12px/#6b6862

Bottom section: "캠페인별 성과" header 13px/600
- Mini table (3 rows, compact):
  "경북 청송 우박 사과" / "127명 참여" / "3.2백만원" / "63% 달성" (progress bar)
  "충남 폭염 가지" / "84명" / "1.8백만원" / "90%"
  "전북 우박 딸기" / "156명" / "4.1백만원" / "100% 완료" (green)

RIGHT COLUMN: 추가 분석 차트들 (3 sub-cards, stacked, 12px gap)

**Chart 1: "축종별 피해신고" (12px radius white card, 1px #e0ddd8, 16px padding, 200px height)**
- Horizontal bar chart:
  "닭" 80 (bar) — 51건
  "돼지" 45 — 29건
  "소" 20 — 13건
  "기타" 11 — 7건
- Y-label: 축종명 13px/#6b6862 / X-value: 건수 13px/#1c1c1a

**Chart 2: "지역별 분포" (12px radius white card, 1px #e0ddd8, 16px padding, 200px height)**
- Pie chart (180px diameter):
  Slices: 경기(35%, #2d6a4f) / 경북(28%, #52b788) / 충남(18%, #f4a261) / 기타(19%, #9b9792)
- Legend below: color square + region name + "35%" 12px/#6b6862

**Chart 3: "재해 타입별 현황" (12px radius white card, 1px #e0ddd8, 16px padding, 200px height)**
- Stacked horizontal bar (showing접수 / 진행중 / 완료):
  "폭염" [15 접수 | 8 진행 | 42 완료]
  "우박" [6 접수 | 2 진행 | 28 완료]
  "한파" [2 접수 | 1 진행 | 18 완료]
  "가뭄" [0 접수 | 0 진행 | 3 완료]
- Colors: #9b9792 / #f4a261 / #52b788 (접수 / 진행 / 완료)

---

SECTION 4: EXPORT & DRILL-DOWN (bottom action row, 24px padding)

- Left: Date range picker "최근 30일" dropdown + "날짜 커스텀" link
- Right: "📊 엑셀 다운로드" secondary button + "📈 상세 리포트 보기" primary Earth Green button

---

Mood: Data-forward, operational. Multiple perspectives (farm health + intake funnel + campaign pipeline + regional patterns). Allows admin to spot trends (which regions surge in disasters? which farm types most vulnerable? campaign velocity?). Colors match system: red = urgent/vulnerable, green = success/complete, amber = in progress.
```

### Screen 17 — 배송 현황 관리

```
Design a Korean-language Admin delivery management screen for Give On at 1440px width.

Design system: [공통 context 붙이기]

LAYOUT: Left sidebar (240px, #f2f0ed background, 1px right #e0ddd8) + main content area.

LEFT SIDEBAR: (동일 — 🚚 배송 관리 활성)
- Give On logo + "관리자" badge
- Nav links: 🗺️ 대시보드 / ⚠️ 캠페인 승인 / 🚚 배송 관리 (active) / 🌾 농가 관리 / 📊 통계
- Bottom: user avatar + logout

MAIN CONTENT:

---

SECTION 1: DELIVERY STATUS SUMMARY (top, 24px padding, 4-card row, 16px gap, white background, 12px radius, 1px #e0ddd8)

Card 1: "기부 완료"
- "42건" 24px/700/#9b9792 (muted gray)
- "결제 완료" 12px/#6b6862

Card 2: "배송 준비"
- "8건" 24px/700/#f4a261 (amber warning)
- "포장 중" 12px/#6b6862

Card 3: "배송 중"
- "19건" 24px/700/#2d6a4f (green active)
- "배송사 인수" 12px/#6b6862

Card 4: "도착 완료"
- "15건" 24px/700/#52b788 (light green success)
- "이번달" 12px/#6b6862

---

SECTION 2: DELIVERY PIPELINE (24px padding, white card, 12px radius, 1px #e0ddd8)

Pipeline header: "배송 단계별 현황" 18px/600/#1c1c1a + "실시간 업데이트" 12px/#6b6862 right

4-column Kanban strip (full-width, min 800px height, light #f2f0ed background, 16px gap):

COLUMN 1: "기부 완료 💳" 16px/600 header, #9b9792 text, 12px top border (muted)
- Count badge: "42" 16px/700/#9b9792 circle top-right
- Cards (white, 12px radius, 1px #e0ddd8, 12px padding, 8px gap between):
  Card 1: "홍길동" 13px/600/#1c1c1a / "경북 청송 사과" 12px/#6b6862 / "2kg × 1" 12px/#9b9792 / "7월 15일" 11px/#c4c0b8
  Card 2: "김○○" / "충남 폭염 가지" / "1kg × 2" / "7월 16일"
  Card 3: (... scrollable, 3+ more)
- "모두 보기" link 12px/#2d6a4f bottom

COLUMN 2: "배송 준비 📦" 16px/600 header, #f4a261 text, 12px top border (amber)
- Count badge: "8" 16px/700/#f4a261
- Cards (white, same layout):
  Card 1: "박영희" 13px/600/#1c1c1a / "경북 청송 사과" 12px/#6b6862 / "2kg × 2" / "포장 중... 내일 완료" 12px/#f4a261
  Card 2: "이준호" / "전북 우박 딸기" / "1kg × 1" / "재고 확인 중"
- Action on each card: small "✓ 준비완료" 11px button green right

COLUMN 3: "배송 중 🚚" 16px/600 header, #2d6a4f text, 12px top border (green)
- Count badge: "19" 16px/700/#2d6a4f
- Cards (white, same layout):
  Card 1: "정○○" 13px/600/#1c1c1a / "경북 청송 사과" 12px/#6b6862 / "2kg" / "CJ대한통운 1234567 · D+1" 12px/#2d6a4f (courier + ETA)
  Card 2: "박○○" / "충남 가지" / "1kg × 2" / "로젠 5678901 · D+2"
- Action: small "추적" link 12px/#2d6a4f right (opens courier tracking)

COLUMN 4: "도착 완료 ✓" 16px/600 header, #52b788 text, 12px top border (light green)
- Count badge: "15" 16px/700/#52b788
- Cards (white, same layout, slight #d8f3dc background tint):
  Card 1: "홍○○" 13px/600/#1c1c1a / "경북 청송 사과" 12px/#6b6862 / "2kg" / "✓ 7월 18일 도착" 12px/#52b788
  Card 2: "김○○" / "전북 딸기" / "1kg × 2" / "✓ 7월 19일 도착"
- Action: small "감사 알림 발송" 11px #2d6a4f button right

---

SECTION 3: DELIVERY DETAIL TABLE (24px padding, white card, 12px radius, 1px #e0ddd8)

Page header: "배송 이력 (전체)" 18px/600/#1c1c1a + "필터" dropdown left

Filter row (above table, white, 8px gap):
- Status tabs: "전체 (42)" / "배송준비 (8)" / "배송중 (19)" / "도착완료 (15)" — 13px/500, active tab has #2d6a4f 2px bottom border
- Date range: "최근 30일" dropdown right 13px/500
- Right: "엑셀 다운로드" secondary outlined button

Table (scrollable, full-width, 1px #e0ddd8 borders):
- Header row (#f2f0ed background): "기부 번호" / "기부자" / "캠페인" / "농산물" / "수량" / "기부일" / "배송사" / "상태" / "예상 도착" / "액션" — all 13px/500/#6b6862, 1px bottom #e0ddd8
- Data rows (each 13px/#3d3d3a, 1px bottom #e0ddd8, 16px padding):
  Row 1: "#D4721" / "홍길동" / "경북 청송 우박 사과" / "사과 2kg" / "2" / "7.15" / "CJ대한통운" / "배송중" (green pill) / "7.20" / "📞 추적" link
  Row 2: "#D4720" / "박영희" / "경북 청송 우박 사과" / "사과 2kg" / "1" / "7.14" / "로젠" / "도착완료" (dark green pill) / "7.18" / "감사 알림 발송" button
  Row 3: "#D4719" / "김○○" / "충남 폭염 가지" / "가지 1kg" / "2" / "7.13" / "대한통운" / "배송준비" (amber pill) / "7.21" / "✓ 준비완료" button

Status pill colors & styles:
- "기부완료": #f2f0ed background, #6b6862 text, 11px/700
- "배송준비": #fef0e4 background, #f4a261 text, 11px/700
- "배송중": #d8f3dc background, #2d6a4f text, 11px/700
- "도착완료": #2d6a4f background, white text, 11px/700
All: full pill radius (9999px)

Row actions (right column):
- If "배송중": "📞 추적" link (open courier tracking in new tab)
- If "배송준비": "✓ 준비완료" button (green pill, 28px height) — marks as shipped
- If "도착완료": "감사 알림 발송" button (green pill, 28px height) — sends thank you push + generates gratitude photo request

Pagination: "1–20 / 42건" 12px/#9b9792 + prev/next arrows bottom-right

---

Mood: High-throughput logistics view. Kanban pipeline shows bottlenecks at glance (which stage is stalling?). Dense table for bulk actions. Color coding instant scan (amber = action needed, green = on track, gray = waiting). Courier integration + automation buttons reduce manual work.
```

---

### Screen 19 — 농가 관리

```
Design a Korean-language Admin farm management screen for Give On at 1440px width.

Design system: [공통 context 붙이기]

LAYOUT: Left sidebar (240px, #f2f0ed background, 1px right #e0ddd8) + main content area.

LEFT SIDEBAR: (동일 — 🌾 농가 관리 활성)
- Give On logo + "관리자" badge
- Nav links: 🗺️ 대시보드 / ⚠️ 캠페인 승인 / 🚚 배송 관리 / 🌾 농가 관리 (active) / 📊 통계
- Bottom: user avatar + logout

MAIN CONTENT:

---

SECTION 1: FARM STATISTICS SUMMARY (top, 24px padding, 4-card row, 16px gap, white background, 12px radius, 1px #e0ddd8)

Card 1: "총 등록 농가"
- "342" 28px/700/#1c1c1a
- "↑8 이번달" 12px/#6b6862

Card 2: "활성 농가"
- "298" 28px/700/#2d6a4f (green)
- "최근 7일 접근" 12px/#6b6862

Card 3: "위험도 3~4"
- "28" 28px/700/#e63946 (red)
- "모니터링 중" 12px/#6b6862

Card 4: "평균 위험도"
- "2.1점" 28px/700/#f4a261 (amber)
- "주의 수준" 12px/#6b6862

---

SECTION 2: FARM LIST & FILTERS (24px padding, white card, 12px radius, 1px #e0ddd8)

Header: "농가 목록" 18px/600/#1c1c1a + "342개" 12px/#6b6862

Filter row (white, 8px gap, 16px padding bottom):
- Search bar: "농가명, 주인명, 지역 검색..." full-width input, 40px height, 8px radius, 1px #e0ddd8 border. Placeholder 13px/#9b9792. Magnifying glass icon left 16px.
- Filter dropdowns (side-by-side):
  - "지역" dropdown (경기/경북/충남 등) 13px/500
  - "축종" dropdown (닭/돼지/소/기타) 13px/500
  - "위험도" dropdown (안전/주의/위험/긴급) 13px/500
  - "상태" dropdown (활성/휴면/정지) 13px/500
- Sort: "정렬" dropdown right (최근등록/알파벳/위험도순) 13px/500
- Action buttons right: "🔄 일괄 알림" / "📊 내보내기" outlined buttons

---

SECTION 3: FARM TABLE (full-width, scrollable)

Header row (#f2f0ed background, 13px/500/#6b6862, 1px bottom #e0ddd8):
"농가명" / "주인" / "축종" / "지역" / "위험도" / "피해신고" / "캠페인" / "기부액" / "상태" / "액션"

Data rows (each 13px/#3d3d3a, 1px bottom #e0ddd8, 16px padding, clickable):

Row 1: 
- "김철수 농장" (bold 14px/600, link #2d6a4f)
- "김철수" 
- "닭" (farm-type chip: 8px/500, #f2f0ed background)
- "경기 포천" 12px/#6b6862
- "4점 긴급" (red pill #e63946, 11px/700)
- "3건" 12px/#1c1c1a
- "1건" (모금중) 12px/#2d6a4f
- "3.2백만원" 12px/#1c1c1a
- "활성" (green pill #52b788, 11px/700)
- Action menu: "⋯" (three-dot menu) dropdown:
  - "상세 정보 보기"
  - "직접 연락" (전화/이메일)
  - "피해신고 이력"
  - "캠페인 현황"
  - "위험도 모니터링 해제"
  - "계정 정지" (#e63946 red text)

Row 2: 
- "박영희 과수원" 
- "박영희"
- "사과"
- "경북 청송" 12px/#6b6862
- "3점 위험" (orange pill #e07a5f, 11px/700)
- "1건"
- "2건" (1 모금중, 1 완료)
- "5.1백만원" 12px/#1c1c1a
- "활성" (green pill)
- "⋯" menu

Row 3: 
- "이준호 축산" 
- "이준호"
- "돼지"
- "충남 천안" 12px/#6b6862
- "2점 주의" (amber pill #f4a261, 11px/700)
- "0건"
- "0건"
- "0원" 12px/#9b9792 (muted — no activity)
- "휴면" (gray pill #9b9792, 11px/700)
- "⋯" menu

Row 4+: (... scrollable, similar structure)

Status pills legend:
- "활성" = #52b788 (active, last access < 7 days)
- "휴면" = #9b9792 (inactive, last access > 30 days)
- "정지" = #e63946 (suspended by admin)

Pagination: "1–20 / 342건" 12px/#9b9792 + prev/next arrows bottom-right

---

SECTION 4: FARM DETAIL MODAL (onClick row, slides from right)

Full-screen modal (1440px, white background):

**Left column (60%):**

Farm header card (12px radius, #f2f0ed background, 16px padding):
- Farm photo (100×100px, 12px radius) left + Info right:
  - Farm name: "김철수 농장" 18px/600/#1c1c1a
  - Owner + Phone: "김철수 · 010-1234-5678" 13px/#6b6862 (clickable phone link)
  - Email: "example@email.com" 13px/#2d6a4f (clickable)
  - Location: "경기도 포천시 어딘가" 13px/#6b6862
  - Govt registration: "✓ 정부 등록 확인됨" 12px/#2d6a4f

Risk score section (12px radius, white card, 1px #e0ddd8, 16px padding, 24px top margin):
- Current risk: "현재 위험도" label 13px/500/#6b6862
- Large circle (80px, #fde8e8 background, 2px #e63946 border): "4점" 28px/700/#e63946 center
- Status: "긴급 상태" 16px/600/#e63946, "모니터링 필요" 12px/#6b6862 below
- Risk breakdown: "기상 위험 (온도 34°C) / 축사 규모 (5000마리) / 최근 피해 이력" list 12px/#3d3d3a

Recent activity timeline (12px radius, white card, 1px #e0ddd8, 16px padding, 24px top margin):
- "최근 활동" 16px/600/#1c1c1a
- Timeline rows (6 rows max):
  - "🌡️ 위험도 상승" · 7월 18일 10:30 · "온도 급상승 알림" 12px/#6b6862
  - "📢 긴급 경보 발송" · 7월 18일 08:15 · "즉시 조치 필요" 12px/#e63946
  - "⚠️ 피해신고 접수" · 7월 17일 14:22 · "닭 5000마리 폐사" 12px/#6b6862
  - "💬 문자 발송" · 7월 15일 16:45 · "정보 제공 문자" 12px/#6b6862
  - (... more)

Damage report history (12px radius, white card, 1px #e0ddd8, 16px padding, 24px top margin):
- "피해신고 이력" 16px/600/#1c1c1a + "3건" badge 12px
- Table (compact, 3 rows):
  - "7.17 | 닭 5,000마리 | 폭염 | 캠페인 생성됨" 12px/#3d3d3a
  - "6.10 | 사과 2톤 | 우박 | 캠페인 완료" 12px/#52b788
  - "5.22 | 닭 1,000마리 | 한파 | 신고만" 12px/#3d3d3a

**Right column (36%):**

Contact & subscription panel (12px radius, white card, 1px #2d6a4f border, #d8f3dc background, 16px padding):
- "연락하기" 16px/600/#2d6a4f header
- "📞 전화" button (green pill, 48px) — tel: link
- "✉️ 이메일" button (outline, 48px) — mailto: link
- "💬 문자 발송" button (outline, 48px) — opens SMS template
- Divider 1px #e0ddd8, 12px vertical margin
- "구독 상태" 13px/500/#6b6862
- Badge: "기본 (무료)" or "프리미엄" (green pill) 11px/700
- "구독 변경" link 12px/#2d6a4f

Monitoring panel (12px radius, white card, 1px #e0ddd8, 16px padding, 12px gap below):
- "모니터링" 16px/600/#1c1c1a
- Toggles:
  - "위험도 추적" toggle (enabled, #2d6a4f)
  - "자동 경보" toggle (enabled, #2d6a4f)
  - "일일 리포트" toggle (disabled, #9b9792)
- "알림 설정" link 12px/#2d6a4f

Actions panel (12px radius, #fde8e8 background, 16px padding, 12px gap below):
- "관리 작업" 16px/600/#e63946 header
- "✎ 정보 수정" outline button (48px)
- "🔕 알림 해제" outline button (48px)
- "⛔ 계정 정지" button (#e63946 fill, white text, 48px) — with confirmation modal

Campaign details (if applicable, 12px radius, white card, 1px #e0ddd8, 16px padding, 12px gap below):
- "활성 캠페인" 16px/600/#1c1c1a (if exists)
- Campaign card summary: title / progress bar / donor count / amount
- Or "진행 중인 캠페인 없음" 12px/#9b9792

---

Mood: Comprehensive farm oversight. Admin can scan risk at glance (red circle, traffic light), see activity timeline, contact farm directly, manage monitoring. Modal keeps context (list visible behind). Color coding: red = urgent attention, green = contact/action, gray = inactive/no activity.
```

## Stitch 공통 지시사항 (모든 화면에 적용)

```
Global design rules for all Give On screens:

1. CANVAS: Always #fafaf8. Never #ffffff. If Stitch defaults to pure white, override.

2. PRIMARY CTA: Always full pill shape (border-radius: 9999px), #2d6a4f fill, white text, 48px min height. Never square buttons for main actions.

3. URGENCY COLOR (#e63946 Harvest Red): Only on disaster alerts, emergency risk states, "긴급" badges. Never on positive CTAs, decorative elements, or section headers.

4. PRODUCE PHOTOS: Realistic, imperfect, unfiltered. Show whole items. Natural light. No AI-generated perfect produce. If generating placeholder images, specify "hail-damaged apple, realistic, natural light, wooden surface, visible dents, no color correction."

5. KOREAN TEXT: All UI labels, buttons, navigation in Korean. Body font: Pretendard or Noto Sans KR. Line-height minimum 1.6 for body, 1.3 for headlines.

6. RISK INDICATOR (Farm App): The 4-state traffic light uses ONLY these colors:
   안전 → #52b788 | 주의 → #f4a261 | 위험 → #e07a5f | 긴급 → #e63946

7. SHADOW: One tier only. rgba(0,0,0,0.04) 0 1px 3px, rgba(0,0,0,0.08) 0 4px 12px. No other shadow levels.

8. BORDER RADIUS: Cards 12px. CTAs 9999px (full pill). Photos 16px. Alert banners 4px. Date/small chips: full pill.

9. NO GRADIENTS except Climate Journey Card (#1a2e1e background only).

10. FOOTER: Always #e8e5e0 background (warm beige-gray). CO₂ impact counter in Earth Green (#2d6a4f). 3-column link structure.
```
