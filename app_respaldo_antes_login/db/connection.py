
import os
import time

from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine, URL
from sqlalchemy.exc import SQLAlchemyError


class DatabaseUnavailableError(Exception):
    """Se lanza cuando MySQL no responde dentro del tiempo de espera."""


def get_database_url() -> URL:
    """Construye la URL de conexión SQLAlchemy + PyMySQL."""

    host = os.getenv("MYSQL_HOST", "db")
    port = int(os.getenv("MYSQL_PORT", "3306"))
    database = os.getenv(
        "MYSQL_DATABASE",
        "expediciones_antarticas_db"
    )
    user = os.getenv("MYSQL_USER", "")
    password = os.getenv("MYSQL_PASSWORD", "")

    if not user or not password:
        raise ValueError(
            "Faltan MYSQL_USER y/o MYSQL_PASSWORD."
        )

    return URL.create(
        drivername="mysql+pymysql",
        username=user,
        password=password,
        host=host,
        port=port,
        database=database,
        query={"charset": "utf8mb4"}
    )


def create_db_engine() -> Engine:
    """Crea el Engine de SQLAlchemy."""

    return create_engine(
        get_database_url(),
        pool_pre_ping=True,
        pool_recycle=1800,
        future=True
    )


def wait_for_database(
    engine: Engine,
    max_retries: int = 15,
    delay_seconds: float = 2.0
) -> bool:
    """Comprueba la conexión con MySQL."""

    last_error = None

    for attempt in range(1, max_retries + 1):
        try:
            with engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            return True

        except SQLAlchemyError as exc:
            last_error = exc

            if attempt < max_retries:
                time.sleep(delay_seconds)

    raise DatabaseUnavailableError(
        f"No fue posible conectar a MySQL "
        f"tras {max_retries} intentos."
    ) from last_error
