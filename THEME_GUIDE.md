# Sistema de Temas - iCongrega

Este proyecto implementa un sistema completo de temas que permite cambiar dinámicamente entre modo claro, oscuro y sistema.

## Estructura de Archivos

```
lib/
├── theme/
│   ├── app_colors.dart      # Definición de colores base
│   ├── app_palette.dart     # Extensión de tema con colores personalizados
│   ├── app_theme.dart       # Configuración de temas claro y oscuro
│   ├── color_schemes.dart   # Esquemas de colores Material 3
│   └── theme_helpers.dart   # Extensiones para acceder fácilmente a colores
├── providers/
│   └── theme_provider.dart  # Provider para gestión de estado del tema
└── ui/
    ├── widgets/
    │   ├── theme_toggle_widgets.dart  # Widgets para cambiar tema
    │   └── theme_example_widget.dart  # Ejemplo de uso de colores
    └── screens/
        └── settings/
            └── settings_screen.dart   # Pantalla de configuración
```

## Uso Básico

### 1. Acceder a colores del tema

```dart
import 'package:icongrega/theme/theme_helpers.dart';

Widget build(BuildContext context) {
  return Container(
    color: context.colors.surface,           // Color de superficie
    child: Text(
      'Hola',
      style: TextStyle(
        color: context.colors.onSurface,     // Color de texto
      ),
    ),
  );
}
```

### 2. Usar colores semánticos personalizados

```dart
Widget build(BuildContext context) {
  return Container(
    color: context.palette.successLight,     // Color de éxito
    child: Icon(
      Icons.check,
      color: context.palette.successDark,    // Color de éxito oscuro
    ),
  );
}
```

### 3. Cambiar tema programáticamente

```dart
import 'package:provider/provider.dart';
import 'package:icongrega/providers/theme_provider.dart';

// Cambiar a tema oscuro
Provider.of<ThemeProvider>(context, listen: false).setDarkTheme();

// Cambiar a tema claro
Provider.of<ThemeProvider>(context, listen: false).setLightTheme();

// Usar tema del sistema
Provider.of<ThemeProvider>(context, listen: false).setSystemTheme();

// Alternar entre temas
Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
```

## Widgets de Toggle de Tema

### ThemeToggleButton
Botón con menú desplegable para seleccionar tema:

```dart
ThemeToggleButton(
  showLabel: true,
  lightLabel: 'Claro',
  darkLabel: 'Oscuro',
  systemLabel: 'Sistema',
)
```

### ThemeToggleSwitch
Switch para alternar entre claro y oscuro:

```dart
ThemeToggleSwitch(
  showLabel: true,
  lightLabel: 'Claro',
  darkLabel: 'Oscuro',
)
```

### ThemeToggleChip
Chips para seleccionar tema:

```dart
ThemeToggleChip(
  showLabel: true,
  lightLabel: 'Claro',
  darkLabel: 'Oscuro',
  systemLabel: 'Sistema',
)
```

## Colores Disponibles

### Colores del ColorScheme (Material 3)
- `context.colors.primary` - Color primario
- `context.colors.onPrimary` - Color sobre primario
- `context.colors.secondary` - Color secundario
- `context.colors.onSecondary` - Color sobre secundario
- `context.colors.surface` - Color de superficie
- `context.colors.onSurface` - Color sobre superficie
- `context.colors.error` - Color de error
- `context.colors.onError` - Color sobre error

### Colores Semánticos (AppPalette)
- `context.palette.successLight/Dark` - Colores de éxito
- `context.palette.dangerLight/Dark` - Colores de peligro/error
- `context.palette.warningLight/Dark` - Colores de advertencia
- `context.palette.infoLight/Dark` - Colores de información
- `context.palette.primaryLight/Dark` - Colores primarios personalizados

### Colores de Fondo por Capas
- `context.palette.botLight/Dark` - Fondo base
- `context.palette.midLight/Dark` - Fondo medio
- `context.palette.topLight/Dark` - Fondo superior

### Colores Neutrales
- `context.palette.neutralPrimaryLight/Dark` - Neutral primario
- `context.palette.neutralSecondaryLight/Dark` - Neutral secundario
- `context.palette.neutralMidLight/Dark` - Neutral medio

## Persistencia

El tema seleccionado se guarda automáticamente usando `SharedPreferences` y se restaura al reiniciar la aplicación.

## Migración de Colores Hardcodeados

### Antes:
```dart
Container(
  color: Colors.white,
  child: Text(
    'Hola',
    style: TextStyle(color: Colors.black),
  ),
)
```

### Después:
```dart
Container(
  color: context.colors.surface,
  child: Text(
    'Hola',
    style: TextStyle(color: context.colors.onSurface),
  ),
)
```

## Mejores Prácticas

1. **Siempre usa colores del tema**: Evita colores hardcodeados como `Colors.white` o `Colors.black`
2. **Usa colores semánticos**: Para estados específicos usa `context.palette.successLight` en lugar de colores genéricos
3. **Considera la accesibilidad**: Los colores del tema están diseñados para mantener buen contraste
4. **Testa ambos temas**: Siempre verifica que tu UI funcione bien en modo claro y oscuro

## Ejemplo Completo

```dart
import 'package:flutter/material.dart';
import 'package:icongrega/theme/theme_helpers.dart';
import 'package:icongrega/ui/widgets/theme_toggle_widgets.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          'Mi Pantalla',
          style: TextStyle(color: context.colors.onSurface),
        ),
        backgroundColor: context.colors.surface,
        actions: [
          const ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                Icons.settings,
                color: context.colors.primary,
              ),
              title: Text(
                'Configuración',
                style: TextStyle(color: context.colors.onSurface),
              ),
              trailing: const ThemeToggleSwitch(),
            ),
          ),
          const ThemeToggleChip(),
        ],
      ),
    );
  }
}
```
