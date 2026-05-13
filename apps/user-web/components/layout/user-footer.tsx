import { MarketingFooterShell } from "@give-on/ui";

export function UserFooter() {
  return (
    <MarketingFooterShell
      description="기후 재난으로 어려움을 겪는 농가와 시민을 연결하고, 기부와 배송 경험을 하나의 흐름으로 만듭니다."
      impactLabel="지금까지 0.9톤의 CO₂ 절감과 327건의 농가 지원이 이어졌어요."
      columns={[
        {
          title: "서비스",
          items: ["진행 중인 캠페인", "임팩트 리포트", "알림 센터"]
        },
        {
          title: "농가 파트너",
          items: ["농가 등록", "피해 제보", "못난이 작물 등록"]
        },
        {
          title: "지원",
          items: ["운영팀 문의", "이용 가이드", "개인정보 처리방침"]
        }
      ]}
    />
  );
}
