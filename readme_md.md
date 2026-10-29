# sistemamovil

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

* [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)

* [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)

* [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Uso de Inteligencia Artificial en el Proyecto

###  Áreas de apoyo con IA:

* **Resolución de Errores e Inconsistencias:** Corrección rápida de fallos en la lógica de la aplicación.

* **Gestión de Datos:** Apoyo en la creación de proveedores (*providers*) para el manejo de usuarios y ventas.

* **Navegación e Interfaz:** Asistencia en la vinculación y flujo entre pantallas pendientes.

###  Commits Clave con Apoyo de IA

1. **`feat: corrigiendo inconsistenciay errores de logica con IA`**

   * Corrección de inconsistencias generales en el código mediante asistencia de IA.

2. **`feat: add user and sales management providers, screens, and models`**

   * Desarrollo de la lógica de gestión de usuarios y ventas con apoyo de IA.

3. **`FEAT: conexion de pantallas faltantes`**

   * Vinculación y estructuración de la interfaz gráfica y pantallas del sistema.

##  Análisis Técnico de Errores y Plan de Corrección

Durante el desarrollo y auditoría del sistema móvil en Flutter, se identificaron y resolvieron diversos puntos críticos agrupados en cuatro categorías principales:

### 1. Errores Críticos de Lógica y Estado

* **Carrito de Comandas Compartido:** `OrderCartManager` funcionaba como un Singleton con una única lista global (`_items`), lo que provocaba que los platillos agregados a una mesa se mezclaran con las demás. *Solución:* Se segmentó el carrito por identificador de mesa (`_cartsByMesa`) y se implementó un gestor de mesa activa (`activeMesa`).

* **Fuga de Estado al Cerrar Sesión:** Al hacer *logout*, los datos en memoria de los *providers* (`UserProvider`, `VentasProvider`, `InventarioProvider`, `PedidosProvider`) no se limpiaban, permitiendo que un nuevo usuario heredara información o accesos de la sesión anterior. *Solución:* Se añadió la limpieza explícita de todos los estados al cerrar sesión.

* **Pérdida de Preferencias Locales:** `AuthRepository.logout()` borraba todo el almacenamiento seguro, eliminando las configuraciones de `SettingsScreen` (stock mínimo, notificaciones, etc.). *Solución:* Se ajustó `SecureStorageService.clearAll` para eliminar únicamente las credenciales de sesión, preservando las preferencias del dispositivo.

* **Reactivación Involuntaria de Usuarios:** Al editar un usuario, el modelo asignaba por defecto `activo = true`, reactivando cuentas inactivas. *Solución:* Se aseguró que el diálogo de edición conserve el estado original (`activo: user.activo`).

* **Filtros y Platillos No Disponibles en Catálogo:** `MenuCatalogScreen` mostraba platillos agotados y fallaba al filtrar por categoría cuando el backend no enviaba el nombre explícito. *Solución:* Se filtró por `p.disponible == true` y se cruzó el ID con el catálogo de categorías local.

### 2.  Errores de Lógica de Negocio y Cálculos

* **Métrica de Usuarios Activos:** La tarjeta informativa mostraba el conteo total de registros en lugar de filtrar únicamente los activos. *Solución:* Se corrigió el filtro utilizando `u.activo == true`.

* **Cálculo de Fechas y Totales en Historial de Ventas:** La función `_formatFecha` utilizaba una diferencia estricta de horas (truncando a 24h) en lugar de comparar días calendario, y el acumulado sumaba registros cancelados. *Solución:* Se implementó una comparación por día real y se excluyeron las ventas canceladas del cálculo de ingresos.

* **Umbral de Stock Mínimo Ignorado:** La configuración de stock mínimo establecida en *Ajustes* no se comunicaba con el inventario. *Solución:* Se integró el valor almacenado en `SecureStorageService` dentro de `InventarioProvider`.

* **Inconsistencia de Moneda:** `AuditLogsScreen` mostraba métricas con el símbolo de dólar (`$`) en lugar de Córdobas (`C$`). *Solución:* Se unificó el estándar monetario en toda la interfaz.

* **Actualización de Estado en Mesas:** Al enviar una comanda o regresar de la vista de carrito, el estado visual de las mesas no se refrescaba automáticamente. *Solución:* Se forzó la recarga del método `_cargarMesas()` al retornar de la navegación.

### 3. Errores de Red, Serialización y API

* **Control de Excepciones en `ApiClient`:** Respuestas en texto plano (como "OK") provocaban un `FormatException` al intentar parsearlas como JSON, además de carecer de un tiempo de espera (*timeout*). *Solución:* Se implementó un *timeout* global de 20 segundos y un manejo seguro de respuestas no JSON.

* **Rutas y Métodos HTTP:** Se corrigió un espacio sin codificar en la ruta de actualización de usuarios en `ApiConstants` y se añadió un respaldo automático con método `DELETE` en el repositorio de usuarios en caso de que `PUT` devuelva un error 405.

* **Mapeo de Roles en `UserModel`:** Se depuró código muerto (`dead code`) en el deserializador y se mejoró la resolución del nombre del rol a partir del `rolId`.

* **Verificación de Sesión Inicial:** La aplicación iniciaba por defecto en la pantalla de *Login* sin comprobar si ya existía una sesión guardada. *Solución:* Se añadió la verificación de estado al arrancar la app (`main.dart`).

### 4.  Fugas de Memoria y Controles UI sin Funcionalidad

* **Controladores sin `dispose()`:** Se añadieron métodos de liberación de memoria (`dispose()`) para los `TextEditingController` en `LoginScreen` y en los diálogos de gestión de usuarios, previniendo fugas de memoria.

* **Chips de Filtro Interactivos:** Se habilitaron las acciones táctiles y la lógica de filtrado en los componentes visuales de `SalesHistoryScreen` (fechas, montos, estados) y `AuditLogsScreen` (tipo de eventos, usuarios).