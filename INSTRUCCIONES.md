# Control de usuarios D10 — Caso 6 / Video 7

## Qué contiene el paquete

Rutas relativas a la raíz del repositorio:

- `app/db/auth_dao.py` **NUEVO**: búsqueda de cuentas y autorización en transacciones de escritura.
- `app/services/auth_service.py` **NUEVO**: login bcrypt, consulta de sesión.
- `app/scripts/__init__.py`, `app/scripts/crear_cuentas_demo.py` **NUEVOS**: alta manual y transaccional de dos cuentas con `getpass`, sin contraseñas en Git.
- `app/main.py` **REEMPLAZA**: mantiene métricas y `render_video7`, añade login/logout y sesión.
- `app/db/video7_dao.py` **REEMPLAZA**: conserva consultas/transacciones/reglas anteriores; exige cuenta administradora en cada operación de escritura.
- `app/services/video7_service.py` **REEMPLAZA**: conserva validaciones; propaga `actor_id`.
- `app/ui/video7_ui.py` **REEMPLAZA**: lectura para CONSULTA, formularios existentes para ADMINISTRADOR.
- `app/tests/test_video7_service.py` **REEMPLAZA**: adapta las pruebas existentes a `actor_id`.
- `app/tests/test_auth.py` **NUEVO**: pruebas unitarias de autenticación y autorizaciones.
- `requirements.txt` **REEMPLAZA**: añade `bcrypt==4.2.1`.

Los archivos `app/db/connection.py`, `app/db/dao.py`, `app/services/metricas_service.py`, `docker-compose.yml`, SQL y DDL **NO se cambian**.

## 1. Antes de instalar

Desde la raíz en Codespaces:

```bash
git status --short
cp -a app app_respaldo_antes_login
cp requirements.txt requirements_respaldo_login.txt
```

Descomprimir el ZIP en la raíz del repositorio conservando rutas. Revisar `git diff` y ejecutar:

```bash
python -m compileall -q app
# Si existen dependencias Python instaladas en el host:
PYTHONPATH=app python -m unittest discover -s app/tests -p 'test_*.py' -v
```

## 2. Construir contenedor (sin borrar datos)

```bash
docker compose build app
docker compose up -d --no-deps app
docker compose ps
```

Importante: el `Dockerfile` debe tener `COPY app/ ./` (coincide con el adjunto). Así los nuevos módulos se copian dentro del contenedor. No ejecutar `docker compose down -v` ni el DDL con `DROP DATABASE`.

## 3. Crear los dos usuarios (solo una vez)

```bash
docker compose exec -it app python -m scripts.crear_cuentas_demo
```

El script solicita de forma interactiva contraseña y confirmación para `demo_admin` y `demo_consulta`; **nunca se guardan en el repositorio**. Inserta el rol `CONSULTA` si falta y añade estas cuentas:

- `CTA-0056` / `demo_admin` / `PER-0056` / `ADMINISTRADOR`
- `CTA-0057` / `demo_consulta` / `PER-0057` / `CONSULTA`

Si cualquiera de las cuentas, personas asociadas, nombres, IDs o `ROL-004` está ocupado, detener y resolver antes. El script está diseñado para fallar sin sobrescribir cuentas existentes. No volver a ejecutarlo después de un alta exitosa.

## 4. Pruebas

```bash
docker compose exec app python -m unittest discover -s tests -p 'test_*.py' -v
docker compose ps
```

En Codespaces > Ports, abrir el puerto 8501 (darle acceso privado en pruebas). Comprobar:

1. `demo_admin` con contraseña correcta: acceso, métricas y todos los formularios.
2. Contraseña errónea: mensaje genérico de error.
3. Usuario inexistente: mensaje genérico de error.
4. `demo_consulta`: puede ver métricas, participaciones, países y bases, pero no encuentra controles de escritura.
5. Llamada directa no autorizada: `Video7DAO(engine).crear_pais({...}, actor_id='CTA-0057')` falla con `PermisoDenegado` antes del INSERT. Ejecutar preferentemente prueba unitaria, no una inserción real.
6. `demo_admin`: probar registro/CRUD solo sobre registros de ensayo, preservando las reglas anteriores.
7. Cerrar sesión: desaparece el contenido; sin login no aparecen datos.

Este paquete NO implementa dashboard, no incorpora las 12 consultas analíticas al PMV y no cambia DDL.

## Advertencias

- Las 55 cuentas anteriores usan hashes no-bcrypt según el archivo de poblamiento; esta versión **no las migra** y no permite inicio de sesión de esas cuentas hasta que se migren con procedimiento aprobado.
- Streamlit `st.session_state` no sustituye un proveedor de identidad ni crea una cookie de sesión persistente; las sesiones son por conexión. Este diseño es apropiado para la demostración local del PMV, no un despliegue público de producción sin controles adicionales (TLS, bloqueo por intentos, etc.).
- El acceso de aplicación a MySQL sigue usando el mismo usuario SQL del contenedor. La autorización se aplica en el código del PMV, y **no** debe considerarse protección frente a alguien con acceso directo a las credenciales de MySQL o al código Python del servidor.
- La prueba de permisos de consulta está en el DAO, no solamente en controles ocultos de Streamlit.
