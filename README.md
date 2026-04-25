# Lectura y opinión — Setup completo

Stack: HTML/CSS/JS estático · Supabase (DB + Auth) · Netlify (hosting) · GitHub (deploy automático)

---

## Estructura de archivos

```
lectura-gas/
├── index.html              → Landing principal
├── biblioteca.html         → Biblioteca pública de libros
├── admin/
│   └── index.html          → Panel de administración (solo vos)
├── css/
│   └── style.css           → Estilos globales
├── img/
│   └── foto-perfil.jpg     → Tu foto para el hero (agregar a mano)
├── supabase-setup.sql      → SQL para crear la tabla en Supabase
└── README.md               → Este archivo
```

---

## PASO 1 — Configurar Supabase

### 1.1 Crear la tabla

1. Entrá a https://supabase.com/dashboard/project/dnffifdouniqirlljrse
2. Ir a **SQL Editor** → **New query**
3. Pegá el contenido completo de `supabase-setup.sql`
4. Hacé clic en **Run**

Eso crea la tabla `libros` con todas las columnas, los permisos correctos y 4 libros de ejemplo.

### 1.2 Crear tu usuario admin

1. En el dashboard de Supabase ir a **Authentication** → **Users**
2. Clic en **Add user** → **Create new user**
3. Email: `gastonsilvetti00@gmail.com`
4. Contraseña: la que quieras (guardala bien)
5. Confirmar

Con eso ya podés loguearte en `/admin`.

---

## PASO 2 — Subir a GitHub

```bash
# Clonar el repo vacío
git clone https://github.com/gastonsilvetti00-max/Lectura-gas.git
cd Lectura-gas

# Copiar todos los archivos de este proyecto adentro
# Agregar tu foto como img/foto-perfil.jpg

git add .
git commit -m "Setup inicial"
git push origin main
```

---

## PASO 3 — Conectar Netlify con GitHub

1. Entrar a https://app.netlify.com
2. **Add new site** → **Import an existing project**
3. Elegir **GitHub** → seleccionar el repo `Lectura-gas`
4. Configuración:
   - **Branch to deploy:** `main`
   - **Build command:** (dejar vacío)
   - **Publish directory:** `.` (punto — porque es el raíz)
5. **Deploy site**

Cada vez que hagas `git push`, Netlify actualiza el sitio automáticamente.

---

## Cómo agregar un libro

1. Entrar a `tu-sitio.netlify.app/admin`
2. Loguearse con el email y contraseña que creaste en Supabase
3. Completar el formulario y hacer clic en **Publicar libro**
4. El libro aparece en la biblioteca inmediatamente, sin re-deploy

---

## Cómo activar tu foto en el hero

Guardá tu foto como `img/foto-perfil.jpg` en el proyecto (cuadrada, ~800×800px recomendado).
Hacé commit y push, y Netlify la sube automáticamente.

---

## Si querés agregar una categoría nueva

En `biblioteca.html` y en `admin/index.html`, buscá el objeto `CATEGORIAS` y agregá la nueva categoría.
También hay que agregar el valor al `CHECK` en la base de datos (Supabase → Table Editor → libros → columna `categoria`).

---

## Seguridad del panel admin

- El panel `/admin` tiene login con Supabase Auth
- Row Level Security (RLS) activo: los visitantes solo pueden **leer** libros, nunca escribir
- Solo usuarios autenticados pueden agregar/editar/borrar
- La anon key que está en el código solo permite operaciones de lectura pública por diseño

---

## Links del proyecto

- **Sitio:** https://tu-sitio.netlify.app
- **Admin:** https://tu-sitio.netlify.app/admin
- **Supabase:** https://supabase.com/dashboard/project/dnffifdouniqirlljrse
- **GitHub:** https://github.com/gastonsilvetti00-max/Lectura-gas
- **Instagram:** https://instagram.com/gastonsilvetti
- **Newsletter:** https://gastonsilvetti.substack.com
