"""Alta manual de dos cuentas demo, sin claves en SQL ni argumentos de consola.

Ejecutar UNA VEZ con: docker compose exec app python -m scripts.crear_cuentas_demo
No modifica el DDL ni las cuentas existentes. Si ya existen, falla sin alterar.
"""
from datetime import date
from getpass import getpass
import bcrypt
from sqlalchemy import text
from db.connection import create_db_engine

CUENTAS = (
    ("CTA-0056", "demo_admin", "PER-0056", "ADMINISTRADOR"),
    ("CTA-0057", "demo_consulta", "PER-0057", "CONSULTA"),
)


def pedir_clave(usuario):
    while True:
        clave = getpass(f"Nueva contraseña de {usuario} (mín. 12 caracteres): ")
        confirmacion = getpass("Repetir contraseña: ")
        if clave != confirmacion:
            print("Las contraseñas no coinciden.")
        elif len(clave) < 12 or len(clave.encode("utf-8")) > 72:
            print("Usa entre 12 caracteres y 72 bytes UTF-8.")
        else:
            return bcrypt.hashpw(clave.encode("utf-8"), bcrypt.gensalt(rounds=12)).decode("ascii")


def main():
    engine = create_db_engine()
    # Validación previa: no tocar cuentas ni personas que ya estén asociadas.
    with engine.connect() as conn:
        for id_cuenta, usuario, persona, _ in CUENTAS:
            p = conn.execute(text("SELECT idPersonal FROM PERSONAL WHERE idPersonal=:p"), {"p": persona}).first()
            c = conn.execute(text("""SELECT idCuenta FROM CUENTA_USUARIO
                WHERE idCuenta=:c OR nombreUsuario=:u OR idPersonal=:p"""),
                {"c": id_cuenta, "u": usuario, "p": persona}).first()
            if not p or c:
                raise RuntimeError(f"No se puede usar {persona}/{id_cuenta}/{usuario}: falta PERSONAL o ya hay cuenta.")
        existe = conn.execute(text("SELECT idRol FROM ROL WHERE nombreRol='CONSULTA'")).first()
        if not existe and conn.execute(text("SELECT idRol FROM ROL WHERE idRol='ROL-004'")).first():
            raise RuntimeError("ROL-004 ya está ocupado. Elige un ID libre antes de continuar.")
        if not conn.execute(text("SELECT idRol FROM ROL WHERE nombreRol='ADMINISTRADOR'")).first():
            raise RuntimeError("Falta el rol ADMINISTRADOR.")
    hashes = {usuario: pedir_clave(usuario) for _, usuario, _, _ in CUENTAS}
    with engine.begin() as conn:
        rol_consulta = conn.execute(text("SELECT idRol FROM ROL WHERE nombreRol='CONSULTA' FOR UPDATE")).scalar_one_or_none()
        if rol_consulta is None:
            rol_consulta = "ROL-004"
            conn.execute(text("""INSERT INTO ROL (idRol, nombreRol, descripcion)
                VALUES (:id, 'CONSULTA', 'Acceso de solo lectura al PMV')"""), {"id": rol_consulta})
        rol_admin = conn.execute(text("SELECT idRol FROM ROL WHERE nombreRol='ADMINISTRADOR'")).scalar_one()
        for id_cuenta, usuario, persona, nombre_rol in CUENTAS:
            conn.execute(text("""INSERT INTO CUENTA_USUARIO
                (idCuenta, nombreUsuario, claveAcceso, activa, idPersonal)
                VALUES (:id, :usuario, :hash, 1, :persona)"""),
                {"id": id_cuenta, "usuario": usuario, "hash": hashes[usuario], "persona": persona})
            conn.execute(text("""INSERT INTO ASIGNACION_ROL
                (idCuenta, idRol, fechaAsignacion) VALUES (:cuenta, :rol, :fecha)"""),
                {"cuenta": id_cuenta, "rol": rol_admin if nombre_rol == "ADMINISTRADOR" else rol_consulta,
                 "fecha": date.today()})
    print("Se crearon demo_admin y demo_consulta con hashes bcrypt y roles asignados.")


if __name__ == "__main__":
    main()
