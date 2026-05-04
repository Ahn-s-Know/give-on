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

## iOS App 화면 (6개)

---

### Screen 1 — 온보딩 (농가 등록)

```
Design a Korean-language iOS onboarding screen for Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Screen: Farm registration onboarding — Step 2 of 3 (location already done, now livestock setup)

Layout (top to bottom):
- Status bar (iOS standard)
- Step indicator: 3 dots top-center, dot 2 active in #2d6a4f, others in #e0ddd8. Below: "2/3 · 축종 및 사육 두수" in 13px/#6b6862
- Section title: "어떤 가축을 키우시나요?" in 22px/700/#1c1c1a, 24px top margin
- Livestock type grid: 2×2 grid of selection cards. Each card: 80×80px, 12px radius, 1px #e0ddd8 border, centered emoji icon (🐔🐷🐄🦆) + Korean label below (닭 / 돼지 / 한우·젖소 / 오리) in 14px/500. Selected state: #2d6a4f border 2px + #d8f3dc background fill. Multiple selection allowed.
- Section title: "총 사육 두수" in 17px/600/#1c1c1a, 32px top margin
- Number input field: full-width, 56px height, 8px radius, 1px #e0ddd8 border. Placeholder "예: 50,000" in #9b9792. Right-side unit label "마리" in 14px/#6b6862. Focus state: 2px #2d6a4f border.
- Helper text below input: "두수가 많을수록 경보 우선순위가 높아집니다" in 13px/#6b6862
- Bottom: "다음" primary CTA button — full pill shape, #2d6a4f fill, white text "다음" 16px/600, 48px height, full-width with 24px horizontal margin. Above button: 8px margin.
- Safe area bottom padding.

Tone: Clean, reassuring. This is a setup screen — no urgency colors. Earth Green only for active selection and CTA.
```

---

### Screen 2 — 홈 화면 (안전 상태)

```
Design a Korean-language iOS home screen for Give On Farm app at 375×812px. Safe state — no active disaster.

Design system: [공통 context 붙이기]

Layout (top to bottom):
- Status bar
- Top bar: "내 농장" title 17px/600/#1c1c1a left. Bell icon right (notification). No border.
- Risk indicator card: full-width, 16px radius, #d8f3dc (#primary-light) background, 24px padding.
  - Top: "오늘 위험도" label 13px/500/#6b6862
  - Center: Large circle 100px diameter, solid #52b788 (risk-safe green) fill, white checkmark icon inside
  - Below circle: "안전" label 14px/700/uppercase/#52b788, 4px top margin
  - Weather row: three chips side by side — "현재 기온 22°C", "습도 58%", "내일 최고 25°C" — each in 13px/#6b6862, separated by 1px #e0ddd8 dividers
  - AI message: "오늘은 위험 수준이 아닙니다. 쾌적한 하루 보내세요." in 14px/400/#3d3d3a, 12px top margin
- Morning briefing card: 12px radius, white background, 1px #e0ddd8 border, 16px padding
  - Header: "📋 오늘의 예보" 13px/600/#2d6a4f
  - Body: "경기 포천 지역 오늘 최고 25°C, 닭 기준 안전 수준입니다." 14px/400/#3d3d3a, 1.7 line-height
- Ugly produce registration nudge card: 12px radius, #f2f0ed background, 16px padding
  - Left: small apple emoji + "못난이 등록" 14px/600/#1c1c1a
  - Right: "→" arrow in #2d6a4f
  - Sub-label: "이번 주 우박 예보 — 손상 작물이 생기면 바로 등록해요" 13px/#6b6862
- Bottom navigation bar: white, 1px top #e0ddd8 border, 64px height. 4 tabs equally spaced: 홈(active, #2d6a4f icon+label) / 경보이력 / 못난이등록 / 설정. Active tab icon+label in #2d6a4f, inactive in #9b9792. Labels 13px/600.

Mood: Calm, reassuring. Dominant color is green — safety, nature, warmth.
```

---

### Screen 3 — 홈 화면 (위험 상태)

