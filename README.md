# Dev-Profiler
Es una herramienta de evaluación diseñada para identificar el rol dominante de un desarrollador dentro del ciclo de resolución de problemas. Basado en metodologías de pensamiento creativo, se clasifica a los usuarios en cuatro perfiles clave:

Ideador: Generador de posibilidades y visión global.

Clarificador: Experto en datos y definición precisa del problema.

Desarrollador: Arquitecto de soluciones y prototipos funcionales.

Implementador: Motor de acción que lleva las ideas al cierre.

# Estado Inicial del Repositorio
El proyecto fue inicializado utilizando GitHub Copilot para establecer una base siguiendo los principios de Clean Architecture.

## 1. **Estructura de Directorios**
El repositorio ya cuenta con la organización de carpetas necesaria para un desarrollo escalable:
- `lib/` : Contiene el código fuente principal de la aplicación en Dart. Esta carpeta está destinada a albergar las capas de Data, Domain y Presentation.
- `database/`: Carpeta que contiene scripts iniciales para la configuración de Firebase.
- `assets/images/`: Directorio preparado para recursos visuales como logotipos o iconos.
- `test/`: Espacio dedicado para pruebas unitarias y de integración.


## 2. **Configuración y Tecnologías**
- **Lenguajes**: Flutter es el framework principal.

- **Arquitectura**: Esquema de Clean Architecture para mantener el código organizado y modular. Está la capa de Domain para la lógica de negocio, Data para la interacción con Firebase y Presentation para la interfaz de usuario.

- **Gestión de Dependencias (pubspec.yaml)**: Es el archivo de configuración que permite gestionar los paquetes de Flutter y, próximamente, las integraciones con Firebase.

- **Firebase**: Es el backend de la aplicación, es decir, el servidor y la base de datos que viven en la nube. FirebaseAuth se encarga de que los usuarios puedan registrarse e iniciar sesión de forma segura, mientras que Firestore es la base de datos donde se almacenan las respuestas de los usuarios y sus perfiles, y Firebase Storage se utiliza para guardar las imágenes de perfil de los usuarios.

3. **BLoC (Business Logic Component)**: Es un patrón de diseño y librería para Flutter que separa la lógica de negocio de la interfaz de usuario (UI), facilitando la gestión de estado reactiva, la escalabilidad y el testeo del código. Actúa como intermediario, recibiendo eventos de la vista y emitiendo nuevos estados mediante Streams. Se diferencia de clean architecture en que BLoC es un patrón específico para la gestión de estado, mientras que clean architecture es un enfoque más amplio para organizar el código en capas. En este proyecto, se utiliza BLoC dentro de la capa de Presentation para manejar la lógica de interacción con el usuario y mantener la UI reactiva.

## Roadmap de Desarrollo
1. **Capa de Dominio (Domain)**: Definir qué son las cosas (Entidades) y qué hace la app (Casos de Uso) sin tocar nada de Firebase ni de pantallas.

2. **Capa de Datos (Data)**: Conectar con Firebase. Implementamos los "repositorios" que guardan y traen la información de Firestore.

3. **Capa de Presentación (Presentation)**: Crear los BLoCs para manejar la lógica de las pantallas y finalmente diseñamos las interfaces en Flutter.