"""Validaciones de negocio del Video 7."""
from datetime import date
from decimal import Decimal
from db.video7_dao import Video7DAO

ESTADOS = ("ACTIVA", "FINALIZADA", "PENDIENTE", "CANCELADA")
AISLAMIENTOS = ("BAJO", "MEDIO", "ALTO", "EXTREMO")


class Video7Service:
    def __init__(self, engine):
        self.dao = Video7DAO(engine)

    def registrar_participacion(self, id_expedicion, id_personal, funcion, fecha, estado, observaciones):
        funcion = funcion.strip()
        observaciones = observaciones.strip()
        if not id_expedicion or not id_personal:
            raise ValueError("Seleccione una expedición y una persona.")
        if not funcion or len(funcion) > 80:
            raise ValueError("La función es obligatoria y debe tener como máximo 80 caracteres.")
        if estado not in ESTADOS:
            raise ValueError("Estado de participación inválido.")
        if len(observaciones) > 250:
            raise ValueError("Las observaciones no pueden superar 250 caracteres.")
        if not isinstance(fecha, date):
            raise ValueError("Fecha de incorporación inválida.")
        self.dao.crear_participacion({
            "idExpedicion": id_expedicion, "idPersonal": id_personal,
            "funcion": funcion, "fechaIncorporacion": fecha,
            "estado": estado, "observaciones": observaciones or None,
        })

    def guardar_pais(self, id_pais, nombre, organismo, presupuesto, editar=False):
        data = {"idPais": id_pais.strip(), "nombreOficial": nombre.strip(),
                "organismoResponsable": organismo.strip(), "presupuestoAnual": Decimal(str(presupuesto))}
        if not 1 <= len(data["idPais"]) <= 10:
            raise ValueError("El ID del país debe tener entre 1 y 10 caracteres.")
        if not data["nombreOficial"] or len(data["nombreOficial"]) > 100:
            raise ValueError("Nombre oficial inválido (máximo 100 caracteres).")
        if not data["organismoResponsable"] or len(data["organismoResponsable"]) > 120:
            raise ValueError("Organismo responsable inválido (máximo 120 caracteres).")
        if data["presupuestoAnual"] < 0:
            raise ValueError("El presupuesto no puede ser negativo.")
        (self.dao.modificar_pais if editar else self.dao.crear_pais)(data)

    def guardar_base(self, id_base, nombre, ubicacion, instalacion, capacidad,
                     presupuesto, aislamiento, id_pais, editar=False):
        data = {"idBase": id_base.strip(), "nombre": nombre.strip(),
                "ubicacion": ubicacion.strip() or None, "fechaInstalacion": instalacion,
                "capacidadMaxima": int(capacidad), "presupuesto": Decimal(str(presupuesto)),
                "nivelAislamiento": aislamiento, "idPais": id_pais}
        if not 1 <= len(data["idBase"]) <= 10:
            raise ValueError("El ID de la base debe tener entre 1 y 10 caracteres.")
        if not data["nombre"] or len(data["nombre"]) > 100:
            raise ValueError("Nombre de base inválido (máximo 100 caracteres).")
        if data["ubicacion"] and len(data["ubicacion"]) > 150:
            raise ValueError("La ubicación supera 150 caracteres.")
        if data["capacidadMaxima"] <= 0 or data["presupuesto"] < 0:
            raise ValueError("La capacidad debe ser positiva y el presupuesto no negativo.")
        if aislamiento not in AISLAMIENTOS or not id_pais:
            raise ValueError("Seleccione un país y nivel de aislamiento válidos.")
        (self.dao.modificar_base if editar else self.dao.crear_base)(data)