```
Design a Korean-language iOS home screen for Give On Farm app at 375×812px. Danger state — active heat disaster.

Design system: [공통 context 붙이기]

Layout:
- Status bar
- Top bar: "내 농장" 17px/600/#1c1c1a left. Bell icon with red dot badge right.
- Risk indicator card: full-width, 16px radius, #fde8e8 (urgency-light) background, 24px padding.
  - Top: "오늘 위험도" label 13px/500/#6b6862
  - Center: Large circle 100px diameter, solid #e07a5f (risk-danger terracotta) fill, white warning triangle icon inside
  - Below circle: "위험" label 14px/700/uppercase/#e07a5f
  - Weather row: "현재 기온 34°C" in #e63946 bold, "습도 71%", "내일 최고 37°C" in #e63946 bold — danger temperatures in Harvest Red
  - AI message (Claude-generated): "현재 34°C입니다. 닭 위험 수준 — 즉시 환풍기를 최대로 가동하고 음수 온도를 20°C 이하로 유지해 주세요." 14px/400/#1c1c1a, 1.7 line-height, 3 lines max
- Checklist section:
  - Header: "대응 체크리스트" 17px/600/#1c1c1a
  - 3 checklist rows, each: 48px height, 1px bottom #e0ddd8. Checkbox 24×24px rounded-square left. Label "환풍기 최대 가동 확인" 16px/400/#1c1c1a. Row 1 checked (Earth Green fill checkbox + strikethrough muted text). Rows 2–3 unchecked.
  - Below list: "1/3 완료" progress text 13px/#6b6862 right-aligned
- Damage report CTA: full-width button, 12px radius, 1px #e63946 border, #fde8e8 background. Left: "⚠️ 피해가 발생했나요?" 14px/600/#e63946. Right: "신고하기 →" 14px/600/#e63946.
- Bottom nav bar (same as Screen 2, danger state doesn't change nav)

Mood: Elevated attention. Red/amber signals dominate the risk card. Rest of screen stays warm off-white to avoid full alarm-state panic — only the risk card itself shifts to urgency tones.
```

---

### Screen 4 — 홈 화면 (긴급 상태)

```
Design a Korean-language iOS home screen for Give On Farm app at 375×812px. Emergency state — extreme heat disaster.

Design system: [공통 context 붙이기]

IMPORTANT: This screen uses FULL DARK MODE override. Background: #1a2e1e (surface-dark). All text: #f0f0ec (on-dark). This is the only screen in the app with a dark background.

Layout:
- Status bar (light content on dark background)
- Top bar on #1a2e1e: "내 농장" white. Bell icon white with red badge.
- Full-bleed emergency risk card (no card — just the screen itself is the card):
  - Center of upper half: Large pulsing circle — 120px diameter, #e63946 fill. CSS animation instruction: "scale pulse 1.5s ease-in-out infinite between 1.0 and 1.08". White exclamation mark icon inside.
  - Below circle: "긴급" label 16px/700/uppercase/#e63946 with letter-spacing 1px
  - Weather: "현재 기온 36°C" in large 32px/700/#e63946. "내일 최고 38°C 예보" 16px/#f0f0ec below.
  - Separator: 1px #2d6a4f line full-width, 24px vertical margin
  - AI message: "즉시 모든 환풍기를 최대로 가동하세요. 지금 당장 축사 온도를 확인하세요." 16px/600/#f0f0ec, 1.6 line-height, max 2 lines
- Emergency actions: two full-width buttons stacked, 16px gap:
  - Primary: "긴급 체크리스트 확인" — full pill, #e63946 fill, white text 16px/600, 56px height
  - Secondary: "피해 신고하기" — full pill, transparent fill, 1px #f0f0ec border, #f0f0ec text 16px/600, 56px height
- Bottom of screen: soft #2d6a4f bottom nav bar (stays brand-colored even in emergency — navigation must remain accessible)

Mood: Maximum urgency. Dark, serious, immediate. The farmer must feel this is a life-critical alert. No decorative elements. No illustrations.
```

---

### Screen 5 — 못난이 등록

```
Design a Korean-language iOS screen for ugly produce registration in Give On Farm app at 375×812px.

Design system: [공통 context 붙이기]

Context: A push notification just fired — "이번 우박으로 손상된 작물이 있나요? 기부 답례품으로 등록해 보세요." This screen is the result of tapping that notification.

Layout:
- Status bar
- Navigation: back chevron left, "못난이 등록" title 17px/600 center, "닫기" text right
- Step indicator: 3 steps top. Current: step 1 "사진 등록" active in #2d6a4f. Steps 2 "작물 정보" and 3 "확인" inactive in #e0ddd8. Progress line connecting dots.
- Context banner: 12px radius, #fde8e8 background, 1px #e63946 left border (4px wide). "⚡ 경북 청송 우박 특보 발령 중" 13px/600/#e63946. Sub: "이번 우박으로 손상된 작물을 기부 답례품으로 등록하면 폐기 없이 전달됩니다." 13px/#6b6862.
- Photo upload zone: full-width, 200px height, 16px radius, #f2f0ed fill, 1px dashed #c4c0b8 border. Center: camera icon 32px in #9b9792. Below icon: "사진을 추가해주세요" 14px/#9b9792. Sub: "손상된 모습 그대로 찍어주세요 (최대 5장)" 12px/#9b9792. Tap to add.
- Small tip card below: white, 8px radius, 1px #e0ddd8 border, 12px padding. "💡 팁: 흠집이 보이도록 전체 모습을 찍어주세요. 자연 채광에서 찍으면 더 좋아요." 13px/#6b6862.
- Produce type label: "작물 종류" 13px/500/#6b6862, 24px top margin
- Produce type selector: horizontal scroll row of selection pills — "사과 🍎" / "감자 🥔" / "배 🍐" / "기타 🌾". Each pill: 36px height, full pill radius, 14px/500. Default: white fill, 1px #e0ddd8. Selected: #2d6a4f fill, white text.
- Damage cause label: "손상 원인"
- Damage cause pills: "우박" (pre-selected, #2d6a4f fill) / "폭염" / "가뭄" / "한파"
- Bottom: "다음 — 작물 정보 입력" full-pill #2d6a4f CTA, 48px, full-width, 24px margin.

Mood: Encouraging, practical. The farmer is being asked to do something in a stressful moment — the UI must feel effortless and quick. Green dominates the active states. The urgency banner is present but small.
```

