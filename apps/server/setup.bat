@echo off
REM Give On Backend 한 번에 시작하기 (Windows)
REM 사용: setup.bat

setlocal enabledelayedexpansion
cls

echo.
echo 🚀 Give On Backend 초기화 중...
echo ========================================
echo.

REM 1️⃣ Python 버전 확인
echo [1/4] Python 버전 확인 중...
python3 --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Python 3이 설치되어 있지 않습니다.
    echo https://www.python.org/downloads/
    pause
    exit /b 1
)
for /f "tokens=2" %%i in ('python3 --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python %PYTHON_VERSION% 감지됨
echo.

REM 2️⃣ 가상환경 생성 (없으면)
echo [2/4] 가상환경 설정 중...
if not exist ".venv" (
    echo    가상환경 생성 중...
    python3 -m venv .venv
    echo ✅ 가상환경 생성 완료
) else (
    echo ✅ 가상환경 이미 존재
)

REM 가상환경 활성화
call .venv\Scripts\activate.bat
echo ✅ 가상환경 활성화 완료
echo.

REM 3️⃣ 패키지 설치
echo [3/4] 패키지 설치 중...
pip install -q -r requirements.txt
echo ✅ 패키지 설치 완료
echo.

REM 4️⃣ 더미 데이터 생성
echo [4/4] 더미 데이터 생성 중...
python -m scripts.seed_dummy_data
echo.

REM 5️⃣ 서버 시작
echo ========================================
echo 🎉 초기화 완료!
echo ========================================
echo.
echo 📚 API 문서:
echo    Swagger UI: http://localhost:8000/docs
echo    ReDoc: http://localhost:8000/redoc
echo.
echo 🛑 서버 중지: Ctrl+C
echo.
echo 🚀 서버 시작 중...
echo.

uvicorn app.main:app --reload --port 8000
pause
