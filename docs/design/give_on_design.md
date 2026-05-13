# Give On — Design System Guide

## Overview

Give On is a climate-disaster response donation platform that connects citizens with affected farmers through AI-generated campaigns and delivers ugly produce as tangible rewards. The design language must carry three emotional registers simultaneously: **urgency** (climate disaster is happening now), **warmth** (a real farmer is waiting), and **trust** (your money becomes real food on your table).

The base canvas is **soft neutral light** (`{colors.canvas}` — #f7f8fa) rather than warm beige or pure white. This follows the visual clarity of modern Korean mobile products such as Toss: bright, quiet, and highly legible, while still letting produce photography carry warmth. The primary accent is **Fresh Green** (`{colors.primary}` — #1f7a5a), a cleaner and more contemporary green that feels trustworthy without making the app look heavy. A single urgency accent, **Signal Red** (`{colors.urgency}` — #e5484d), is reserved exclusively for disaster alerts, emergency risk indicators, and time-sensitive campaign banners. It never appears on decorative elements.

Type runs **Pretendard** (the standard Korean-language variable font), falling back to **Noto Sans KR** and the system stack. Korean-first typography means line-heights run slightly looser than Latin-only systems — body copy sits at 1.7 rather than Airbnb's 1.5 to accommodate Hangul stroke density.

The shape language is **clean, quiet, and product-like**. It should feel closer to Toss than to a lifestyle campaign site. Campaign cards use 16px radius (`{rounded.md}`), selection cards and panels use 20px (`{rounded.lg}`), and small controls use 12px (`{rounded.sm}`). Full pill shapes (`{rounded.full}`) are reserved for badges and compact chips. Large app CTAs should prefer rounded rectangles over pills to avoid a dated or overly soft impression.

**Key Characteristics:**
- Dual-accent system: `{colors.primary}` (#1f7a5a Fresh Green) for all positive actions and brand moments. `{colors.urgency}` (#e5484d Signal Red) exclusively for disaster urgency signals. They never appear together on the same element.
- Korean-first typography: `Pretendard` variable font. Body at 16px / 400 / line-height 1.7. Display at 24–32px / 700. Modest weights — visual hierarchy comes from the produce photography and farmer portraits, not typographic muscle.
- Photo-led campaign cards: the ugly produce photograph is the emotional anchor of every donation card. The design system trusts the imperfect textures of hail-scarred apples and sun-scorched peppers to carry visual weight. Never crop or filter produce photos — raw imperfection is the point.
- Risk level traffic light: the four-state risk indicator (safe / caution / danger / emergency) is the signature UI element of the Farm app. Color-coded with semantic tokens (`{colors.risk-safe}`, `{colors.risk-caution}`, `{colors.risk-danger}`, `{colors.risk-emergency}`), it must be immediately legible at a glance from across a room — it is a life-and-limb signal for farmers.
- Climate score timeline: a horizontal progress visualization showing a farm's risk journey from disaster to recovery. Uses the risk-level color tokens as data ink.
- Elevation at one tier: a single soft shadow (`box-shadow: rgba(0,0,0,0.04) 0 1px 3px, rgba(0,0,0,0.08) 0 4px 12px`) used on campaign cards on hover, the sticky reservation/donation panel, and the mobile bottom bar. No progressive depth — surfaces are either flat or floating.

---

## Colors

### Brand & Accent

- **Fresh Green** (`{colors.primary}` — #1f7a5a): The single brand color. Used for primary CTA backgrounds, active navigation, selected cards, key progress fill, and the Give On wordmark. Use it sparingly so the interface stays calm.
- **Fresh Green Active** (`{colors.primary-active}` — #176448): Press / pointer-down variant.
- **Fresh Green Disabled** (`{colors.primary-disabled}` — #b8d8cd): Muted green tint on disabled CTAs.
- **Fresh Green Tint** (`{colors.primary-light}` — #ecf7f2): Very light green surface used for selected cards, positive state panels, and completion chips.
- **Signal Red** (`{colors.urgency}` — #e5484d): Urgency-only accent. Applied exclusively to disaster alerts, emergency risk indicators, and urgent campaign signals. Never used decoratively.
- **Signal Red Tint** (`{colors.urgency-light}` — #feeeef): Pale urgency tint for inline alert cards and emergency background panels.
- **Amber Warning** (`{colors.warning}` — #ffb020): Warning state between safe and danger. Slightly cleaner and brighter than the previous earthy amber.
- **Amber Light** (`{colors.warning-light}` — #fff6df): Background fill for caution-level alert panels.

### Risk Level (Farm App Signature)

- **Risk Safe** (`{colors.risk-safe}` — #22a06b): Clean green. "안전" state indicator.
- **Risk Caution** (`{colors.risk-caution}` — #ffb020): Clean amber. "주의" state.
- **Risk Danger** (`{colors.risk-danger}` — #ff7a45): Bright orange-red. "위험" state.
- **Risk Emergency** (`{colors.risk-emergency}` — #e5484d): Full Signal Red. "긴급" state. Pulses on animation.

### Surface

- **Canvas** (`{colors.canvas}` — #f7f8fa): Primary app and web background. Clean and bright, similar to modern finance and utility apps.
- **Surface Soft** (`{colors.surface-soft}` — #f2f4f6): Default soft fill for segmented controls, disabled fields, grouped sections, and admin rows.
- **Surface Warm** (`{colors.surface-warm}` — #eef1f4): Neutral supporting surface for footer bands or sub-panels. Keep warmth through photography and copy, not beige chrome.
- **Surface Card** (`{colors.surface-card}` — #ffffff): Default card and sheet background.
- **Surface Dark** (`{colors.surface-dark}` — #191f28): Dark neutral surface used in emergency full-screen warnings and high-contrast overlays.

### Hairlines & Borders

- **Hairline** (`{colors.hairline}` — #e5e8eb): Default 1px border.
- **Hairline Soft** (`{colors.hairline-soft}` — #eef1f4): Lighter divider for long sections.
- **Border Strong** (`{colors.border-strong}` — #c9ced6): Heavier stroke for focus states and grouped controls.

### Text

- **Ink** (`{colors.ink}` — #191f28): Primary text.
- **Body** (`{colors.body}` — #4e5968): Secondary running text.
- **Muted** (`{colors.muted}` — #8b95a1): Metadata and inactive labels.
- **Muted Soft** (`{colors.muted-soft}` — #b0b8c1): Disabled text and placeholders.
- **On Primary** (`{colors.on-primary}` — #ffffff): White text on Fresh Green CTAs.
- **On Urgency** (`{colors.on-urgency}` — #ffffff): White text on Signal Red alert elements.
- **On Dark** (`{colors.on-dark}` — #ffffff): High-contrast text on `{colors.surface-dark}` emergency surfaces.

### Semantic

- **Error** (`{colors.error}` — #d92d20): Form validation errors.
- **Success** (`{colors.success}` — #1f7a5a): Used for "배송 완료", "복구 완료" confirmation states.
- **CO2 Blue** (`{colors.co2}` — #3182f6): Environmental data accent used only in CO₂ impact visualization.

### Visual Direction Update

The interface should move away from earthy, heavy, dark-green UI chrome and toward a **Toss-like clarity model**:

- Use neutral backgrounds and white cards as the default.
- Let green appear as a precise action and selection color, not as a large background fill.
- Avoid emoji-heavy UI as the primary visual language. Use simple line icons, small illustrated glyphs, or restrained pictograms instead.
- Reduce decorative borders, dashed boxes, and oversized segmented pills.
- Favor card grouping, thin dividers, and quiet hierarchy over saturated color blocks.

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

### Mobile-first Web Strategy

The public Give On Web experience is designed mobile-first. Desktop is an expanded layout, not the primary layout. Users are expected to arrive through mobile web links, disaster alerts, SNS shares, and quick payment flows, so the core donation journey must complete comfortably on a phone.

**Mobile-first priorities:**
- Disaster state and campaign title must be visible within the first screen.
- The primary CTA must be sticky or repeated at key scroll points.
- Campaign cards must work as single-column, photo-first cards.
- Campaign detail pages replace the desktop donation rail with a sticky bottom donation bar.
- Amount selection defaults to the recommended tier, usually 30,000 KRW.
- Long campaign stories should be shortened by default and expanded progressively.
- Impact numbers should stack vertically on mobile before introducing horizontal scroll.
- All touch targets must be at least 48px high.

### Spacing System

- **Base unit:** 4px.
- **Tokens:** `{spacing.xxs}` 2px · `{spacing.xs}` 4px · `{spacing.sm}` 8px · `{spacing.md}` 12px · `{spacing.base}` 16px · `{spacing.lg}` 24px · `{spacing.xl}` 32px · `{spacing.xxl}` 48px · `{spacing.section}` 64px · `{spacing.section-lg}` 80px.
- **Section vertical padding:** `{spacing.section}` (64px) for the main hero and editorial bands. `{spacing.section-lg}` (80px) for the Climate Journey Card and Impact Report sections where impact numbers need breathing room.
- **Campaign card internal:** `{spacing.base}` (16px) for photo-to-meta gap; `{spacing.lg}` (24px) for internal card padding on the detail panel; `{spacing.sm}` (8px) for meta row gutters.
- **Farm App:** `{spacing.lg}` (24px) between major home-screen sections; `{spacing.base}` (16px) between checklist rows; `{spacing.sm}` (8px) between stat chips.

### Grid & Container

- **Mobile web width:** Design first at 375px and verify at 390px, 430px, and 768px. The 375px layout is the source of truth for public web screens.
- **Max content width:** 1280px centered on desktop. Campaign detail pages cap at 1080px only after the mobile layout is complete.
- **Campaign grid (web):** 1-column on mobile, 2-column at tablet, 3-column at desktop (1128px+). Mobile card spacing is 16px; desktop gutters are 24px.
- **Campaign detail:** Mobile uses a single-column story flow with a sticky bottom donation bar. Desktop expands into a 2-column layout — photo + story body on the left (~60%), sticky donation panel on the right (~36%).
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

## Interaction States

State rules must be consistent across web, app, and admin surfaces. Default visuals are intentionally calm; changes in state should be communicated through contrast, border strength, motion, and copy rather than excessive color noise.

### Global State Principles

- **Default:** Flat or lightly bordered surface with clear text hierarchy.
- **Hover (web only):** Slight shadow reveal or border emphasis. Do not shift layout.
- **Pressed:** Color deepens to the active token. No scale-down animation on urgent elements.
- **Focus-visible:** 2px outline using `{colors.border-strong}` outside the component bounds. Never rely on color fill alone.
- **Selected:** Use fill change plus icon/check or weight change. Selection must remain legible without color perception.
- **Disabled:** Lower contrast using `{colors.primary-disabled}` or `{colors.muted-soft}`; never reduce opacity below readable levels for text.
- **Loading:** Preserve layout with inline spinner or skeleton. Avoid swapping the whole screen to a blank loader.
- **Empty:** Empty states should explain the situation and suggest one next action.
- **Error:** Use `{colors.error}` for validation and blocking form states only. Do not reuse urgency red.
- **Success:** Use `{colors.success}` or `{colors.primary-light}` for completion, delivery, and checklist-confirmed states.

### Component State Requirements

- **Buttons:** Define default / hover / pressed / focus / disabled / loading for all button types.
- **Inputs:** Define resting / focus / filled / error / disabled / success.
- **Campaign cards:** Define default / hover / saved / urgent / completed / skeleton.
- **Badges and chips:** Define selected and unselected states with both color and border or icon difference.
- **Bottom donation bar:** Define sticky resting, expanded summary, and submitting-payment states.

---

## Motion

Motion should reinforce urgency and clarity, not decoration. The system uses a small number of meaningful transitions to guide attention through risk recognition, donation, and confirmation.

### Motion Principles

- Use motion only when it helps explain status, hierarchy, or next action.
- Keep standard transitions calm and short. Reserve stronger motion for emergency alerts and successful completion.
- Avoid springy or playful movement on disaster-related surfaces.

### Motion Tokens

- **Fast UI transition:** 160ms, ease-out.
- **Standard panel / chip transition:** 220ms, ease-out.
- **Modal / bottom sheet enter:** 280ms, ease-out.
- **Success confirmation:** 420ms, ease-out.
- **Emergency pulse:** 1.5s, ease-in-out, repeating.

### Required Motion Moments

- **Risk emergency pulse:** The red risk circle in the Farm emergency state pulses subtly in scale and shadow.
- **Sticky donation bar reveal:** On mobile detail pages, the bar should slide up once the page settles and remain stable during scroll.
- **Donation completion:** Earth Green confirmation icon animates once, then rests. Do not loop success animation.
- **Timeline progression:** Climate score nodes may fade or reveal left-to-right when the section first enters view.
- **Skeleton loading:** Use soft shimmer or fade, never bright gradients.

---

## Components

### Buttons

**`button-primary`** — Fresh Green fill (#1f7a5a), white text, 16px / 600 label, 54px height, 20px radius for app flows and `{rounded.full}` pill only for compact web CTAs. Primary CTAs: "기부하기", "등록하기", "경보 확인".

**`button-primary-active`** — Background to `{colors.primary-active}` (#176448). No transform.

**`button-primary-disabled`** — `{colors.primary-disabled}` (#b8d8cd) fill, white text, cursor not-allowed.

**`button-secondary`** — White fill, `{colors.ink}` text, 1px `{colors.hairline}` border, 16px radius, 52px height. Used for "나중에", "자세히 보기", modal cancel.

**`button-urgency`** — Signal Red fill (#e5484d), white text, 16px radius, 54px height. Reserved exclusively for "긴급 경보 확인" and "지금 바로 기부" on disaster-alert modals.

**`button-tertiary-text`** — Fresh Green text, no surface, underlined on hover. "더 보기", "전체 보기", modal close labels.

**`button-pill-filter`** — White fill, 1px hairline border, `{rounded.full}`, 36px height, 14px / 500 label. Selected state uses white fill with stronger border and text color rather than a solid saturated background.

### Segmented Controls

**`segmented-control`** — Replaces the oversized dark-green onboarding toggle. Use a quiet grouped control similar to Toss tabs.

- Container: `{colors.surface-soft}` background, 60px height, 18px radius, 4px internal padding.
- Active segment: white surface with subtle shadow and `{colors.ink}` text, not a solid green slab.
- Inactive segment: transparent background with `{colors.muted}` text.
- Accent usage: green appears only as a small leading icon tint, underline, or 2px active indicator.
- Labels: icon + text optional, but icons should be restrained and secondary.

### Form Controls

**`text-input`** — 56px min height, `{colors.surface-card}` or `{colors.surface-soft}` background depending on context, 1px `{colors.hairline}` border, 16px radius, 16px horizontal padding, `{typography.body-md}` text.

- **Focus:** 2px outer ring with `{colors.border-strong}` and border shift to `{colors.primary}`.
- **Error:** Border and helper text use `{colors.error}`.
- **Disabled:** `{colors.surface-soft}` background, `{colors.muted-soft}` text, non-interactive cursor.
- **Placeholder:** `{colors.muted-soft}` only; never use placeholder as the sole label.

**`textarea`** — Same visual rules as `text-input`, 120px minimum height, resize disabled on mobile.

**`select-pill-group`** — Horizontal or wrapped selection pills for produce type, disaster cause, or amount tiers. Selected state must use fill and checkmark or weight change.

**`helper-text`** — `{typography.caption-sm}` below a field. Default muted, error in `{colors.error}`, success in `{colors.success}`.

### Selection Cards

**`selection-card`** — Replaces emoji-first farm-type tiles. Used for livestock, crop, and other onboarding choices.

- Layout: white card, 20px radius, 1px `{colors.hairline}` border, 16px padding, minimum 120px height.
- Content: small icon or simple illustration at top, label below in `{typography.title-sm}`.
- Default: white card with neutral border.
- Selected: `{colors.primary-light}` tint background, 2px `{colors.primary}` border, optional top-right check icon.
- Avoid giant emoji centered alone. If emojis are used in mocks, treat them as placeholders only.
- Two-column grid on mobile with generous spacing; cards should feel like option sheets, not buttons.

### Form System Rules

- Every field must include a visible label above or beside the field.
- Required fields use text labels like "필수" rather than an asterisk alone.
- Validation should trigger on blur and on submit, not on every keystroke for mobile.
- Error copy must explain how to fix the issue, not just state that it failed.
- Multi-step forms must show current step, total step count, and save entered values during back navigation.
- Custom entry actions such as "직접 입력" should use a secondary card button or bottom sheet trigger, never a dashed empty placeholder box in the main layout.

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
- **Urgency badge** (`{component.urgency-badge}`): Pill badge. "긴급" in Signal Red / "진행중" in Fresh Green / "마감 임박" in Amber.
- **Heart/save:** `{component.icon-button-circle}` top-right. Outlined by default, Fresh Green filled when saved.
- **Meta block:** 16px padding beneath photo. Campaign title in `{typography.display-md}` ink (2 lines max). Region + cause + remaining quantity in `{typography.body-sm}` muted ("경북 청송 · 우박 · 사과 200kg 남음"). Progress bar showing funding completion in Earth Green. "3만원 · 2kg 박스 직배송" price summary right-aligned in `{typography.body-sm}` ink.

**`campaign-card-urgent`** — Same structure as `campaign-card` but with a 2px Signal Red top border and a full-width `{colors.urgency-light}` tint behind the meta block. Used for AI-auto-generated campaigns with urgency score ≥ 7.

### Campaign Detail Panel

**`donation-panel`** — Sticky right-rail panel (mirrors Airbnb's `{component.reservation-card}`). White surface, `{rounded.md}` 12px, 1px `{colors.hairline}` border, card-float shadow, 24px padding.

Contents (top to bottom):
1. Amount selector — three pill buttons (1만원 / 3만원 / 5만원) + free-input field. Active pill: Fresh Green fill, white text.
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
- **Background:** `{colors.primary-light}` tint — a clean green "good news" surface distinct from urgency alerts.
- **Border:** 1px `{colors.primary}` Fresh Green left-rail accent.

### Impact Numbers Block

**`impact-block`** — Used in the Impact Report page and the year-end Climate Journey Card. Three or four stat columns side by side.

- **Number:** `{typography.number-display}` (48px / 700) in the relevant semantic color — Fresh Green for saved produce, Ink for donor count, CO2 Blue for environmental data.
- **Unit:** `{typography.body-sm}` muted immediately below the number ("kg 구제", "명 참여", "톤 CO₂ 절감").
- **Dividers:** 1px `{colors.hairline}` between columns.

### Checklist Row (Farm App)

**`checklist-row`** — Used in the Farm app's danger/emergency state home screen.

- **Container:** Full-width row, 16px vertical padding, 1px bottom `{colors.hairline}`.
- **Checkbox:** 24×24px rounded square (`{rounded.sm}`) — unchecked: `{colors.hairline}` stroke, white fill; checked: Fresh Green fill, white checkmark.
- **Label:** `{typography.body-md}` ink ("환풍기 최대 가동 확인"). Checked state: `{colors.muted}` text with strikethrough.
- **Completion tag:** When all items checked, a full-width "체크리스트 완료 ✓" success banner in `{colors.primary-light}` background, Fresh Green text.

### Top Navigation (Web)

**`top-nav`** — Neutral light surface using `{colors.canvas}`, 72px height, 1px bottom `{colors.hairline}`. Give On wordmark (Fresh Green logotype) flush left. Center: filter/category tabs (전체 / 폭염 · 가뭄 / 한파 / 우박). Right: "내 기부 내역" link + account avatar.

**`nav-disaster-banner`** — A full-width slim banner (44px height) that appears above the top nav only when an active disaster is ongoing. `{colors.surface-dark}` background, `{colors.on-dark}` text. "🔴 경북 청송 폭염 특보 발령 중 — 지금 기부하기 →" in `{typography.body-sm}`. Dismissable.

### Bottom Navigation (Farm iOS App)

**`bottom-nav-farm`** — iOS standard bottom tab bar. White surface, 1px top `{colors.hairline}`. Four tabs: 홈 / 경보 이력 / 못난이 등록 / 설정. Active tab: Fresh Green icon + label. Inactive: muted icon + label.

**`bottom-bar-donation`** — Sticky bottom bar on campaign detail on mobile. White surface, 1px top hairline, 16px padding. Left: price summary ("3만원 → 사과 2kg"). Right: "기부하기" `{component.button-primary}` (Fresh Green CTA, 54px height, minimum 144px width).

### Ugly Produce Registration (Farm App)

**`produce-registration-card`** — The multi-step form for registering damaged produce.

- **Step indicator:** Horizontal step dots at top (3 steps: 작물 정보 / 사진 등록 / 확인).
- **Photo upload zone:** `{rounded.lg}` 16px, `{colors.surface-soft}` fill, dashed `{colors.hairline}` border, centered camera icon in `{colors.muted}`. Up to 5 photos.
- **Produce type selector:** Horizontal scroll of icon + label pills (사과 / 감자 / 배 / 기타).
- **Quantity input:** Numeric input with kg unit label, `{component.text-input}` style.
- **Submit CTA:** "기부 답례품으로 등록하기" `{component.button-primary}` full-width.

### Onboarding Pattern (Farm App)

The current onboarding must be redesigned to feel cleaner and more premium, with the clarity of Toss and the warmth of a civic service product.

**Screen structure:**
- Top: compact progress indicator with small neutral dots and a short step label.
- Header: concise title and one-line helper copy.
- Type switch: quiet segmented control for `가축` / `농작물`.
- Choice area: selection cards with simple icons and clear labels.
- Input area: a grouped card for quantity or scale input.
- Bottom: fixed primary CTA with safe-area padding.

**Specific UI corrections for the current screen:**
- Do not fill the active `가축` tab with a large dark green pill. Use a white active segment on a soft gray track.
- Replace the large centered emojis with cleaner icons or smaller illustrative marks.
- Change livestock options from thin outlined boxes to substantial white cards with better spacing and selected-state contrast.
- Replace the dashed `+ 직접 입력` area with a secondary action card or bottom-sheet trigger button.
- Change the quantity field from a bare underline to a full input card with label, value, and unit.
- Use a bottom-fixed CTA with 16px radius instead of a long heavy pill button.
- Reduce visible color usage on the onboarding screen to mostly neutral surfaces plus one selected accent.

**Recommended copy hierarchy:**
- Step label: `1/3 농장 정보`
- Title: `무엇을 키우고 계신가요?`
- Helper: `가축 또는 농작물을 선택하면 다음 단계에서 자세히 등록할 수 있어요.`
- Field label: `축종`
- Quantity label: `사육 두수`

### Admin Dashboard

**`admin-risk-map`** — Full-width map panel (카카오맵) with color-coded farm markers using risk-level token colors. Urgency-level farms pulse. Filter controls float top-left.

**`admin-campaign-queue`** — A list of `pending_approval` campaigns. Each row: campaign type badge / region / urgency score chip / "승인" Earth Green button / "반려" outlined button.

**`admin-stat-row`** — A horizontal row of 4 summary stat cards at the top of the dashboard. Each card: `{colors.surface-soft}` background, stat number in `{typography.display-sm}` ink, label in `{typography.body-sm}` muted. ("오늘 위험 농가 23곳 / 못난이 등록 8건 / 진행 캠페인 12건 / 이번 주 기부액 4.2백만원").

### Admin Operating UI

**`admin-table`** — Desktop-first table component for delivery, campaign approval, and farm status management.

- Header row: `{colors.surface-soft}` background, `{typography.caption}` or `{typography.body-sm}` labels.
- Row height: 56px minimum.
- Zebra striping: optional using `{colors.surface-soft}` at low contrast.
- Sticky header: recommended for long delivery lists.
- First action should always be visible without horizontal scroll on tablet.

**`admin-filter-bar`** — A compact control row for date range, risk level, status, and region filters. Use pills for quick filters and selects for dense options.

**`status-chip`** — Reusable small chip for `pending_approval`, `approved`, `rejected`, `배송준비`, `배송중`, `도착확인`.

- Pending: warm neutral or amber tint.
- Approved / complete: green tint.
- Rejected / blocked: error tint.
- In transit: neutral outline with darker text.

**`empty-state-panel`** — Used when there are no urgent farms, no pending campaigns, or no active deliveries. Includes one sentence of explanation and one action button such as "전체 농가 보기" or "새 캠페인 생성".

### Footer

**`footer`** — `{colors.surface-warm}` background — a quiet neutral separator from the page content. Three link columns (서비스 / 농가 파트너 / 회사). Fresh Green wordmark left-aligned. CO₂ impact running total ("지금까지 xxx톤 CO₂ 절감에 기여했습니다") displayed as a prominent footer headline in `{typography.display-sm}` Fresh Green.

---

## Responsive Behavior

| Breakpoint | Width | Key Changes |
|---|---|---|
| Mobile S | 360–374px | Single-column layout. Compact typography where needed. Disaster banner uses one-line truncation with CTA arrow. Bottom donation bar is mandatory on detail pages. |
| Mobile M/L | 375–430px | Primary design target. Campaign cards are photo-first, one-column, 16px page gutters. Amount selector and CTA must fit without horizontal scrolling. |
| Tablet | 768–1128px | Campaign grid 2-column. Top nav may reveal category tabs. Campaign detail can keep mobile-style bottom CTA or introduce a narrow donation panel depending on available height. |
| Desktop | 1128–1440px | Full 3-column campaign grid. Full top nav. Campaign detail 2-column with sticky right-rail donation panel. Admin dashboard with left sidebar. |
| Wide | > 1440px | Content caps at 1280px. Gutters absorb the rest. |

### Mobile Web Screen Rules

- Public web screens must be designed at **375px first**.
- Desktop mockups are secondary and should be derived from the mobile structure.
- Primary CTA must appear within the first meaningful interaction zone and again as a sticky bottom CTA where conversion matters.
- Hero sections on mobile should prioritize: disaster state → campaign title → produce image → CTA.
- Long campaign stories should use progressive disclosure: first 2–3 lines visible, then "더 읽기".
- Horizontal scroll may be used for filter chips and photo thumbnails, but not for core donation content.

### Web and Native App Differences

- **Web:** More editorial and conversion-focused. Sticky CTA, story flow, donation tiers, and impact proof are primary.
- **Farm iOS App:** Faster operational scanning. Risk signal, checklist, and alert actions are primary; copy must be shorter and more directive.
- **Admin PWA:** Density is acceptable when it improves decision-making. Tables, filters, and queues may be tighter than public web surfaces.
- Shared tokens should stay consistent, but navigation patterns should follow platform expectations rather than forcing one layout language across all surfaces.

### Touch Targets

- Primary CTAs minimum 48×48px (WCAG AAA).
- Checklist checkboxes 44×44px tap target (24px visual + 10px padding each side).
- Risk indicator — the entire top card section is tappable for drill-down. Minimum 200px height.
- Bottom nav tabs: 64px height, equal-width segments.

---

## Screens to Design

The following screens represent the complete MVP surface area. Design all screens at 375px (iPhone 14) for mobile and 1440px for desktop web.

### Give On Farm (iOS App) — 6 Screens

1. **Onboarding** — Farm registration flow redesigned with Toss-inspired clarity: compact step dots, neutral segmented control, white selection cards, full input fields, and fixed bottom CTA. Avoid emoji-first or dark-green-heavy UI.
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
11. **Donation Complete** — Full-screen confirmation: Fresh Green checkmark animation + "청송 사과 2kg 박스가 배송될 예정입니다" + climate score preview + SNS share row + "다른 농가 돕기" CTA.
12. **Gratitude Photo Notification** — Notification center page showing a `{component.gratitude-photo-card}` alongside other activity. Also: the push notification banner preview at top.
13. **Impact Report** — Personal impact page: `{component.impact-block}` with 3 numbers (기부금 / 구제 농산물 / CO₂ 절감) + climate score timeline for each supported farm + "기후 여정 카드" year-end share panel.
14. **Climate Journey Card** — Year-end shareable card (1080×1080px, Instagram-optimized). Dark green (`{colors.surface-dark}`) background, white/off-white text. Impact numbers in `{typography.number-display}`. "A님의 2026년 기후 여정" title. Give On wordmark bottom-right.

### Give On Admin (PWA) — 3 Screens

15. **Admin Dashboard** — Left sidebar nav (240px) + top stat row (4 cards) + main area split: risk map (left, 60%) + campaign approval queue (right, 40%).
16. **Campaign Approval Detail** — Full-width view of a `pending_approval` campaign draft: preview of Claude-generated story + produce photo + urgency score breakdown + "승인" / "반려" CTAs.
17. **Delivery Management** — Table view of active donations with delivery status pipeline (기부완료 → 배송준비 → 배송중 → 도착확인). Status chips use risk-level color tokens (repurposed as pipeline stages).

---

## Core User Flows

The design system must support these MVP flows without requiring extra navigation invention during implementation.

### Citizen Donation Flow

1. User sees disaster signal or campaign card.
2. User opens campaign detail and understands the situation within one screen.
3. User selects or confirms a recommended amount.
4. User completes donation.
5. User sees reward, delivery expectation, and impact confirmation.
6. User later receives gratitude photo or impact update.

### Farmer Response Flow

1. Farmer opens the app and checks current risk level.
2. Farmer reads the AI briefing and immediate checklist.
3. Farmer records damage or registers ugly produce.
4. Farmer reviews AI-generated public story preview.
5. Farmer submits with consent and receives status follow-up.

### Admin Approval Flow

1. Admin identifies urgent farms on the risk map or queue.
2. Admin opens a pending campaign.
3. Admin reviews story, produce image, urgency score, and source data.
4. Admin approves or rejects with a clear next action.
5. Admin tracks delivery progress until donation outcome is complete.

---

## Copy Tone

Copy should be direct, warm, and trustworthy. It should sound like a calm coordinator, not a fundraising slogan generator.

- Prefer short Korean sentences over dramatic or poetic phrasing.
- Urgency copy should explain what is happening now and what action is needed.
- Donation copy should connect amount, produce, and delivery outcome in one sentence.
- Success copy should confirm the result clearly before adding emotional reinforcement.
- AI-generated farmer stories must be edited to avoid sounding over-written, exaggerated, or guilty.

Example tone:
- Good: `우박 피해로 출하가 어려워진 사과입니다. 기부로 2kg 박스를 받아보실 수 있어요.`
- Avoid: `당신의 따뜻한 손길이 절망 속 농부에게 기적을 선물합니다.`

---

## Stitch Prompt Notes

When generating screens in Stitch, apply the following directives:

- **Use a Toss-like neutral base.** Canvas should be `#f7f8fa`, cards should be white, and separators should be cool light gray.
- **Use Fresh Green (#1f7a5a) as a restrained accent, not a dominant background.**
- **Signal Red (#e5484d) appears only on urgency/disaster elements.** If Stitch places it on decorative elements or general buttons, override it.
- **Produce photos must be realistically imperfect.** Request photos of actual damaged fruit with visible scarring, irregular sizing, or discoloration. Do not generate idealized produce.
- **State handling must be explicit.** Include loading, empty, disabled, validation, success, and sticky CTA states where relevant.
- **Korean text is primary.** All UI labels, button text, and microcopy should be in Korean. English appears only in the Admin interface section headers and in code/technical contexts.
- **The risk indicator on the Farm app home screen should dominate the upper 40% of the viewport.** Do not reduce it to a small chip or badge — it is the primary communication of the app.
- **Never use gradients** except inside the Climate Journey Card background (a subtle dark-green-to-black radial for depth).
- **In app onboarding and forms, prefer rounded rectangles over full pills** for primary CTAs and selected cards.
- **Do not make the UI feel like a generic fintech or NGO landing page.** Preserve warmth, real photography, and calm density.
- **Do not generate onboarding screens with oversized emoji cards, dashed empty boxes, or dark green segmented bars.** Keep onboarding minimal, neutral, and premium.
