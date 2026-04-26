# Give On Backend API

기후 위기로부터 축산 농가를 보호하는 AI 플랫폼의 FastAPI 백엔드

## 🚀 빠른 시작 (1줄!)

### 한 번에 시작하기

**macOS/Linux:**
```bash
cd packages/backend && bash setup.sh
```

**Windows:**
```bash
cd packages/backend
setup.bat
```

**크로스플랫폼 (Python):**
```bash
cd packages/backend && python setup.py
```

자동으로 다음을 실행합니다:
1. ✅ 가상환경 생성/활성화
2. ✅ 패키지 설치 (`pip install -r requirements.txt`)
3. ✅ 더미 데이터 생성
4. ✅ FastAPI 서버 시작

---

## 📚 수동 설정 (선택사항)

### 1. 가상환경 설정
```bash
cd packages/backend
python3 -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
```

### 2. 패키지 설치
```bash
pip install -r requirements.txt
```

### 3. 더미 데이터 생성
```bash
python -m scripts.seed_dummy_data
```

### 4. 서버 실행
```bash
uvicorn app.main:app --reload --port 8000
```

## 📚 API 문서

서버 실행 후 접속:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 📁 프로젝트 구조

```
app/
├── main.py              # FastAPI 진입점
├── config.py            # 환경변수 관리
├── database.py          # SQLAlchemy + SQLite 설정
│
├── models/              # ORM 모델
│   ├── farm.py          # 농가 정보
│   ├── weather.py       # 기상 데이터
│   └── alert.py         # 경보 로그
│
├── schemas/             # Pydantic 요청/응답 스키마 (TODO)
├── api/                 # REST API 라우터 (TODO)
│   ├── farms.py         # 농가 API
│   ├── alerts.py        # 경보 API
│   └── ...
├── agent/               # AI Agent (TODO)
│   ├── risk_engine.py   # 위험도 판단 엔진
│   ├── claude_agent.py  # Claude API 연동
│   └── ...
└── data/                # 데이터 수집 (TODO)
    └── kma_client.py    # 기상청 API 클라이언트
```

## 🗄️ 데이터베이스

### 📌 개발 환경 (현재)
**SQLite 로컬 데이터베이스** ✅ **설치 불필요**

| 항목 | 설명 |
|---|---|
| **엔진** | SQLite (파일 기반) |
| **파일** | `giveon_dev.db` |
| **드라이버** | aiosqlite (비동기) |
| **설치** | Python 내장 (별도 설치 불필요) |
| **관리** | 자동 생성/관리 |
| **장점** | 빠른 개발, 배포 없음, 순간 리셋 가능 |

### 🔒 프로덕션 환경 (나중에)
**PostgreSQL** (Supabase 또는 자체 서버)

변경하려면:
```bash
# .env 파일 수정
DATABASE_URL=postgresql+asyncpg://user:password@host:5432/giveon_db

# 또는 환경변수 설정
export DATABASE_URL=postgresql+asyncpg://...

# 서버 재시작
uvicorn app.main:app --reload
```

> ℹ️ SQLAlchemy ORM이 같은 코드로 자동 처리

## 📊 더미 데이터

자동으로 생성되는 데이터:
- **농가**: 5개 (닭, 돼지, 소, 오리 등)
- **기상 데이터**: 8개 (온도, 습도, 예보)
- **경보**: 8개 (safe, caution, danger, emergency)

## 🔧 개발 팁

### 환경변수 설정
```bash
cp ../../.env.example .env
```

### 필요한 API 키 (선택사항)
- `ANTHROPIC_API_KEY`: Claude API (Step 2 이후)
- `KMA_API_KEY`: 기상청 API (Step 2 이후)

### 로그 레벨 조정
```bash
uvicorn app.main:app --log-level debug
```

### 테스트 실행
```bash
pytest tests/ -v
```

## 📅 개발 단계

- ✅ **Step 1**: FastAPI + SQLite 세팅 (완료)
- ⏳ **Step 2**: 기상청 API 클라이언트 (진행 예정)
- ⏳ **Step 3**: 위험도 엔진 + Claude API
- ⏳ **Step 4**: FCM 푸시 알림
- ⏳ **Step 5**: API 엔드포인트 (라우터)

## 🐛 트러블슈팅

**Q: `ModuleNotFoundError: No module named 'app'`**
```bash
# 올바른 위치에서 실행?
cd packages/backend
uvicorn app.main:app --reload
```

**Q: `database locked` 에러**
- SQLite는 동시 쓰기에 약합니다
- 개발 중에는 괜찮습니다
- 프로덕션은 PostgreSQL 권장

**Q: 더미 데이터가 없어요**
```bash
python -m scripts.seed_dummy_data
```

## 📞 참고 자료

- [FastAPI 공식 문서](https://fastapi.tiangolo.com/)
- [SQLAlchemy Async](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html)
- [Pydantic 문서](https://docs.pydantic.dev/)