---

### Screen 6 — 피해 신고

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

## 웹 화면 (8개)

---

### Screen 7 — 메인 화면 (재난 없음)

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

### Screen 9 — 캠페인 상세 (못난이 농산물)

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

### Screen 10 — 기부 완료 화면

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

### Screen 11 — 농부 감사 사진 알림

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

### Screen 12 — 임팩트 리포트

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

### Screen 13 — 기후 여정 카드 (연말 공유용)

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

### Screen 14 — 관리자 대시보드

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
  📊 통계
- Bottom: user avatar + name + "로그아웃" in small text

MAIN CONTENT:

TOP STAT ROW (4 cards, equal width, 16px gap, 24px padding, white background, 12px radius, 1px #e0ddd8):
Card 1: "오늘 위험 농가" label 13px/#6b6862 / "23" number 28px/700/#e63946 (red — danger signal) / "↑5 어제 대비" 12px/#6b6862
Card 2: "못난이 등록" / "8건" 28px/700/#2d6a4f / "신규 3건"
Card 3: "진행 캠페인" / "12개" 28px/700/#1c1c1a
Card 4: "이번 주 기부" / "4.2백만원" 28px/700/#2d6a4f

MAIN AREA (below stats, two columns 60%/40% gap):

LEFT: Risk Map (60%)
- Label "전국 위험 현황" 18px/600/#1c1c1a + "실시간" small green blinking dot
- 카카오맵 placeholder (400px height, 12px radius, #f2f0ed background representing a map). On the map: colored farm markers — red marker (긴급), orange (위험), amber (주의), green (안전). Legend bottom-left inside map: small color squares + labels.
- Map has a filter row above: "전체" / "긴급" / "위험" / "주의" filter pills.

RIGHT: Campaign Approval Queue (40%)
- Label "승인 대기 캠페인" 18px/600/#1c1c1a + "3건" #e63946 count badge
- List of 3 pending campaigns, each row (white card, 12px radius, 1px #e0ddd8, 16px padding, 12px gap between cards):
  Row: Campaign type pill (우박/폭염/etc #1c1c1a pill) + region "경북 청송" 14px/600/#1c1c1a + urgency score chip "긴급도 8점" #e63946 outlined pill. Below: story excerpt 13px/#6b6862 2-line max. Action row: "승인" button (Earth Green fill, 32px, pill) + "반려" (outlined, 32px, pill) side by side.

Mood: Functional, information-dense, operational. Less warmth than the citizen-facing web — this is a tool. But same color system — Earth Green for approve, Harvest Red for urgency signals.
```

---

### Screen 15 — 캠페인 승인 상세

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

### Screen 16 — 배송 현황 관리

```
Design a Korean-language Admin delivery management screen for Give On at 1440px width.

Design system: [공통 context 붙이기]

LAYOUT: Same left sidebar as Screen 14. Main content full-width table.

PAGE HEADER:
"배송 현황 관리" 26px/700/#1c1c1a. 
Filter tabs: "전체 (42)" / "배송준비 (8)" / "배송중 (19)" / "도착완료 (15)". Active tab: #2d6a4f underline.
Right: "엑셀 다운로드" secondary outlined button.

DELIVERY PIPELINE (visual kanban-style strip, 64px height, #f2f0ed background, full-width, 4 columns):
Column headers (each ~25%): 
"기부 완료 💳" → "배송 준비 📦" → "배송 중 🚚" → "도착 확인 ✓"
Colors: #9b9792 / #f4a261 / #2d6a4f / #52b788 (lighter green). Count badge on each.

DELIVERY TABLE:
Full-width table, white background, 1px #e0ddd8 borders.
Header row: #f2f0ed background. Columns: 기부 번호 / 기부자 / 캠페인 / 농산물 / 수량 / 기부일 / 상태 / 액션
Row example:
- #D4721 / 홍○○ / 경북 청송 사과 / 사과 2kg / 7.15 / "배송 중" amber pill / "배송 완료 처리" small Earth Green pill button

Status pills in table:
"기부완료" — #f2f0ed background, #6b6862 text
"배송준비" — #fef0e4 background, #f4a261 text (amber)
"배송중" — #d8f3dc background, #2d6a4f text (green)
"도착완료" — #2d6a4f background, white text (solid green)
All pills: full pill radius, 11px/700 uppercase.

Pagination: "1–20 / 42건" + prev/next arrows, bottom-right.

Mood: Operational, efficient. Table is dense but readable. Status colors provide instant scanning. Earth Green = positive (delivered). Amber = in progress.
```

---

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
