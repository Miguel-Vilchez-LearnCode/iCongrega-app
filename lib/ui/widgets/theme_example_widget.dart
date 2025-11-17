import 'package:flutter/material.dart';
import 'package:icongrega/theme/theme_helpers.dart';

/// Widget de ejemplo que muestra cómo usar los colores del tema
/// en diferentes componentes de la aplicación
class ThemeExampleWidget extends StatelessWidget {
  const ThemeExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          'Ejemplo de Tema',
          style: TextStyle(color: context.colors.onSurface),
        ),
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Textos con diferentes estilos
            Text(
              'Textos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Texto principal',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            Text(
              'Texto secundario',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              'Texto de error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.error,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botones
            Text(
              'Botones',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Primario'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Secundario'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Texto'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Cards
            Text(
              'Tarjetas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarjeta estándar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esta es una tarjeta usando los colores del tema.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tarjeta con colores personalizados usando AppPalette
            Container(
              decoration: BoxDecoration(
                color: context.palette.infoLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.palette.infoLight.withOpacity(0.3),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: context.palette.infoLight,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Información',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.palette.infoLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta tarjeta usa colores semánticos del AppPalette.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Colores semánticos
            Text(
              'Colores Semánticos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildColorChip(context, 'Éxito', context.palette.successLight),
                _buildColorChip(context, 'Error', context.palette.dangerLight),
                _buildColorChip(context, 'Advertencia', context.palette.warningLight),
                _buildColorChip(context, 'Información', context.palette.infoLight),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Lista de elementos
            Text(
              'Lista de Elementos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: context.colors.primary,
                  ),
                  title: Text(
                    'Perfil',
                    style: TextStyle(color: context.colors.onSurface),
                  ),
                  subtitle: Text(
                    'Configuración de perfil',
                    style: TextStyle(
                      color: context.colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.onSurface.withOpacity(0.5),
                    size: 16,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: context.colors.primary,
                  ),
                  title: Text(
                    'Notificaciones',
                    style: TextStyle(color: context.colors.onSurface),
                  ),
                  subtitle: Text(
                    'Configuración de notificaciones',
                    style: TextStyle(
                      color: context.colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.onSurface.withOpacity(0.5),
                    size: 16,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.security,
                    color: context.colors.primary,
                  ),
                  title: Text(
                    'Privacidad',
                    style: TextStyle(color: context.colors.onSurface),
                  ),
                  subtitle: Text(
                    'Configuración de privacidad',
                    style: TextStyle(
                      color: context.colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.onSurface.withOpacity(0.5),
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildColorChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
