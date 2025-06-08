


# 🛍️ Ecommerce App

<div align="center">

**Una sencilla aplicación de comercio electrónico moderna desarrollada con Flutter e integrada con Firebase**

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

</div>

## 📋 Descripción

Esta una pequeña aplicación móvil de ejemplo con tematica tienda en línea desarrollada con Flutter que permite a los usuarios explorar productos, filtrar por categorías y gestionar su autenticación. La aplicación consume la API de FakeStore para obtener productos reales y utiliza Firebase para la autenticación de usuarios.

## ✨ Características Principales

- **🛒 Catálogo de Productos**: Visualización de productos con imágenes, precios y descripciones
- **🔍 Filtrado por Categorías**: Sistema de filtros dinámicos para navegar por categorías 
- **🔐 Autenticación Firebase**: Sistema completo de registro e inicio de sesión
- **🎨 Diseño Moderno**: Interfaz estilizada con Google Fonts y Material Design
- **📱 Multiplataforma**: Compatible con Android, iOS, Web y Desktop
## 🏗️ Arquitectura

La aplicación sigue una arquitectura organizada y escalable:

```
lib/
├── models/          # Modelos de datos
├── services/        # Servicios de API y autenticación
├── screens/         # Pantallas de la aplicación
├── widgets/         # Componentes reutilizables
└── main.dart        # Punto de entrada
```

### Componentes Principales

- **ApiService**: Maneja las llamadas a la FakeStore API
- **AuthService**: Gestiona la autenticación con Firebase
- **Product Model**: Modelo de datos para productos
- **HomeScreen**: Pantalla principal con listado de productos

## 🛠️ Tecnologías y Dependencias

### Principales
- **Flutter SDK**: ^3.8.1
- **Firebase Core**: ^3.13.1
- **Firebase Auth**: ^5.5.4
- **HTTP**: ^1.2.1
- **Google Fonts**: ^6.2.1

### Desarrollo y Testing
- **Mockito**: ^5.4.4 para tests unitarios
- **Build Runner**: ^2.4.11 para generación de código
- **Flutter Lints**: ^5.0.0 para análisis de código

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.8.1 o superior
- Dart SDK
- Android Studio / Xcode (para desarrollo móvil)
- Cuenta de Firebase configurada

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/Gemeto/ecommerceApp.git
cd ecommerceApp
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase**
   - Configura tu proyecto Firebase
   - Agrega los archivos de configuración necesarios

4. **Generar archivos de mock para testing**
```bash
flutter pub run build_runner build
```

5. **Ejecutar la aplicación**
```bash
flutter run
```

## 🧪 Testing

La aplicación incluye tests unitarios completos para los servicios principales:

- **API Service Tests**: Pruebas para la integración con FakeStore API
- **Mocking**: Uso de Mockito para simular respuestas HTTP

Para ejecutar los tests:
```bash
flutter test
```

## 🎨 Diseño y UI

La aplicación presenta un diseño moderno y consistente:

- **Tema Personalizado**: Esquema de colores basado en Teal 
- **Tipografía**: Combinación de Montserrat y Lato fonts
- **Componentes Estilizados**: Cards, botones y dropdowns con diseño consistente

## 📱 Funcionalidades de Usuario

### Autenticación
- Registro de nuevos usuarios
- Inicio de sesión con email y contraseña
- Cierre de sesión
- Estados de autenticación en tiempo real

### Navegación de Productos
- Listado completo de productos
- Filtrado por categorías dinámicas
- Información detallada de cada producto
- Interfaz responsiva y optimizada

## 📊 API Integration

La aplicación se integra con la **FakeStore API** para obtener:
- Lista de productos con detalles completos
- Categorías disponibles para filtrado
- Manejo de errores y estados de carga

## 🛡️ Seguridad y Buenas Prácticas

- Validación de formularios de autenticación
- Manejo seguro de estados de autenticación
- Gestión de errores robusta
- Tests unitarios con cobertura de casos edge
- Linting y análisis de código estático

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor, sigue estos pasos:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

<div align="center">

**Desarrollado con ❤️ usando Flutter**

</div>
