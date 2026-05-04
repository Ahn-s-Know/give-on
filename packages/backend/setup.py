#!/usr/bin/env python3
"""
Give On Backend 한 번에 시작하기 (크로스플랫폼)
사용: python setup.py
"""

import subprocess
import sys
import os
import shutil
from pathlib import Path


class Colors:
    """터미널 색상"""
    GREEN = "\033[0;32m"
    BLUE = "\033[0;34m"
    YELLOW = "\033[1;33m"
    RED = "\033[0;31m"
    NC = "\033[0m"


def print_colored(text, color):
    """색상 출력"""
    print(f"{color}{text}{Colors.NC}")


def run_command(cmd, description):
    """명령 실행"""
    try:
        print_colored(f"   {description}...", Colors.BLUE)
        subprocess.run(cmd, check=True, shell=True, capture_output=True)
        print_colored(f"   ✅ {description} 완료", Colors.GREEN)
        return True
    except subprocess.CalledProcessError as e:
        print_colored(f"   ❌ {description} 실패", Colors.RED)
        print(f"   에러: {e}")
        return False


def main():
    """메인 함수"""
    print()
    print_colored("🚀 Give On Backend 초기화 중...", Colors.BLUE)
    print_colored("=" * 50, Colors.BLUE)
    print()

    script_dir = Path(__file__).parent
    os.chdir(script_dir)

    # 1️⃣ Python 버전 확인
    print_colored("[1/5] Python 버전 확인 중", Colors.BLUE)
    python_version = sys.version.split()[0]
    if sys.version_info < (3, 8):
        print_colored(f"   ❌ Python 3.8 이상이 필요합니다 (현재: {python_version})", Colors.RED)
        return False
    print_colored(f"   ✅ Python {python_version} 감지됨", Colors.GREEN)
    print()

    # 2️⃣ 가상환경 확인/생성
    print_colored("[2/5] 가상환경 설정 중", Colors.BLUE)
    venv_dir = script_dir / ".venv"

    if not venv_dir.exists():
        if not run_command(f"{sys.executable} -m venv .venv", "가상환경 생성"):
            return False
    else:
        print_colored(f"   ✅ 가상환경 이미 존재", Colors.GREEN)
    print()

    # 3️⃣ pip 업그레이드 및 패키지 설치
    print_colored("[3/5] 패키지 설치 중", Colors.BLUE)

    # 가상환경 실행 경로
    if sys.platform == "win32":
        pip_cmd = str(venv_dir / "Scripts" / "pip")
        python_cmd = str(venv_dir / "Scripts" / "python")
    else:
        pip_cmd = str(venv_dir / "bin" / "pip")
        python_cmd = str(venv_dir / "bin" / "python")

    # pip 업그레이드
    subprocess.run(
        f"{pip_cmd} install -q --upgrade pip",
        shell=True,
        capture_output=True
    )

    # 패키지 설치
    if not run_command(f"{pip_cmd} install -q -r requirements.txt", "패키지 설치"):
        return False
    print()

    # 4️⃣ 더미 데이터 생성
    print_colored("[4/5] 더미 데이터 생성 중", Colors.BLUE)
    if not run_command(f"{python_cmd} -m scripts.seed_dummy_data", "더미 데이터 생성"):
        return False
    print()

    # 5️⃣ 서버 시작
    print_colored("=" * 50, Colors.GREEN)
    print_colored("🎉 초기화 완료!", Colors.GREEN)
    print_colored("=" * 50, Colors.GREEN)
    print()

    print_colored("📚 API 문서:", Colors.YELLOW)
    print("   🔗 Swagger UI: http://localhost:8000/docs")
    print("   🔗 ReDoc: http://localhost:8000/redoc")
    print()

    print_colored("🛑 서버 중지:", Colors.YELLOW)
    print("   Ctrl+C를 누르세요")
    print()

    print_colored("[5/5] 서버 시작 중", Colors.BLUE)
    print()

    # 서버 시작
    try:
        subprocess.run(
            f"{python_cmd} -m uvicorn app.main:app --reload --port 8000",
            shell=True,
        )
    except KeyboardInterrupt:
        print()
        print_colored("👋 서버가 종료되었습니다.", Colors.GREEN)
        return True

    return True


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
