# Sistema de Gestión de Expediciones Científicas Antárticas (PMV)

Aplicación web inicial desarrollada con **Streamlit**, **SQLAlchemy** y **PyMySQL** sobre **MySQL 8.4**, organizada en una arquitectura de tres capas y lista para ejecutarse con **Docker Compose** (incluyendo **phpMyAdmin**).

## Arquitectura en tres capas

```text
proyecto/
├── .env.example                 # Plantilla de variables de entorno (versionada)
├── .env                         # Variables reales locales (ignorada en Git)
├── .gitignore                   # Excluye secretos, caché y archivos temporales
├── Dockerfile                   # Imagen de Python 3.12 con Streamlit
├── docker-compose.yml           # Orquestación de db, phpmyadmin y app
├── requirements.txt             # Dependencias Python
├── main.py                      # Capa 1: Presentación (interfaz con Streamlit)
├── services/
│   ├── __init__.py
│   └── metricas_service.py      # Capa 2: Lógica de negocio y coordinación
├── db/
│   ├── __init__.py
│   ├── connection.py            # Capa 3: Conexión SQLAlchemy + PyMySQL y reintentos
│   └── dao.py                   # Capa 3: Consultas SQL parametrizadas (DAO)
├── tests/
│   └── test_conexion_dao.py     # Pruebas de conexión y consultas del DAO
└── sql/                         # Scripts DDL, datos iniciales, vistas y procedimientos
```

### Responsabilidades por capa
- **Presentación (`main.py`):** Renderiza la página de inicio, métricas y tablas en Streamlit sin ejecutar consultas SQL directas.
- **Lógica de negocio (`services/metricas_service.py`):** Verifica la disponibilidad de la base de datos, aplica filtros/reglas y obtiene los indicadores para la vista.
- **Acceso a datos (`db/connection.py` y `db/dao.py`):** Gestiona la conexión a MySQL (`mysql+pymysql`) usando variables de entorno y ejecuta consultas parametrizadas con `sqlalchemy.text()` sobre las tablas del esquema.

---

## Requisitos previos

- **Docker** y **Docker Compose** instalados (o entorno compatible como GitHub Codespaces).
- Archivo `.env` creado a partir de `.env.example` (nunca subas `.env` al repositorio).

---

## Puesta en marcha paso a paso

### 1. Configurar variables de entorno
Crea tu archivo `.env` local a partir de `.env.example` y define las credenciales de base de datos:

```bash
cp .env.example .env
```

Edita `.env` con tus valores locales (`MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD` y `STREAMLIT_SERVER_PORT`).

### 2. Construir y levantar los servicios
```bash
docker compose up -d --build
```

El servicio `db` cuenta con un `healthcheck` para asegurar que MySQL esté listo antes de que inicien `phpmyadmin` y `app`.

### 3. Acceder a la aplicación y a phpMyAdmin
- **Streamlit (app):** Disponible en el puerto **`8501`** (en GitHub Codespaces, revisa la pestaña **PORTS / Puertos**, asegúrate de reenviar el puerto `8501` y ábrelo en el navegador; en local, `http://localhost:8501`).
- **phpMyAdmin:** Disponible en el puerto **`8090`** (`http://localhost:8090`).

### 4. Ejecutar pruebas de conexión y DAO
```bash
docker compose exec app pytest -v tests/test_conexion_dao.py
```

### 5. Revisar estado y logs de contenedores
```bash
docker compose ps
docker compose logs -f app
```

### 6. Guardar cambios en Git
```bash
git status
git add .gitignore .env.example requirements.txt Dockerfile docker-compose.yml README.md main.py db/ services/ tests/
git commit -m "docs: agregar README del PMV con arquitectura y guion de ejecución"
git push origin HEAD
```

---

## Notas de seguridad
- Mantén `.env` fuera del control de versiones mediante `.gitignore`.
- Utiliza siempre consultas parametrizadas (`:parametro`) en `db/dao.py` y conecta la app al servicio `db` dentro de la red de Docker Compose.