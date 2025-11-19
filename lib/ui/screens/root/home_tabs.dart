import 'package:flutter/material.dart';
import 'package:icongrega/ui/screens/feed/feed_screen.dart';
import 'package:icongrega/ui/screens/explorer/explore_screen.dart';
import 'package:icongrega/ui/screens/events/events_screen.dart';
import 'package:icongrega/ui/screens/profile/profile_screen.dart';

const Color primary = Color(0xFFF5B800);

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  late int _currentIndex;
  DateTime? _lastBackPressed;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Feed
    GlobalKey<NavigatorState>(), // Explore
    GlobalKey<NavigatorState>(), // Events
    GlobalKey<NavigatorState>(), // Profile
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Future<bool> _onWillPop() async {
    final NavigatorState? currentNavigator =
        _navigatorKeys[_currentIndex].currentState;
    if (currentNavigator != null && currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }

    // If not on Feed tab, go there first
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }

    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      _showExitMessage();
      return false;
    }

    return true; // exit app
  }

  void _showExitMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Presiona atrás otra vez para salir'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> navigatorKey,
    required Widget child,
  }) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(
              navigatorKey: _navigatorKeys[0],
              child: const FeedScreen(),
            ),
            _buildTabNavigator(
              navigatorKey: _navigatorKeys[1],
              child: const ExploreScreen(),
            ),
            _buildTabNavigator(
              navigatorKey: _navigatorKeys[2],
              child: const EventsScreen(),
            ),
            _buildTabNavigator(
              navigatorKey: _navigatorKeys[3],
              child: const ProfileScreen(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == _currentIndex) {
                // If re-tapping the same tab, pop to first route of that tab
                final nav = _navigatorKeys[index].currentState!;
                while (nav.canPop()) {
                  nav.pop();
                }
              } else {
                setState(() => _currentIndex = index);
              }
            },
            backgroundColor: primary,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black45,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Explorar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Eventos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
