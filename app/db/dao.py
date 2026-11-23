from sqlalchemy import text
from sqlalchemy.engine import Engine


class ExpedicionesDAO:
    """Capa de acceso a datos (DAO) sobre las tablas reales del DDL."""

    def __init__(self, engine: Engine) -> None:
        self.engine = engine

    def obtener_cantidad_personal(self, tipo_personal: str | None = None) -> int:
        """Consulta la cantidad de registros en PERSONAL."""
        if tipo_personal:
            query = text(
                """
                SELECT COUNT(*) AS total
                FROM PERSONAL
                WHERE tipoPersonal = :tipo_personal
                """
            )
            params = {"tipo_personal": tipo_personal}
        else:
            query = text("SELECT COUNT(*) AS total FROM PERSONAL")
            params = {}

        with self.engine.connect() as conn:
            result = conn.execute(query, params).scalar_one()
        return int(result)

    def obtener_cantidad_participaciones(self, excluir_canceladas: bool = False) -> int:
        """Consulta la cantidad de registros en PARTICIPACION."""
        if excluir_canceladas:
            query = text(
                """
                SELECT COUNT(*) AS total
                FROM PARTICIPACION
                WHERE estado <> :estado_cancelada
                """
            )
            params = {"estado_cancelada": "CANCELADA"}
        else:
            query = text("SELECT COUNT(*) AS total FROM PARTICIPACION")
            params = {}

        with self.engine.connect() as conn:
            result = conn.execute(query, params).scalar_one()
        return int(result)

    def obtener_expediciones_por_base(self, limite: int = 10) -> list[dict]:
        """Consulta el total de expediciones agrupado por base y país."""
        query = text(
            """
            SELECT
                b.idBase AS id_base,
                b.nombre AS base,
                p.nombreOficial AS pais,
                COUNT(e.idExpedicion) AS total_expediciones
            FROM EXPEDICION e
            INNER JOIN BASE b ON b.idBase = e.idBase
            INNER JOIN PAIS p ON p.idPais = b.idPais
            GROUP BY b.idBase, b.nombre, p.nombreOficial
            ORDER BY total_expediciones DESC, b.nombre ASC
            LIMIT :limite
            """
        )
        with self.engine.connect() as conn:
            rows = conn.execute(query, {"limite": limite}).mappings().all()
        return [dict(row) for row in rows]
