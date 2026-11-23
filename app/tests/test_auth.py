"""Pruebas unitarias: válidas, erróneas, inexistente, inactiva y denegación DAO."""
import unittest
from unittest.mock import MagicMock, patch
import bcrypt
from services.auth_service import AuthService
from db.auth_dao import PermisoDenegado, exigir_administrador


class AuthTests(unittest.TestCase):
    def setUp(self):
        self.auth = AuthService(MagicMock())
        self.auth.dao = MagicMock()
        self.hash = bcrypt.hashpw(b"clave-de-prueba-larga", bcrypt.gensalt()).decode("ascii")

    def test_credenciales_validas(self):
        self.auth.dao.obtener_cuenta.return_value = {"idCuenta": "CTA-0056", "activa": 1, "claveAcceso": self.hash}
        self.auth.dao.obtener_sesion.return_value = {"idCuenta": "CTA-0056", "roles": ("ADMINISTRADOR",)}
        self.assertIsNotNone(self.auth.iniciar_sesion("demo_admin", "clave-de-prueba-larga"))

    def test_clave_incorrecta(self):
        self.auth.dao.obtener_cuenta.return_value = {"idCuenta": "CTA-0056", "activa": 1, "claveAcceso": self.hash}
        self.assertIsNone(self.auth.iniciar_sesion("demo_admin", "incorrecta"))

    def test_usuario_inexistente(self):
        self.auth.dao.obtener_cuenta.return_value = None
        self.assertIsNone(self.auth.iniciar_sesion("inexistente", "cualquiera"))

    def test_cuenta_inactiva(self):
        self.auth.dao.obtener_cuenta.return_value = {"idCuenta": "CTA-0056", "activa": 0, "claveAcceso": self.hash}
        self.assertIsNone(self.auth.iniciar_sesion("demo_admin", "clave-de-prueba-larga"))

    def test_hash_antiguo_no_admitido(self):
        self.auth.dao.obtener_cuenta.return_value = {"idCuenta": "CTA-0001", "activa": 1, "claveAcceso": "a" * 64}
        self.assertIsNone(self.auth.iniciar_sesion("antiguo", "cualquiera"))

    def test_no_autorizado_sin_sesion(self):
        with self.assertRaises(PermisoDenegado):
            exigir_administrador(MagicMock(), None)

    def test_consulta_no_puede_escribir(self):
        conn = MagicMock()
        conn.execute.side_effect = [MagicMock(first=lambda: ("CTA-0057",)), MagicMock(first=lambda: None)]
        with self.assertRaises(PermisoDenegado):
            exigir_administrador(conn, "CTA-0057")

    def test_administrador_puede_escribir(self):
        conn = MagicMock()
        conn.execute.side_effect = [MagicMock(first=lambda: ("CTA-0056",)), MagicMock(first=lambda: ("ROL-001",))]
        exigir_administrador(conn, "CTA-0056")


if __name__ == "__main__":
    unittest.main()
