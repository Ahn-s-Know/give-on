# Give On — Design System Guide

## Overview

Give On is a climate-disaster response donation platform that connects citizens with affected farmers through AI-generated campaigns and delivers ugly produce as tangible rewards. The design language must carry three emotional registers simultaneously: **urgency** (climate disaster is happening now), **warmth** (a real farmer is waiting), and **trust** (your money becomes real food on your table).

The base canvas is **warm off-white** (`{colors.canvas}` — #fafaf8) rather than pure white — a deliberate choice to evoke the natural, earthy quality of farmland and produce. The primary accent is **Earth Green** (`{colors.primary}` — #2d6a4f), a deep forest green that signals nature, growth, and sustainability. A single urgency accent, **Harvest Red** (`{colors.urgency}` — #e63946), is reserved exclusively for disaster alerts, emergency risk indicators, and time-sensitive campaign banners. It never appears on decorative elements.

Type runs **Pretendard** (the standard Korean-language variable font), falling back to **Noto Sans KR** and the system stack. Korean-first typography means line-heights run slightly looser than Latin-only systems — body copy sits at 1.7 rather than Airbnb's 1.5 to accommodate Hangul stroke density.

The shape language is **organic but grounded**. Campaign cards use 12px radius (`{rounded.md}`), the main search/filter bar uses 8px (`{rounded.sm}`), produce photo thumbnails clip at 16px (`{rounded.lg}`), and the urgency alert banners use a flat 4px (`{rounded.xs}`) to feel serious rather than playful. Full pill shapes (`{rounded.full}`) appear only on status badges (risk level tags, "긴급" labels) and the primary CTA button.

**Key Characteristics:**
- Dual-accent system: `{colors.primary}` (#2d6a4f Earth Green) for all positive actions and brand moments. `{colors.urgency}` (#e63946 Harvest Red) exclusively for disaster urgency signals. They never appear together on the same element.
- Korean-first typography: `Pretendard` variable font. Body at 16px / 400 / line-height 1.7. Display at 24–32px / 700. Modest weights — visual hierarchy comes from the produce photography and farmer portraits, not typographic muscle.
- Photo-led campaign cards: the ugly produce photograph is the emotional anchor of every donation card. The design system trusts the imperfect textures of hail-scarred apples and sun-scorched peppers to carry visual weight. Never crop or filter produce photos — raw imperfection is the point.
- Risk level traffic light: the four-state risk indicator (safe / caution / danger / emergency) is the signature UI element of the Farm app. Color-coded with semantic tokens (`{colors.risk-safe}`, `{colors.risk-caution}`, `{colors.risk-danger}`, `{colors.risk-emergency}`), it must be immediately legible at a glance from across a room — it is a life-and-limb signal for farmers.
- Climate score timeline: a horizontal progress visualization showing a farm's risk journey from disaster to recovery. Uses the risk-level color tokens as data ink.
- Elevation at one tier: a single soft shadow (`box-shadow: rgba(0,0,0,0.04) 0 1px 3px, rgba(0,0,0,0.08) 0 4px 12px`) used on campaign cards on hover, the sticky reservation/donation panel, and the mobile bottom bar. No progressive depth — surfaces are either flat or floating.

---

## Colors

### Brand & Accent

- **Earth Green** (`{colors.primary}` — #2d6a4f): The single brand color. Used for primary CTA backgrounds ("기부하기", "등록하기"), the farm app's active nav indicator, the heart/save state on campaign cards, progress bar fill, and the Give On wordmark. Appears in perhaps 10% of surface area — the canvas and photography carry the rest.
- **Earth Green Active** (`{colors.primary-active}` — #1b4332): Press / pointer-down variant. Deeper forest tone, used on `{component.button-primary-active}`.
- **Earth Green Disabled** (`{colors.primary-disabled}` — #b7dbc8): Pale mint tint on disabled CTAs.
- **Earth Green Light** (`{colors.primary-light}` — #d8f3dc): Very light green surface used as the background for progress indicators, "모집 완료" completion badges, and positive status chips.
- **Harvest Red** (`{colors.urgency}` — #e63946): Urgency-only accent. Applied exclusively to: emergency/danger risk level indicators, disaster alert banners, the "긴급" campaign badge, and FCM push notification icons. Never used decoratively. Never paired with Earth Green on the same element.
- **Harvest Red Light** (`{colors.urgency-light}` — #fde8e8): Pale urgency tint — background fill for inline alert cards and the emergency risk panel.
- **Amber Warning** (`{colors.warning}` — #f4a261): The "caution" risk level. Warm amber sits between safe green and danger red in the traffic-light sequence. Also used for "주의" badges and moderate weather alerts.
- **Amber Light** (`{colors.warning-light}` — #fef0e4): Background fill for caution-level alert panels.

### Risk Level (Farm App Signature)

- **Risk Safe** (`{colors.risk-safe}` — #52b788): Bright natural green. "안전" state indicator.
- **Risk Caution** (`{colors.risk-caution}` — #f4a261): Warm amber. "주의" state.
- **Risk Danger** (`{colors.risk-danger}` — #e07a5f): Terracotta orange-red. "위험" state.
- **Risk Emergency** (`{colors.risk-emergency}` — #e63946): Full Harvest Red. "긴급" state. Pulses on animation.

### Surface

- **Canvas** (`{colors.canvas}` — #fafaf8): The warm off-white page floor. Slightly warmer than pure white — evokes natural paper and farmland.
- **Surface Soft** (`{colors.surface-soft}` — #f2f0ed): Light warm fill — used on alternating campaign card rows, disabled field backgrounds, the filter/sort band, and Admin table row stripes.
- **Surface Warm** (`{colors.surface-warm}` — #e8e5e0): A slightly deeper warm tone for sidebar panels, the checklist background in the Farm app, and the footer band.
- **Surface Dark** (`{colors.surface-dark}` — #1a2e1e): Deep forest green surface. Used as the background for the urgency alert banner overlay and the emergency full-screen warning modal in the Farm app.

### Hairlines & Borders

- **Hairline** (`{colors.hairline}` — #e0ddd8): Default 1px border — campaign card borders, form dividers, table separators. Warm-toned to match the canvas.
- **Hairline Soft** (`{colors.hairline-soft}` — #ece9e4): Lighter divider for long editorial sections.
- **Border Strong** (`{colors.border-strong}` — #c4c0b8): Heavier stroke for focused form inputs and disabled outline buttons.

### Text

- **Ink** (`{colors.ink}` — #1c1c1a): Primary text. Near-black with a warm undertone — not cold #000000. Display headlines, body paragraphs, primary nav links.
- **Body** (`{colors.body}` — #3d3d3a): Secondary running text inside campaign stories, farm descriptions, and long-form copy.
- **Muted** (`{colors.muted}` — #6b6862): Sub-labels, metadata rows ("경북 청송 · 200kg · 사과"), inactive nav labels, "더 보기" links.
- **Muted Soft** (`{colors.muted-soft}` — #9b9792): Disabled text. Placeholder copy inside form inputs.
- **On Primary** (`{colors.on-primary}` — #ffffff): White text on Earth Green CTAs.
- **On Urgency** (`{colors.on-urgency}` — #ffffff): White text on Harvest Red alert elements.
- **On Dark** (`{colors.on-dark}` — #f0f0ec): Off-white text on `{colors.surface-dark}` emergency surfaces.

### Semantic

- **Error** (`{colors.error}` — #c1121f): Form validation errors. Distinct from Harvest Red — slightly darker, used only for form states.
- **Success** (`{colors.success}` — #2d6a4f): Matches Earth Green. Used for "배송 완료", "복구 완료" confirmation states.
- **CO2 Teal** (`{colors.co2}` — #0077b6): A single environmental data accent used exclusively in the CO₂ impact visualization inside the Climate Score and Impact Report. Distinct from brand green to avoid confusion. Never used as a UI accent.

### Scrim

- **Scrim** (`{colors.scrim}` — #000000 at 40% opacity): Modal backdrop. Slightly lighter than Airbnb's 50% — the warm canvas shows through more, maintaining the platform's natural warmth even behind modals.

---

## Typography

### Font Family

**Pretendard** variable font for all Korean and Latin text. Fallback stack: `"Noto Sans KR", -apple-system, system-ui, "Helvetica Neue", sans-serif`. Pretendard is chosen because it covers the full Korean character set with clean, modern strokes at small sizes and humanist warmth at display sizes — matching the platform's balance of urgency and care.

Line-heights run looser than Airbnb's Latin-optimized system: body at 1.7 (vs Airbnb's 1.5) to give Hangul strokes breathing room. Display sizes tighten slightly.

### Hierarchy

| Token | Size | Weight | Line Height | Letter Spacing | Use |
|---|---|---|---|---|---|
| `{typography.display-xl}` | 32px | 700 | 1.3 | -0.5px | Hero headline ("기후 재난을 함께 극복해요") |
| `{typography.display-lg}` | 26px | 700 | 1.35 | -0.3px | Section headers, Campaign title on detail page |
| `{typography.display-md}` | 22px | 600 | 1.4 | -0.2px | Campaign card title ("경북 청송 우박 피해 사과 농장") |
| `{typography.display-sm}` | 18px | 600 | 1.45 | 0 | Sub-section titles, Admin table headers |
| `{typography.title-md}` | 17px | 600 | 1.5 | 0 | Farm app section heads, "오늘의 위험 예보" |
| `{typography.title-sm}` | 16px | 500 | 1.5 | 0 | Footer column heads, filter tab labels |
| `{typography.body-md}` | 16px | 400 | 1.7 | 0 | Default running text — campaign stories, farm descriptions |
| `{typography.body-sm}` | 14px | 400 | 1.6 | 0 | Campaign meta ("경북 청송 · 우박 피해 · 200kg 남음"), dates |
| `{typography.caption}` | 13px | 500 | 1.4 | 0.1px | Form field labels ("농장 위치", "작물 종류"), filter labels |
| `{typography.caption-sm}` | 12px | 400 | 1.35 | 0 | Footer legal, timestamp microcopy |
| `{typography.badge}` | 11px | 700 | 1.2 | 0.3px (uppercase) | "긴급", "마감 임박", "신규" badge labels |
| `{typography.number-display}` | 48px | 700 | 1.1 | -1px | Impact report headline numbers ("127명", "200kg", "0.9톤") |
| `{typography.button-md}` | 16px | 600 | 1.25 | 0 | Primary CTA ("기부하기", "등록하기") |
| `{typography.button-sm}` | 14px | 500 | 1.3 | 0 | Secondary CTA, filter pill labels |
| `{typography.risk-label}` | 14px | 700 | 1.2 | 0.5px (uppercase) | Risk level label ("위험", "안전") in the traffic-light |
| `{typography.nav-label}` | 13px | 600 | 1.2 | 0 | Bottom nav labels in the Farm iOS app |

### Principles

Display headlines at 26–32px carry the platform's emotional register. The hero headline is deliberately kept at 32px rather than the 48–64px common in climate/NGO campaigns — the produce photography does the heavy lifting above the fold. The one moment of typographic loudness is the **impact number display** (`{typography.number-display}` — 48px / 700), used only in the Impact Report and the year-end Climate Journey Card. That is the system's single loudest typographic moment, mirroring Airbnb's rating-display pattern.

Korean text should never be tracked negatively below -0.5px — Hangul strokes become illegible. All letter-spacing values above are tested against Korean character sets.

---

## Layout

### Spacing System

- **Base unit:** 4px.
- **Tokens:** `{spacing.xxs}` 2px · `{spacing.xs}` 4px · `{spacing.sm}` 8px · `{spacing.md}` 12px · `{spacing.base}` 16px · `{spacing.lg}` 24px · `{spacing.xl}` 32px · `{spacing.xxl}` 48px · `{spacing.section}` 64px · `{spacing.section-lg}` 80px.
- **Section vertical padding:** `{spacing.section}` (64px) for the main hero and editorial bands. `{spacing.section-lg}` (80px) for the Climate Journey Card and Impact Report sections where impact numbers need breathing room.
- **Campaign card internal:** `{spacing.base}` (16px) for photo-to-meta gap; `{spacing.lg}` (24px) for internal card padding on the detail panel; `{spacing.sm}` (8px) for meta row gutters.
- **Farm App:** `{spacing.lg}` (24px) between major home-screen sections; `{spacing.base}` (16px) between checklist rows; `{spacing.sm}` (8px) between stat chips.

### Grid & Container

- **Max content width:** 1280px centered. Campaign detail pages cap at 1080px.
- **Campaign grid (web):** 3-column at desktop (1128px+), 2-column at tablet, 1-column on mobile. 24px gutters.
- **Campaign detail:** 2-column — photo + story body on the left (~60%), sticky donation panel on the right (~36%). Mirrors Airbnb's listing detail layout.
- **Admin dashboard:** Full-width table layout with a left sidebar (240px) for navigation, right content area for map + list.
- **Farm iOS App:** Single column, full-bleed section cards. The risk indicator takes the top ~40% of the home screen viewport.

### Whitespace Philosophy

The page breathes more generously than Airbnb's marketplace density — this is a cause platform, not a transactional marketplace. Hero sections at 80px vertical rhythm signal "take a moment with this." Campaign grids compress slightly (24px gutters vs Airbnb's 16px) to feel curated rather than crowded. The produce photos need space to communicate their imperfection — cramped cards undermine the emotional message.

---

## Elevation

Single shadow tier plus baseline flat.

- **Flat:** Body, hero, editorial bands, nav — 90% of surfaces.
- **Card float:** `box-shadow: rgba(0,0,0,0.04) 0 1px 3px, rgba(0,0,0,0.08) 0 4px 12px` — applied to campaign cards on hover, the sticky donation panel, and the Admin sidebar. Warmer alpha than Airbnb's (0.04 / 0.08 vs 0.02 / 0.04 / 0.10) to compensate for the warm canvas background.
- **Modal scrim:** `{colors.scrim}` at 40% opacity.
- **Emergency overlay:** `{colors.surface-dark}` at full opacity — a full-screen dark green surface used in the Farm app's emergency (4-level) alert modal.

---

## Components

### Buttons

**`button-primary`** — Earth Green fill (#2d6a4f), white text, `{rounded.full}` pill shape (9999px), 16px / 600 label, 48px height, 24×16px padding. Primary CTAs: "기부하기", "등록하기", "경보 확인".

**`button-primary-active`** — Background to `{colors.primary-active}` (#1b4332). No transform.

**`button-primary-disabled`** — `{colors.primary-disabled}` (#b7dbc8) fill, white text, cursor not-allowed.

**`button-secondary`** — White fill, Earth Green text (#2d6a4f), 1px Earth Green border, `{rounded.full}` pill, 48px height. Used for "나중에", "자세히 보기", modal cancel.

**`button-urgency`** — Harvest Red fill (#e63946), white text, `{rounded.full}` pill, 48px height. Reserved exclusively for "긴급 경보 확인" and "지금 바로 기부" on disaster-alert modals. Never used for standard CTAs.

**`button-tertiary-text`** — Earth Green text, no surface, underlined on hover. "더 보기", "전체 보기", modal close labels.

**`button-pill-filter`** — White fill, 1px hairline border, `{rounded.full}`, 36px height, 14px / 500 label. Used in the campaign filter strip ("전체", "폭염", "우박", "가뭄").

### Risk Level Indicator (Farm App Signature Component)

**`risk-indicator`** — The central UI moment of the Give On Farm iOS app. A large circular or pill-shaped badge occupying the top section of the home screen.

- **Container:** Full-bleed card with `{rounded.lg}` (16px) clipping. Background color matches the active risk level's light variant (`{colors.risk-safe}` / `{colors.warning-light}` / etc.).
- **Risk circle:** A large (120px diameter) filled circle in the active risk color, centered above the risk label.
- **Risk label:** `{typography.risk-label}` — 14px / 700 / uppercase / 0.5px tracking. Text: "안전" / "주의" / "위험" / "긴급".
- **Weather stats row:** Below the circle — current temperature, humidity, and "내일 최고기온" in `{typography.body-sm}` muted.
- **Alert message:** Claude-generated message in `{typography.body-md}` ink, max 3 lines, below weather stats.
- **Emergency state:** At "긴급" level, the entire home screen background transitions to `{colors.surface-dark}`, text to `{colors.on-dark}`, and the risk circle pulses with a 1.5s ease-in-out scale animation.

### Campaign Cards (Web)

**`campaign-card`** — Photo-first card. `{rounded.md}` (12px) clipping. 1px `{colors.hairline}` border. Internal layout:

- **Photo plate:** 4:3 aspect ratio, full-bleed to card edges. Produce photo is never cropped tighter than showing the full item — show the hail scar, show the irregular shape. A floating badge top-left carries campaign type.
- **Urgency badge** (`{component.urgency-badge}`): Pill badge. "긴급" in Harvest Red / "진행중" in Earth Green / "마감 임박" in Amber.
- **Heart/save:** `{component.icon-button-circle}` top-right. Outlined by default, Earth Green filled when saved.
- **Meta block:** 16px padding beneath photo. Campaign title in `{typography.display-md}` ink (2 lines max). Region + cause + remaining quantity in `{typography.body-sm}` muted ("경북 청송 · 우박 · 사과 200kg 남음"). Progress bar showing funding completion in Earth Green. "3만원 · 2kg 박스 직배송" price summary right-aligned in `{typography.body-sm}` ink.

**`campaign-card-urgent`** — Same structure as `campaign-card` but with a 2px Harvest Red top border and a full-width `{colors.urgency-light}` tint behind the meta block. Used for AI-auto-generated campaigns with urgency score ≥ 7.

### Campaign Detail Panel

**`donation-panel`** — Sticky right-rail panel (mirrors Airbnb's `{component.reservation-card}`). White surface, `{rounded.md}` 12px, 1px `{colors.hairline}` border, card-float shadow, 24px padding.

Contents (top to bottom):
1. Amount selector — three pill buttons (1만원 / 3만원 / 5만원) + free-input field. Active pill: Earth Green fill, white text.
2. Reward preview — small photo of the produce box with delivery note.
3. "기부하기" `{component.button-primary}` full-width.
4. Reward breakdown: "3만원 → 사과 2kg 박스 직배송 + 농부 감사 사진" in `{typography.body-sm}` muted.
5. "결제 전 안내사항 확인" `{component.button-tertiary-text}`.

### Climate Score Timeline

**`climate-score-timeline`** — A horizontal timeline visualization shown in the Campaign Detail and Impact Report pages.

- **Track:** A full-width horizontal line in `{colors.hairline}`.
- **Nodes:** Circular nodes (16px diameter) at each event point. Color matches the risk level at that moment using risk-level tokens.
- **Labels:** Event name above the node in `{typography.caption}` muted. Date below in `{typography.caption-sm}`.
- **Final node:** Always the current state. If "안전" (recovery complete), the final node is `{colors.risk-safe}` with a checkmark icon.
- **Example sequence:** 🔴 긴급(우박 피해) → 🟠 위험(캠페인 시작) → 🟡 주의(기부 127명) → 🟢 안전(복구 완료).

### Ugly Produce Photo Treatment

**`produce-photo`** — The most important visual element in the system. Rules:

- Never apply filters, color correction, or saturation boosts. The imperfect, natural appearance of damaged produce is the emotional hook.
- Always show the full item (no tight crops). A hail-scarred apple must be shown whole so the viewer can see it is still a whole, good apple.
- Aspect ratio: 4:3 on campaign cards. 16:9 hero banner on campaign detail. 1:1 thumbnail in the donation panel and impact report.
- Light, neutral background in farm-taken photos — encourage farmers to shoot on a white cloth or wooden surface. Do not use AI-generated produce images.
- Caption below hero photo: farmer name + region in `{typography.body-sm}` muted ("김철수 농부 · 경북 청송").

### Gratitude Photo Card

**`gratitude-photo-card`** — The "농부 감사 사진" notification component. Appears in the web app notification center and as a push notification preview.

- **Layout:** Photo (1:1, `{rounded.md}`, 80px) left-aligned. To the right: farmer name in `{typography.title-sm}` ink, message excerpt in `{typography.body-sm}` body (2 lines), timestamp in `{typography.caption-sm}` muted.
- **Background:** `{colors.primary-light}` (#d8f3dc) tint — a warm green "good news" surface distinct from the urgency red alerts.
- **Border:** 1px `{colors.primary}` Earth Green left-rail accent.

### Impact Numbers Block

**`impact-block`** — Used in the Impact Report page and the year-end Climate Journey Card. Three or four stat columns side by side.

- **Number:** `{typography.number-display}` (48px / 700) in the relevant semantic color — Earth Green for saved produce and CO₂, Ink for donor count, CO2 Teal for environmental data.
- **Unit:** `{typography.body-sm}` muted immediately below the number ("kg 구제", "명 참여", "톤 CO₂ 절감").
- **Dividers:** 1px `{colors.hairline}` between columns.

### Checklist Row (Farm App)

**`checklist-row`** — Used in the Farm app's danger/emergency state home screen.

- **Container:** Full-width row, 16px vertical padding, 1px bottom `{colors.hairline}`.
- **Checkbox:** 24×24px rounded square (`{rounded.sm}`) — unchecked: `{colors.hairline}` stroke, white fill; checked: Earth Green fill, white checkmark.
- **Label:** `{typography.body-md}` ink ("환풍기 최대 가동 확인"). Checked state: `{colors.muted}` text with strikethrough.
- **Completion tag:** When all items checked, a full-width "체크리스트 완료 ✓" success banner in `{colors.primary-light}` background, Earth Green text.

### Top Navigation (Web)

**`top-nav`** — Warm off-white surface (#fafaf8), 72px height, 1px bottom `{colors.hairline}`. Give On wordmark (Earth Green logotype) flush left. Center: filter/category tabs (전체 / 폭염 · 가뭄 / 한파 / 우박). Right: "내 기부 내역" link + account avatar.

**`nav-disaster-banner`** — A full-width slim banner (44px height) that appears above the top nav only when an active disaster is ongoing. `{colors.surface-dark}` background, `{colors.on-dark}` text. "🔴 경북 청송 폭염 특보 발령 중 — 지금 기부하기 →" in `{typography.body-sm}`. Dismissable.

### Bottom Navigation (Farm iOS App)

**`bottom-nav-farm`** — iOS standard bottom tab bar. White surface, 1px top `{colors.hairline}`. Four tabs: 홈 / 경보 이력 / 못난이 등록 / 설정. Active tab: Earth Green icon + label. Inactive: muted icon + label.

**`bottom-bar-donation`** — Sticky bottom bar on campaign detail on mobile (mirrors Airbnb's mobile reservation bar). White surface, 1px top hairline, 16px padding. Left: price summary ("3만원 → 사과 2kg"). Right: "기부하기" `{component.button-primary}` (Earth Green pill, 48px height, 160px width).

### Ugly Produce Registration (Farm App)

**`produce-registration-card`** — The multi-step form for registering damaged produce.

- **Step indicator:** Horizontal step dots at top (3 steps: 작물 정보 / 사진 등록 / 확인).
- **Photo upload zone:** `{rounded.lg}` 16px, `{colors.surface-soft}` fill, dashed `{colors.hairline}` border, centered camera icon in `{colors.muted}`. Up to 5 photos.
- **Produce type selector:** Horizontal scroll of icon + label pills (사과 / 감자 / 배 / 기타).
- **Quantity input:** Numeric input with kg unit label, `{component.text-input}` style.
- **Submit CTA:** "기부 답례품으로 등록하기" `{component.button-primary}` full-width.

### Admin Dashboard

**`admin-risk-map`** — Full-width map panel (카카오맵) with color-coded farm markers using risk-level token colors. Urgency-level farms pulse. Filter controls float top-left.

**`admin-campaign-queue`** — A list of `pending_approval` campaigns. Each row: campaign type badge / region / urgency score chip / "승인" Earth Green button / "반려" outlined button.

**`admin-stat-row`** — A horizontal row of 4 summary stat cards at the top of the dashboard. Each card: `{colors.surface-soft}` background, stat number in `{typography.display-sm}` ink, label in `{typography.body-sm}` muted. ("오늘 위험 농가 23곳 / 못난이 등록 8건 / 진행 캠페인 12건 / 이번 주 기부액 4.2백만원").

### Footer

**`footer`** — `{colors.surface-warm}` (#e8e5e0) background — the only non-canvas surface in the footer band, providing a subtle warm separator from the page content. Three link columns (서비스 / 농가 파트너 / 회사). Earth Green wordmark left-aligned. CO₂ impact running total ("지금까지 xxx톤 CO₂ 절감에 기여했습니다") displayed as a prominent footer headline in `{typography.display-sm}` Earth Green.

---

## Responsive Behavior

| Breakpoint | Width | Key Changes |
|---|---|---|
| Mobile | < 768px | Top nav: logo + hamburger. Disaster banner stays full width. Campaign grid 1-column. Campaign detail: sticky bottom donation bar replaces right-rail panel. Farm app: native iOS layout, full-bleed risk indicator. |
| Tablet | 768–1128px | Campaign grid 2-column. Top nav shows category tabs but collapses account area. Campaign detail: donation panel narrows to 40% width. |
| Desktop | 1128–1440px | Full 3-column campaign grid. Full top nav. Campaign detail 2-column with sticky right-rail donation panel. Admin dashboard with left sidebar. |
| Wide | > 1440px | Content caps at 1280px. Gutters absorb the rest. |

### Touch Targets

- Primary CTAs minimum 48×48px (WCAG AAA).
- Checklist checkboxes 44×44px tap target (24px visual + 10px padding each side).
- Risk indicator — the entire top card section is tappable for drill-down. Minimum 200px height.
- Bottom nav tabs: 64px height, equal-width segments.

---

## Screens to Design

The following screens represent the complete MVP surface area. Design all screens at 375px (iPhone 14) for mobile and 1440px for desktop web.

### Give On Farm (iOS App) — 6 Screens

1. **Onboarding** — Farm registration flow: location map picker + livestock type grid + count input. Step indicator top. Earth Green CTA.
2. **Home — Safe State** — Risk indicator (green circle, "안전"), today's weather stats, morning briefing message, "못난이 등록" banner (collapsed/passive), bottom nav.
3. **Home — Danger State** — Risk indicator (orange/red), Claude alert message, checklist rows (2–3 items), "피해 신고" CTA bottom. Background: `{colors.urgency-light}` tint behind the risk card.
4. **Home — Emergency State** — Full-screen `{colors.surface-dark}` background, pulsing red risk circle, bold alert message, "즉시 확인" `{component.button-urgency}` CTA.
5. **Ugly Produce Registration** — 3-step form: photo upload zone + produce type pills + quantity input. Step dots top. "기부 답례품으로 등록하기" CTA.
6. **Damage Report** — Simple form: dead count input + cause selector (폭염/한파/우박) + farmer note textarea + preview of AI-generated story. "공개 동의 후 등록" CTA.

### Give On Web — 8 Screens

7. **Main — No Active Disaster** — Top nav + hero ("기후 재난을 함께 극복해요" headline + sub-copy) + campaign grid (3-col, mixed urgency levels). Filter strip below nav.
8. **Main — Active Disaster** — Same as above but with `{component.nav-disaster-banner}` at top. First campaign card row shows `{component.campaign-card-urgent}` variants.
9. **Campaign Detail — Ugly Produce** — Hero produce photo (16:9) + farmer caption + Claude story (3–4 paragraphs) + climate score timeline + donation panel (right rail). Produce photos scroll gallery below story.
10. **Campaign Detail — Farm Alert** — Same layout but with the cattle/livestock framing: risk level badge + weather stats at top of story instead of produce photos.
11. **Donation Complete** — Full-screen confirmation: Earth Green checkmark animation + "청송 사과 2kg 박스가 배송될 예정입니다" + climate score preview + SNS share row + "다른 농가 돕기" CTA.
12. **Gratitude Photo Notification** — Notification center page showing a `{component.gratitude-photo-card}` alongside other activity. Also: the push notification banner preview at top.
13. **Impact Report** — Personal impact page: `{component.impact-block}` with 3 numbers (기부금 / 구제 농산물 / CO₂ 절감) + climate score timeline for each supported farm + "기후 여정 카드" year-end share panel.
14. **Climate Journey Card** — Year-end shareable card (1080×1080px, Instagram-optimized). Dark green (`{colors.surface-dark}`) background, white/off-white text. Impact numbers in `{typography.number-display}`. "A님의 2026년 기후 여정" title. Give On wordmark bottom-right.

### Give On Admin (PWA) — 3 Screens

15. **Admin Dashboard** — Left sidebar nav (240px) + top stat row (4 cards) + main area split: risk map (left, 60%) + campaign approval queue (right, 40%).
16. **Campaign Approval Detail** — Full-width view of a `pending_approval` campaign draft: preview of Claude-generated story + produce photo + urgency score breakdown + "승인" / "반려" CTAs.
17. **Delivery Management** — Table view of active donations with delivery status pipeline (기부완료 → 배송준비 → 배송중 → 도착확인). Status chips use risk-level color tokens (repurposed as pipeline stages).

---

## Stitch Prompt Notes

When generating screens in Stitch, apply the following directives:

- **Always specify the canvas color as #fafaf8**, not pure white. This is non-negotiable — pure white will flatten the warmth of the produce photography.
- **Use Earth Green (#2d6a4f) for all primary actions.** Do not substitute teal, olive, or lime. The specific depth of this forest green is intentional.
- **Harvest Red (#e63946) appears only on urgency/disaster elements.** If Stitch places it on decorative elements or general buttons, override it.
- **Produce photos must be realistically imperfect.** Request photos of actual damaged fruit with visible scarring, irregular sizing, or discoloration. Do not generate idealized produce.
- **Korean text is primary.** All UI labels, button text, and microcopy should be in Korean. English appears only in the Admin interface section headers and in code/technical contexts.
- **The risk indicator on the Farm app home screen should dominate the upper 40% of the viewport.** Do not reduce it to a small chip or badge — it is the primary communication of the app.
- **Never use gradients** except inside the Climate Journey Card background (a subtle dark-green-to-black radial for depth).
- **Round all primary CTAs to full pill shape.** Do not use square or lightly-rounded buttons for the main "기부하기" action.
