"""Pruebas de validación, sin escribir en la base de datos."""
import unittest
from unittest.mock import MagicMock
from datetime import date
from decimal import Decimal
from services.video7_service import Video7Service


class ValidacionesVideo7(unittest.TestCase):
    def setUp(self):
        self.service = Video7Service(MagicMock())
        self.service.dao = MagicMock()

    def test_participacion_correcta(self):
        self.service.registrar_participacion("EX1", "P1", "Científico", date(2026, 11, 20), "ACTIVA", "")
        self.service.dao.crear_participacion.assert_called_once()

    def test_estado_invalido(self):
        with self.assertRaisesRegex(ValueError, "Estado"):
            self.service.registrar_participacion("EX1", "P1", "X", date.today(), "DESCONOCIDO", "")
        self.service.dao.crear_participacion.assert_not_called()

    def test_pais_presupuesto_negativo(self):
        with self.assertRaisesRegex(ValueError, "presupuesto"):
            self.service.guardar_pais("CH", "Chile", "Organismo", -1)

    def test_base_capacidad_invalida(self):
        with self.assertRaisesRegex(ValueError, "capacidad"):
            self.service.guardar_base("B1", "Base", "", None, 0, 10, "ALTO", "CH")

    def test_modificar_pais(self):
        self.service.guardar_pais("CH", "Chile", "Org", Decimal("10.00"), editar=True)
        self.service.dao.modificar_pais.assert_called_once()

    def test_crear_base(self):
        self.service.guardar_base("B1", "Base", "", None, 10, 100, "ALTO", "CH")
        self.service.dao.crear_base.assert_called_once()


if __name__ == "__main__":
    unittest.main()
