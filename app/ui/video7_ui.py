"""Interfaz Video 7; lectura para CONSULTA y escritura para ADMINISTRADOR."""
from datetime import date
import pandas as pd
import streamlit as st
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from db.auth_dao import PermisoDenegado
from services.video7_service import Video7Service, ESTADOS, AISLAMIENTOS


def _ejecutar(funcion):
    try:
        funcion()
    except (ValueError, PermisoDenegado) as exc:
        st.error(str(exc))
    except IntegrityError:
        st.error("MySQL rechazó la operación por clave duplicada, referencia o restricción. No se guardaron cambios.")
    except SQLAlchemyError:
        st.error("Error de base de datos. La transacción se revirtió. Revisa el log del contenedor.")
    else:
        st.success("Operación realizada correctamente.")


def _seleccionar(label, rows, key, formato):
    choices = {r[key]: formato(r) for r in rows}
    if not choices:
        st.warning(f"No hay registros disponibles para {label.lower()}.")
        return None
    return st.selectbox(label, list(choices), format_func=lambda value: choices[value])


def _participaciones(svc, puede_editar):
    st.subheader("Participaciones en expedición")
    if puede_editar:
        expediciones = svc.dao.listar_expediciones()
        personal = svc.dao.listar_personal()
        if not expediciones or not personal:
            st.info("Para registrar una participación se requieren expediciones y personal existentes.")
        else:
            expedicion = _seleccionar("Expedición", expediciones, "idExpedicion", lambda r: f"{r['idExpedicion']} — {r['base']}")
            persona = _seleccionar("Personal", personal, "idPersonal", lambda r: f"{r['idPersonal']} — {r['nombres']} {r['apellidos']}")
            exp = next((e for e in expediciones if e['idExpedicion'] == expedicion), None)
            if exp:
                st.caption(f"Inicio: {exp['fechaInicio']} · Duración: {exp['duracionDias']} días · Capacidad: {exp['capacidadMaxima']}")
            with st.form("form_participacion", clear_on_submit=False):
                funcion = st.text_input("Función", max_chars=80)
                fecha = st.date_input("Fecha de incorporación", value=exp['fechaInicio'] if exp else date.today())
                estado = st.selectbox("Estado", ESTADOS)
                observaciones = st.text_area("Observaciones (opcional)", max_chars=250)
                enviado = st.form_submit_button("Registrar participación")
            if enviado:
                _ejecutar(lambda: svc.registrar_participacion(expedicion, persona, funcion, fecha, estado, observaciones))
    st.markdown("#### Consultar participaciones")
    filtro = st.text_input("Buscar por ID de expedición o personal", key="buscar_participacion")
    st.dataframe(pd.DataFrame(svc.dao.listar_participaciones(filtro)), use_container_width=True, hide_index=True)


def _crud_paises(svc, puede_editar):
    st.subheader("Países")
    filtro = st.text_input("Buscar país", key="buscar_pais")
    rows = svc.dao.listar_paises(filtro)
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)
    if not puede_editar:
        return
    accion = st.radio("Operación de país", ["Crear", "Modificar", "Eliminar"], horizontal=True, key="accion_pais")
    paises = svc.dao.listar_paises()
    elegido = None
    actual = {}
    if accion != "Crear":
        elegido = _seleccionar("País existente", paises, "idPais", lambda r: f"{r['idPais']} — {r['nombreOficial']}")
        actual = next((r for r in paises if r["idPais"] == elegido), {})
        if not actual:
            return
    if accion == "Eliminar":
        st.warning("Solo se eliminará si el país no tiene bases asociadas.")
        with st.form("borrar_pais"):
            confirma = st.checkbox("Confirmo que deseo eliminar este país")
            enviar = st.form_submit_button("Eliminar país")
        if enviar:
            if not confirma:
                st.error("Confirma la eliminación.")
            else:
                _ejecutar(lambda: svc.dao.eliminar_pais(elegido, actor_id=svc.actor_id))
        return
    with st.form("pais_editar" if actual else "pais_crear"):
        if actual:
            st.text_input("ID país (no modificable)", value=elegido, disabled=True)
            pk = elegido
        else:
            pk = st.text_input("ID país", max_chars=10)
        nombre = st.text_input("Nombre oficial", value=actual.get("nombreOficial", ""), max_chars=100)
        organismo = st.text_input("Organismo responsable", value=actual.get("organismoResponsable", ""), max_chars=120)
        presupuesto = st.number_input("Presupuesto anual", min_value=0.0,
                                     value=float(actual.get("presupuestoAnual", 0)), step=1000.0, format="%.2f")
        enviar = st.form_submit_button("Guardar país")
    if enviar:
        _ejecutar(lambda: svc.guardar_pais(pk, nombre, organismo, presupuesto, editar=bool(actual)))


