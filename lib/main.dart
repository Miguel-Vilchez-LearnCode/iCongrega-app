// import 'package:icongrega/ui/examples/color_migration_examples.dart';
import 'package:icongrega/data/data_source/remote/auth_api.dart';
import 'package:icongrega/data/helpers/http.dart';
import 'package:icongrega/data/repositories_impl/auth_repository_impl.dart';
import 'package:icongrega/domain/repositories/auth_repository.dart';
import 'package:icongrega/providers/auth_provider.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:icongrega/theme/app_theme.dart';
import 'package:icongrega/theme/theme_helpers.dart';
import 'package:icongrega/providers/theme_provider.dart';
import 'package:icongrega/ui/screens/root/home_tabs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// main asincrono
Future<void> main() async {
  // Asegurar que los Widgets estén inicializados para poder usar servicios
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env para las variables de entorno
  await dotenv.load(fileName: ".env");

  // ejecutar app con provider para el tema
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeProvider().themeMode,
          home: const SplashScreen(),
        ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Tiempo del splash (en ms)
  final int splashDuration = 1000;

  @override
  void initState() {
    super.initState();

    final http = Http();

    // Animación scale in / scale out
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Inicia animación scale in
    _scaleController.forward();

    final AuthRepository auth = AuthRepositoryImpl(AuthAPI(http));
    // verificar si el usuario ya está autenticado
    // y redirigirlo directamente a la pantalla principal si es así.
    auth.accessToken.then((token) {
      Future.delayed(Duration(milliseconds: splashDuration), () async {
        await _scaleController.reverse(); // scale out
        if (mounted) {
          if (token != null && token != 'null') {
            // Usuario autenticado
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeTabs()),
            );
          } else {
            // Usuario no autenticado, redirigir a pantalla de login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        }
      });
    });


    // Después del tiempo definido, hace scale out y redirige
    // Future.delayed(Duration(milliseconds: splashDuration), () async {
    //   await _scaleController.reverse(); // scale out
    //   if (mounted) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const LoginScreen()),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 24,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo centrado con animación scale
          Container(
            margin: EdgeInsets.only(top: 260),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                "assets/icons/logo_sin_fondo.png",
                width: 80,
                height: 80,
              ),
            ),
          ),

          // Loader blanco en la parte inferior centrado
          Container(
            margin: EdgeInsets.only(bottom: 50),
            alignment: Alignment.center,
            child: SpinKitDoubleBounce(color: AppColors.botLight, size: 40.0),
          ),
        ],
      ),
    );
  }
}
