# GiveOnFarm 디자인 시스템

GiveOnFarm 앱의 일관성 있는 UI/UX를 위한 디자인 시스템입니다.

## 📁 파일 구조

```
DesignSystem/
├── GOFColors.swift           # 색상 팔레트
├── GOFTypography.swift       # 폰트 스타일
├── GOFSpacing.swift          # 간격 및 크기 상수
├── GOFButtonStyles.swift     # 버튼 스타일
├── GOFComponents.swift       # 재사용 가능한 컴포넌트
└── GOFViewExtensions.swift   # View Extension 헬퍼
```

## 🎨 색상 사용법

### 기본 사용
```swift
Text("안녕하세요")
    .foregroundColor(.gof.textPrimary)
    .background(.gof.backgroundPrimary)
```

### 주요 색상
- **Primary Green**: `.gof.primaryGreen` - 주요 액션 버튼
- **Light Green**: `.gof.lightGreen` - 선택된 상태 강조
- **Dark Green**: `.gof.darkGreen` - 헤더, 타이틀
- **Text Primary**: `.gof.textPrimary` - 주요 텍스트
- **Text Secondary**: `.gof.textSecondary` - 보조 텍스트
- **Background Primary**: `.gof.backgroundPrimary` - 기본 배경색

## 📝 타이포그래피 사용법

### 기본 사용
```swift
Text("제목")
    .font(.gof.largeTitle)

Text("본문")
    .font(.gof.body)
```

### 주요 폰트
- **Large Title**: `.gof.largeTitle` (24pt, Bold)
- **Title**: `.gof.title` (20pt, Bold)
- **Subtitle**: `.gof.subtitle` (17pt, Bold)
- **Body**: `.gof.body` (15pt, Regular)
- **Caption**: `.gof.caption` (13pt, Regular)
- **Button Large**: `.gof.buttonLarge` (20pt, Bold)

## 📏 스페이싱 사용법

### 기본 사용
```swift
VStack(spacing: .gof.md) {
    // 내용
}
.padding(.gof.lg)
```

### 주요 간격
- **xs**: 8pt
- **sm**: 12pt
- **md**: 16pt
- **lg**: 20pt
- **xl**: 24pt
- **xxl**: 32pt

### 모서리 둥글기
- **radiusSmall**: 4pt
- **radiusMedium**: 8pt
- **radiusLarge**: 12pt
- **radiusXLarge**: 16pt
- **radiusFull**: 999pt (완전히 둥근 모양)

## 🔘 버튼 스타일 사용법

### Primary 버튼
```swift
Button("확인") {
    // 액션
}
.gofPrimaryButton()

// 비활성화된 버튼
Button("확인") {
    // 액션
}
.gofPrimaryButton(isEnabled: false)
```

### Secondary 버튼
```swift
Button("취소") {
    // 액션
}
.gofSecondaryButton()
```

### Outline 버튼
```swift
Button("사과") {
    // 액션
}
.gofOutlineButton(isSelected: isSelected)
```

### Small 버튼
```swift
Button("100평") {
    // 액션
}
.gofSmallButton()
```

### Checkbox 버튼
```swift
Button {
    // 토글 액션
} label: {
    Text("옵션 1")
}
.gofCheckboxButton(isSelected: isChecked)
```

### Gray 버튼
```swift
Button("음성으로 이야기하기") {
    // 액션
}
.gofGrayButton()
```

## 🧩 컴포넌트 사용법

### 헤더
```swift
GOFHeader(title: "피해 신고") {
    // 뒤로가기 액션
    presentationMode.wrappedValue.dismiss()
}
```

### 단계 표시
```swift
GOFStepIndicator(currentStep: 2, totalSteps: 3)
```

### 섹션 제목
```swift
// 필수 항목
GOFSectionTitle("작물 선택", isRequired: true)

// 선택 항목
GOFSectionTitle("추가 설명")
```

### 텍스트 입력 필드
```swift
GOFTextField(
    placeholder: "피해 면적 입력",
    text: $damageArea,
    suffix: "평",
    keyboardType: .numberPad
)
```

### 텍스트 에디터
```swift
GOFTextEditor(
    placeholder: "상세 내용을 입력하세요",
    text: $notes,
    minHeight: 120,
    maxCharacters: 500
)
```

### 정보 배너
```swift
GOFInfoBanner(
    icon: "lightbulb.fill",
    title: "AI가 스토리를 다듬어 드립니다.",
    description: "어려웠던 일, 필요한 도움을 편하게 적어주세요."
)
```

### 카드 컨테이너
```swift
GOFCard {
    VStack(alignment: .leading, spacing: 12) {
        Text("카드 제목")
            .font(.gof.subtitle)
        Text("카드 내용")
            .font(.gof.body)
    }
}
```

### 성공 아이콘
```swift
GOFSuccessIcon()  // 기본 크기 96pt

GOFSuccessIcon(size: 64)  // 커스텀 크기
```

### 로딩 오버레이
```swift
if isLoading {
    GOFLoadingOverlay()
}
```

## 🛠 View Extensions

### 점선 테두리
```swift
Rectangle()
    .dashedBorder(
        color: .gof.borderDefault,
        width: 2,
        cornerRadius: 12,
        dashPattern: [5, 5]
    )
```

## 📋 마이그레이션 가이드

### Before (기존 코드)
```swift
Text("제목")
    .font(.system(size: 20, weight: .bold, design: .default))
    .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))

Button(action: {
    submit()
}) {
    Text("확인")
        .font(.system(size: 20, weight: .bold, design: .default))
        .foregroundColor(.white)
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
        .cornerRadius(999)
}
```

### After (디자인 시스템 적용)
```swift
Text("제목")
    .font(.gof.title)
    .foregroundColor(.gof.textPrimary)

Button("확인") {
    submit()
}
.gofPrimaryButton()
```

## ✅ 장점

1. **일관성**: 모든 화면에서 동일한 디자인 언어 사용
2. **유지보수성**: 한 곳에서 디자인 변경 시 전체 앱에 반영
3. **생산성**: 반복적인 스타일 코드 작성 불필요
4. **가독성**: 의도가 명확한 코드 작성 가능
5. **확장성**: 새로운 스타일 추가가 쉬움

## 🎯 Best Practices

1. **항상 디자인 시스템 사용**: 하드코딩된 색상, 폰트, 간격 대신 디자인 시스템 사용
2. **새로운 패턴 발견 시**: 재사용 가능하면 디자인 시스템에 추가
3. **네이밍 일관성**: 명확하고 일관된 네이밍 사용
4. **문서화**: 새로운 컴포넌트 추가 시 이 문서 업데이트

## 📱 예제

전체 화면 예제는 각 디자인 시스템 파일의 `#Preview` 섹션을 참고하세요.

---

**Created**: 2026-05-10  
**Last Updated**: 2026-05-10
