"""
APScheduler 설정 및 실행
FastAPI lifespan에서 시작/종료
"""
import logging

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.interval import IntervalTrigger

from app.scheduler.jobs import (
    collect_weather_and_alert,
    send_daily_morning_report,
    cleanup_old_logs,
)

logger = logging.getLogger(__name__)

_scheduler: AsyncIOScheduler = None


def get_scheduler() -> AsyncIOScheduler:
    global _scheduler
    if _scheduler is None:
        _scheduler = AsyncIOScheduler(timezone="Asia/Seoul")
    return _scheduler


def setup_jobs(scheduler: AsyncIOScheduler) -> None:
    """스케줄 작업 등록"""
    # 30분마다: 기상 수집 + 위험도 판단 + 경보
    scheduler.add_job(
        collect_weather_and_alert,
        trigger=IntervalTrigger(minutes=30),
        id="collect_weather",
        name="기상 수집 및 위험도 판단",
        replace_existing=True,
        misfire_grace_time=60,
    )

    # 매일 07:00: 아침 브리핑
    scheduler.add_job(
        send_daily_morning_report,
        trigger=CronTrigger(hour=7, minute=0),
        id="morning_report",
        name="일일 아침 위험 예보 브리핑",
        replace_existing=True,
    )

    # 매일 00:00: 로그 정리
    scheduler.add_job(
        cleanup_old_logs,
        trigger=CronTrigger(hour=0, minute=0),
        id="cleanup_logs",
        name="오래된 기상 로그 정리",
        replace_existing=True,
    )

    logger.info(f"📅 스케줄 작업 {scheduler.get_jobs().__len__()}개 등록 완료")


def start_scheduler() -> AsyncIOScheduler:
    """스케줄러 시작"""
    from app.config import get_settings
    settings = get_settings()

    if not settings.SCHEDULER_ENABLED:
        logger.info("⏸️ 스케줄러 비활성화 (SCHEDULER_ENABLED=False)")
        return None

    scheduler = get_scheduler()
    setup_jobs(scheduler)
    scheduler.start()
    logger.info("✅ APScheduler 시작")
    return scheduler


def stop_scheduler() -> None:
    """스케줄러 종료"""
    scheduler = get_scheduler()
    if scheduler.running:
        scheduler.shutdown(wait=False)
        logger.info("🛑 APScheduler 종료")
