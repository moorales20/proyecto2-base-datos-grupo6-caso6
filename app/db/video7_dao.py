"""Persistencia Video 7: tablas reales del Caso 6 y autorización por transacción."""
from sqlalchemy import text
from sqlalchemy.engine import Engine
from db.auth_dao import exigir_administrador


class Video7DAO:
    def __init__(self, engine: Engine):
        self.engine = engine

    def _listar(self, sql, params=None):
        with self.engine.connect() as conn:
            return [dict(r) for r in conn.execute(text(sql), params or {}).mappings()]

    def listar_paises(self, filtro=""):
        return self._listar("""SELECT idPais, nombreOficial, organismoResponsable, presupuestoAnual
            FROM PAIS WHERE idPais LIKE :q OR nombreOficial LIKE :q
            ORDER BY nombreOficial""", {"q": f"%{filtro}%"})

    def listar_bases(self, filtro=""):
        return self._listar("""SELECT idBase, nombre, ubicacion, fechaInstalacion,
            capacidadMaxima, presupuesto, nivelAislamiento, idPais
            FROM BASE WHERE idBase LIKE :q OR nombre LIKE :q ORDER BY nombre""",
            {"q": f"%{filtro}%"})

    def listar_personal(self):
        return self._listar("""SELECT idPersonal, nombres, apellidos
            FROM PERSONAL ORDER BY apellidos, nombres""")

    def listar_expediciones(self):
        return self._listar("""SELECT e.idExpedicion, e.fechaInicio, e.duracionDias,
            e.capacidadMaxima, e.idBase, b.nombre AS base
            FROM EXPEDICION e JOIN BASE b ON b.idBase=e.idBase
            ORDER BY e.fechaInicio DESC, e.idExpedicion""")

    def listar_participaciones(self, filtro=""):
        return self._listar("""SELECT p.idExpedicion, p.idPersonal, per.nombres, per.apellidos,
            p.funcion, p.fechaIncorporacion, p.estado, p.observaciones
            FROM PARTICIPACION p JOIN PERSONAL per ON per.idPersonal=p.idPersonal
            WHERE p.idExpedicion LIKE :q OR p.idPersonal LIKE :q
            ORDER BY p.fechaIncorporacion DESC LIMIT 150""", {"q": f"%{filtro}%"})

    def crear_participacion(self, item, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            e = conn.execute(text("""SELECT fechaInicio, duracionDias, capacidadMaxima
                FROM EXPEDICION WHERE idExpedicion=:id FOR UPDATE"""),
                {"id": item["idExpedicion"]}).mappings().first()
            if e is None:
                raise ValueError("La expedición seleccionada ya no existe.")
            existe = conn.execute(text("""SELECT COUNT(*) FROM PARTICIPACION
                WHERE idExpedicion=:e AND idPersonal=:p"""),
                {"e": item["idExpedicion"], "p": item["idPersonal"]}).scalar_one()
            if existe:
                raise ValueError("Este personal ya participa en esa expedición.")
            ocupacion = conn.execute(text("""SELECT COUNT(*) FROM PARTICIPACION
                WHERE idExpedicion=:e AND estado <> 'CANCELADA'"""),
                {"e": item["idExpedicion"]}).scalar_one()
            if item["estado"] != "CANCELADA" and ocupacion >= e["capacidadMaxima"]:
                raise ValueError("No quedan cupos disponibles en la expedición.")
            from datetime import timedelta
            if not (e["fechaInicio"] <= item["fechaIncorporacion"] <
                    e["fechaInicio"] + timedelta(days=int(e["duracionDias"]))):
                raise ValueError("La fecha de incorporación queda fuera del período de la expedición.")
            conn.execute(text("""INSERT INTO PARTICIPACION
                (idExpedicion,idPersonal,funcion,fechaIncorporacion,estado,observaciones)
                VALUES (:idExpedicion,:idPersonal,:funcion,:fechaIncorporacion,:estado,:observaciones)"""), item)

    def crear_pais(self, item, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            conn.execute(text("""INSERT INTO PAIS
                (idPais,nombreOficial,organismoResponsable,presupuestoAnual)
                VALUES (:idPais,:nombreOficial,:organismoResponsable,:presupuestoAnual)"""), item)

    def modificar_pais(self, item, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            result = conn.execute(text("""UPDATE PAIS SET nombreOficial=:nombreOficial,
                organismoResponsable=:organismoResponsable, presupuestoAnual=:presupuestoAnual
                WHERE idPais=:idPais"""), item)
            if result.rowcount == 0:
                raise ValueError("El país ya no existe o no hubo cambios.")

    def eliminar_pais(self, pk, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            parent = conn.execute(text("SELECT idPais FROM PAIS WHERE idPais=:id FOR UPDATE"), {"id": pk}).first()
            if parent is None:
                raise ValueError("El país no existe.")
            dependencias = conn.execute(text("SELECT COUNT(*) FROM BASE WHERE idPais=:id"), {"id": pk}).scalar_one()
            if dependencias:
                raise ValueError(f"No se puede eliminar: {dependencias} bases dependen de este país.")
            conn.execute(text("DELETE FROM PAIS WHERE idPais=:id"), {"id": pk})

    def crear_base(self, item, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            conn.execute(text("""INSERT INTO BASE
                (idBase,nombre,ubicacion,fechaInstalacion,capacidadMaxima,presupuesto,nivelAislamiento,idPais)
                VALUES (:idBase,:nombre,:ubicacion,:fechaInstalacion,:capacidadMaxima,:presupuesto,:nivelAislamiento,:idPais)"""), item)

    def modificar_base(self, item, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            result = conn.execute(text("""UPDATE BASE SET nombre=:nombre, ubicacion=:ubicacion,
                fechaInstalacion=:fechaInstalacion, capacidadMaxima=:capacidadMaxima,
                presupuesto=:presupuesto, nivelAislamiento=:nivelAislamiento, idPais=:idPais
                WHERE idBase=:idBase"""), item)
            if result.rowcount == 0:
                raise ValueError("La base ya no existe o no hubo cambios.")

    def eliminar_base(self, pk, *, actor_id=None):
        with self.engine.begin() as conn:
            exigir_administrador(conn, actor_id)
            parent = conn.execute(text("SELECT idBase FROM BASE WHERE idBase=:id FOR UPDATE"), {"id": pk}).first()
            if parent is None:
                raise ValueError("La base no existe.")
            for tabla in ("SECTOR", "EXPEDICION"):
                count = conn.execute(text(f"SELECT COUNT(*) FROM {tabla} WHERE idBase=:id"), {"id": pk}).scalar_one()
                if count:
                    raise ValueError(f"No se puede eliminar: existen {count} registros dependientes en {tabla}.")
            conn.execute(text("DELETE FROM BASE WHERE idBase=:id"), {"id": pk})
