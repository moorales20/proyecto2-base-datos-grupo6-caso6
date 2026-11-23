from sqlalchemy.engine import Engine
from db.connection import DatabaseUnavailableError, wait_for_database
from db.dao import ExpedicionesDAO


class MetricasService:
    """Capa de lógica de negocio para métricas iniciales del sistema."""

    def __init__(self, engine: Engine) -> None:
        self.engine = engine
        self.dao = ExpedicionesDAO(engine)

    def verificar_disponibilidad(self) -> tuple[bool, str]:
        """Verifica si la base de datos está lista para atender consultas."""
        try:
            wait_for_database(self.engine, max_retries=5, delay_seconds=1.5)
            return True, "Conexión activa con MySQL."
        except (DatabaseUnavailableError, ValueError) as exc:
            return False, str(exc)

    def obtener_indicadores_inicio(self, excluir_canceladas: bool = False) -> dict:
        """Obtiene los indicadores principales para la página de inicio."""
        return {
            "total_personal": self.dao.obtener_cantidad_personal(),
            "total_participaciones": self.dao.obtener_cantidad_participaciones(
                excluir_canceladas=excluir_canceladas
            ),
            "expediciones_base": self.dao.obtener_expediciones_por_base(limite=10),
        }
