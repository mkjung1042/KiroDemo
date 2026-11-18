# 청년 정책 맞춤 추천 (해커톤 MVP, 2시간)

## 목적
20~30대가 나이·지역·소득·취업상태·주거형태를 입력하면
받을 수 있는 청년 정책과 그 이유를 보여준다.

## 범위 (이것만 만든다)
- 입력 폼 1개 → 결과 카드 목록
- 정책 데이터: /frontend/policies.json (DB 없음)
- 조건 매칭: 프론트엔드 JS 규칙 기반
- 설명 생성: Lambda 1개 → Amazon Bedrock
- 로그인, DB, 알림 기능 없음 (알림 버튼은 토스트만)

## 파일 담당
- /frontend/index.html : 프론트 (HTML+CSS+JS 한 파일)
- /frontend/policies.json : 정책 데이터
- /frontend/personas.json : 데모용 예시 페르소나 (화면의 "예시로 체험해보기" 버튼)
- /lambda/handler.py : Lambda (Python 3.12)

## 데이터 형식 (policies.json, 배열)
{ "id": "p1", "name": "", "minAge": 19, "maxAge": 34,
  "regions": ["전국"], "maxIncome": null,
  "employment": ["재직","구직","학생"], "housing": ["월세"],
  "benefit": "", "deadline": "2026-12-31 또는 상시 등 글자", "url": "",
  "detail": "지원 내용·신청 방법·필요 서류 요약", "reason": "백업 설명" }
- deadline이 YYYY-MM-DD면 D-day, 아니면 글자 그대로 배지로 표시
- regions에 "전국"이 있으면 모든 지역 해당
- maxIncome 단위는 만원, null이면 소득 조건 없음

## API
POST {Lambda 함수 URL}
요청 (설명 생성): { "mode": "explain", "user": { "age": 27, "region": "서울", "income": 3000,
                  "employment": "재직", "housing": "월세" },
        "policies": [매칭된 정책 객체 배열] }
응답: { "results": [ { "id": "p1", "reason": "한두 문장 설명" } ] }
- 실패 시 results는 빈 배열 → 프론트는 입력 조건으로 만든 기본 문구 표시

요청 (한 문장 → 조건 추출): { "mode": "parse", "text": "27살 서울 월세 직장인, 연봉 3천" }
응답: { "user": { "age": 27, "region": "서울", "income": 3000, "employment": "재직", "housing": "월세" } }
- 알 수 없는 값은 null, 실패 시 { "user": null } → 프론트는 규칙 기반으로 대신 추출

요청 (질문 답변): { "mode": "ask", "user": {...}, "policy": {정책 객체}, "question": "" }
응답: { "answer": "답변" }
- 실패 시 answer는 "지금은 답변이 어려워요..." 안내 문구

## 규칙
- 코드는 단순하게, 외부 라이브러리 최소화
- 한국어 UI, 모바일 화면 우선
- 자기 담당 파일만 수정한다
