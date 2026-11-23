"""Autenticación bcrypt y consulta de permisos actuales."""
import bcrypt
from db.auth_dao import AuthDAO


class AuthService:
    def __init__(self, engine):
        self.dao = AuthDAO(engine)

    def iniciar_sesion(self, nombre_usuario, contrasena):
        # Nunca registrar ni guardar la contraseña recibida.
        cuenta = self.dao.obtener_cuenta(nombre_usuario.strip()) if nombre_usuario else None
        hash_guardado = cuenta["claveAcceso"] if cuenta else ""
        # Las contraseñas antiguas no-bcrypt no se aceptan por diseño.
        if not hash_guardado.startswith(("$2a$", "$2b$", "$2y$")):
            return None
        try:
            correcta = bcrypt.checkpw(contrasena.encode("utf-8"), hash_guardado.encode("ascii"))
        except (ValueError, UnicodeError):
            return None
        if not correcta or not bool(cuenta["activa"]):
            return None
        return self.dao.obtener_sesion(cuenta["idCuenta"])

    def sesion_actual(self, id_cuenta):
        return self.dao.obtener_sesion(id_cuenta)
