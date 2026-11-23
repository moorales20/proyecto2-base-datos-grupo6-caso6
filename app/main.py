"""Inicio del PMV; login obligatorio antes de acceder a las métricas y al Video 7."""
import pandas as pd
import streamlit as st
from sqlalchemy.exc import SQLAlchemyError
from db.connection import create_db_engine
from services.metricas_service import MetricasService
from services.auth_service import AuthService
from ui.video7_ui import render_video7

st.set_page_config(page_title="Expediciones Antárticas — Inicio PMV", page_icon="🧊", layout="wide")


@st.cache_resource
def get_engine():
    return create_db_engine()


def main():
    st.title("🧊 Sistema de Gestión de Expediciones Científicas Antárticas")
    st.caption("Arquitectura en 3 capas (Presentación · Lógica de Negocio · DAO)")
    try:
        engine = get_engine()
        auth = AuthService(engine)
        # La sesión guarda solo el ID. Los roles se consultan otra vez en MySQL
        # en cada rerun y se verifican de nuevo dentro de cada transacción DML.
        id_cuenta = st.session_state.get("auth_id_cuenta")
        sesion = auth.sesion_actual(id_cuenta) if id_cuenta else None
        if id_cuenta and not sesion:
            st.session_state.pop("auth_id_cuenta", None)
        if not sesion:
            st.subheader("Iniciar sesión")
            with st.form("login"):
                nombre = st.text_input("Nombre de usuario")
                clave = st.text_input("Contraseña", type="password")
                enviar = st.form_submit_button("Entrar")
            if enviar:
                nueva = auth.iniciar_sesion(nombre, clave)
                if not nueva or not set(nueva["roles"]).intersection({"ADMINISTRADOR", "CONSULTA"}):
                    st.error("Credenciales inválidas o sin rol autorizado.")
                else:
                    st.session_state["auth_id_cuenta"] = nueva["idCuenta"]
                    st.rerun()
            return

        roles = set(sesion["roles"])
        if not roles.intersection({"ADMINISTRADOR", "CONSULTA"}):
            st.session_state.pop("auth_id_cuenta", None)
            st.error("La cuenta no tiene permisos de acceso al PMV.")
            return
        puede_editar = "ADMINISTRADOR" in roles
        with st.sidebar:
            st.write(f"Usuario: **{sesion['nombreUsuario']}**")
            st.write("Acceso: **Administrador**" if puede_editar else "Acceso: **Consulta**")
            if st.button("Cerrar sesión"):
                st.session_state.pop("auth_id_cuenta", None)
                st.rerun()

        st.subheader("Página de inicio")
        st.write("Verificación de conexión a MySQL 8.4 mediante SQLAlchemy + PyMySQL y consulta de indicadores reales sobre las tablas del DDL.")
        excluir_canceladas = st.checkbox("Excluir participaciones CANCELADAS en el conteo", value=False)
        service = MetricasService(engine)
        disponible, mensaje = service.verificar_disponibilidad()
        if not disponible:
            st.warning(f"MySQL aún no está disponible: {mensaje}")
            return
        st.success(mensaje)
        datos = service.obtener_indicadores_inicio(excluir_canceladas=excluir_canceladas)
        col1, col2 = st.columns(2)
        with col1:
            st.metric(label="Cantidad de personal registrado (PERSONAL)", value=datos["total_personal"])
        with col2:
            st.metric(label="Cantidad de participaciones registradas (PARTICIPACION)", value=datos["total_participaciones"])
        st.subheader("Expediciones por base (top 10)")
        if datos["expediciones_base"]:
            st.dataframe(pd.DataFrame(datos["expediciones_base"]), use_container_width=True, hide_index=True)
        else:
            st.info("No hay registros de expediciones para mostrar.")
        render_video7(engine, actor_id=sesion["idCuenta"], puede_editar=puede_editar)
    except ValueError as exc:
        st.error(f"Error de configuración de entorno: {exc}")
    except SQLAlchemyError:
        st.error("Error al consultar MySQL. Revisa el log del contenedor.")


if __name__ == "__main__":
    main()
