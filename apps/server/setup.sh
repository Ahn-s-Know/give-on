#!/bin/bash

###############################################
# Give On Backend 한 번에 시작하기
# 사용: bash setup.sh
###############################################

set -e  # 에러 발생 시 즉시 종료

echo "🚀 Give On Backend 초기화 중..."
echo "========================================"

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1️⃣ Python 버전 확인
echo -e "${BLUE}[1/4]${NC} Python 버전 확인 중..."
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}⚠️  Python 3이 설치되어 있지 않습니다.${NC}"
    exit 1
fi
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo -e "${GREEN}✅ Python ${PYTHON_VERSION} 감지됨${NC}"

# 2️⃣ 가상환경 생성 (없으면)
echo ""
echo -e "${BLUE}[2/4]${NC} 가상환경 설정 중..."
if [ ! -d ".venv" ]; then
    echo "   가상환경 생성 중..."
    python3 -m venv .venv
    echo -e "${GREEN}✅ 가상환경 생성 완료${NC}"
else
    echo -e "${GREEN}✅ 가상환경 이미 존재${NC}"
fi

# 가상환경 활성화
source .venv/bin/activate
echo -e "${GREEN}✅ 가상환경 활성화 완료${NC}"

# 3️⃣ 패키지 설치
echo ""
echo -e "${BLUE}[3/4]${NC} 패키지 설치 중..."
pip install -q -r requirements.txt
echo -e "${GREEN}✅ 패키지 설치 완료${NC}"

# 4️⃣ 더미 데이터 생성
echo ""
echo -e "${BLUE}[4/4]${NC} 더미 데이터 생성 중..."
python -m scripts.seed_dummy_data
echo ""

# 5️⃣ 서버 시작
echo "========================================"
echo -e "${GREEN}🎉 초기화 완료!${NC}"
echo "========================================"
echo ""
echo -e "${YELLOW}📚 API 문서:${NC}"
echo "   Swagger UI: http://localhost:8000/docs"
echo "   ReDoc: http://localhost:8000/redoc"
echo ""
echo -e "${YELLOW}🛑 서버 중지:${NC} Ctrl+C"
echo ""
echo -e "${BLUE}🚀 서버 시작 중...${NC}"
echo ""

uvicorn app.main:app --reload --port 8000
