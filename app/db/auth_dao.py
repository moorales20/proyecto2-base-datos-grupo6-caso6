"""Lectura de cuentas y autorización usando las tablas existentes del Caso 6."""
from sqlalchemy import text


class PermisoDenegado(PermissionError):
    """Usuario sin sesión válida, inactivo o sin permiso suficiente."""


class AuthDAO:
    def __init__(self, engine):
        self.engine = engine

    def obtener_cuenta(self, nombre_usuario):
        with self.engine.connect() as conn:
            row = conn.execute(text("""
                SELECT idCuenta, nombreUsuario, claveAcceso, activa, idPersonal
                FROM CUENTA_USUARIO WHERE nombreUsuario = :nombre
            """), {"nombre": nombre_usuario}).mappings().first()
            return dict(row) if row else None

    def obtener_sesion(self, id_cuenta):
        if not id_cuenta:
            return None
        with self.engine.connect() as conn:
            cuenta = conn.execute(text("""
                SELECT idCuenta, nombreUsuario, idPersonal
                FROM CUENTA_USUARIO
                WHERE idCuenta = :id AND activa = 1
            """), {"id": id_cuenta}).mappings().first()
            if not cuenta:
                return None
            roles = conn.execute(text("""
                SELECT r.nombreRol FROM ROL r
                JOIN ASIGNACION_ROL ar ON ar.idRol = r.idRol
                WHERE ar.idCuenta = :id
            """), {"id": id_cuenta}).scalars().all()
            return {**dict(cuenta), "roles": tuple(roles)}


def exigir_administrador(conn, id_cuenta):
    """Autoriza escritura dentro de la MISMA transacción que realizará el DML.

    El bloqueo compartido impide desactivar la cuenta o retirar el rol mientras
    esta transacción está validando y escribiendo. Nunca confía en el UI.
    """
    if not id_cuenta:
        raise PermisoDenegado("Debes iniciar sesión como administrador.")
    cuenta = conn.execute(text("""
        SELECT idCuenta FROM CUENTA_USUARIO
        WHERE idCuenta = :id AND activa = 1 FOR SHARE
    """), {"id": id_cuenta}).first()
    if not cuenta:
        raise PermisoDenegado("La cuenta no está activa o no existe.")
    rol = conn.execute(text("""
        SELECT ar.idRol FROM ASIGNACION_ROL ar
        JOIN ROL r ON r.idRol = ar.idRol
        WHERE ar.idCuenta = :id AND r.nombreRol = 'ADMINISTRADOR'
        FOR SHARE
    """), {"id": id_cuenta}).first()
    if not rol:
        raise PermisoDenegado("No tienes permiso para modificar información.")
