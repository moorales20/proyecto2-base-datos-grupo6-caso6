import pandas as pd
import streamlit as st
from sqlalchemy.exc import SQLAlchemyError

from db.connection import create_db_engine
from services.metricas_service import MetricasService
from ui.video7_ui import render_video7

st.set_page_config(
    page_title="Expediciones Antárticas — Inicio PMV",
    page_icon="🧊",
    layout="wide",
)


@st.cache_resource
def get_service() -> MetricasService:
    engine = create_db_engine()
    return MetricasService(engine)


def main() -> None:
    st.title("🧊 Sistema de Gestión de Expediciones Científicas Antárticas")
    st.caption("Arquitectura en 3 capas (Presentación · Lógica de Negocio · DAO)")

    st.subheader("Página de inicio")
    st.write(
        "Verificación de conexión a MySQL 8.4 mediante SQLAlchemy + PyMySQL "
        "y consulta de indicadores reales sobre las tablas del DDL."
    )

    excluir_canceladas = st.checkbox(
        "Excluir participaciones CANCELADAS en el conteo",
        value=False,
    )

    try:
        service = get_service()
        disponible, mensaje = service.verificar_disponibilidad()

        if not disponible:
            st.warning(f"MySQL aún no está disponible: {mensaje}")
            st.info("Si acabas de ejecutar `docker compose up -d --build`, espera unos segundos y recarga.")
            return

        st.success(mensaje)

        datos = service.obtener_indicadores_inicio(excluir_canceladas=excluir_canceladas)

        col1, col2 = st.columns(2)
        with col1:
            st.metric(
                label="Cantidad de personal registrado (PERSONAL)",
                value=datos["total_personal"],
            )
        with col2:
            st.metric(
                label="Cantidad de participaciones registradas (PARTICIPACION)",
                value=datos["total_participaciones"],
            )

        st.subheader("Expediciones por base (top 10)")
        if datos["expediciones_base"]:
            df = pd.DataFrame(datos["expediciones_base"])
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No hay registros de expediciones para mostrar.")

        render_video7(service.engine)

    except ValueError as exc:
        st.error(f"Error de configuración de entorno: {exc}")
    except SQLAlchemyError as exc:
        st.error(f"Error al consultar la base de datos: {exc}")


if __name__ == "__main__":
    main()
