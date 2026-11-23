import os
from db.connection import create_db_engine, wait_for_database
from db.dao import ExpedicionesDAO


def test_conexion_y_consultas_dao() -> None:
    """Prueba sencilla de conexión y consultas sobre el DAO."""
    assert os.getenv("MYSQL_HOST"), "MYSQL_HOST debe estar definida"
    engine = create_db_engine()
    assert wait_for_database(engine, max_retries=5, delay_seconds=1.0) is True

    dao = ExpedicionesDAO(engine)
    total_personal = dao.obtener_cantidad_personal()
    total_participaciones = dao.obtener_cantidad_participaciones()
    expediciones = dao.obtener_expediciones_por_base(limite=5)

    assert isinstance(total_personal, int) and total_personal >= 0
    assert isinstance(total_participaciones, int) and total_participaciones >= 0
    assert isinstance(expediciones, list)