def _crud_bases(svc, puede_editar):
    st.subheader("Bases")
    filtro = st.text_input("Buscar base", key="buscar_base")
    rows = svc.dao.listar_bases(filtro)
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)
    if not puede_editar:
        return
    accion = st.radio("Operación de base", ["Crear", "Modificar", "Eliminar"], horizontal=True, key="accion_base")
    bases = svc.dao.listar_bases()
    actual = {}
    elegido = None
    if accion != "Crear":
        elegido = _seleccionar("Base existente", bases, "idBase", lambda r: f"{r['idBase']} — {r['nombre']}")
        actual = next((r for r in bases if r["idBase"] == elegido), {})
        if not actual:
            return
    if accion == "Eliminar":
        st.warning("No se eliminará una base que tenga sectores o expediciones, para evitar borrados en cascada.")
        with st.form("borrar_base"):
            confirma = st.checkbox("Confirmo que deseo eliminar esta base")
            enviar = st.form_submit_button("Eliminar base")
        if enviar:
            if not confirma:
                st.error("Confirma la eliminación.")
            else:
                _ejecutar(lambda: svc.dao.eliminar_base(elegido, actor_id=svc.actor_id))
        return
    paises = svc.dao.listar_paises()
    if not paises:
        st.warning("Primero debes registrar un país.")
        return
    ids_paises = [p["idPais"] for p in paises]
    with st.form("base_editar" if actual else "base_crear"):
        if actual:
            st.text_input("ID base (no modificable)", value=elegido, disabled=True)
            pk = elegido
        else:
            pk = st.text_input("ID base", max_chars=10)
        nombre = st.text_input("Nombre de base", value=actual.get("nombre", ""), max_chars=100)
        ubicacion = st.text_input("Ubicación (opcional)", value=actual.get("ubicacion") or "", max_chars=150)
        tiene_fecha = st.checkbox("Registrar fecha de instalación", value=bool(actual.get("fechaInstalacion")))
        instalacion = st.date_input("Fecha de instalación", value=actual.get("fechaInstalacion") or date.today()) if tiene_fecha else None
        capacidad = st.number_input("Capacidad máxima", min_value=1, max_value=100000,
                                    value=int(actual.get("capacidadMaxima") or 1), step=1)
        presupuesto = st.number_input("Presupuesto", min_value=0.0,
                                     value=float(actual.get("presupuesto") or 0), step=1000.0, format="%.2f")
        aislamiento = st.selectbox("Nivel de aislamiento", AISLAMIENTOS,
                                   index=AISLAMIENTOS.index(actual.get("nivelAislamiento", "BAJO")))
        seleccion_pais = st.selectbox("País", ids_paises,
                                     index=ids_paises.index(actual.get("idPais")) if actual.get("idPais") in ids_paises else 0,
                                     format_func=lambda x: next(p["nombreOficial"] for p in paises if p["idPais"] == x))
        enviar = st.form_submit_button("Guardar base")
    if enviar:
        _ejecutar(lambda: svc.guardar_base(pk, nombre, ubicacion, instalacion, capacidad,
                                            presupuesto, aislamiento, seleccion_pais, editar=bool(actual)))


def render_video7(engine, actor_id, puede_editar):
    svc = Video7Service(engine, actor_id=actor_id)
    st.divider()
    st.header("Video 7 · Operaciones del PMV")
    if not puede_editar:
        st.info("Rol de consulta: puedes visualizar los datos, pero no modificarlos.")
    tab_part, tab_paises, tab_bases = st.tabs(["Participaciones", "PAIS", "BASE"])
    with tab_part:
        _participaciones(svc, puede_editar)
    with tab_paises:
        _crud_paises(svc, puede_editar)
    with tab_bases:
        _crud_bases(svc, puede_editar)
