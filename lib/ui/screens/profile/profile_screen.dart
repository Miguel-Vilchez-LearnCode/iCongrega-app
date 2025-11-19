import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/domain/models/post_item.dart' as model;
import 'package:icongrega/domain/models/user.dart' as model;
import 'package:icongrega/providers/auth_provider.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/auth/upload_image_screen.dart';
import 'package:icongrega/ui/screens/feed/detail_pager_screen.dart';
import 'package:icongrega/ui/screens/events/detail_event_screen.dart';
import 'package:icongrega/ui/screens/profile/edit_church_profile_screen.dart';
import 'package:icongrega/ui/screens/profile/edit_user_profile_screen.dart';
import 'package:icongrega/ui/screens/profile/messages_church_screen.dart';
import 'package:icongrega/ui/screens/profile/messages_user_screen.dart';
import 'package:icongrega/ui/screens/settings/settings_screen.dart';
import 'package:icongrega/ui/widgets/donation.dart';
import 'package:icongrega/ui/widgets/modals/logout_modal.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

void _openBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    useRootNavigator: true,
    context: context,
    builder: (BuildContext context) {
      return const DonacionBottomSheet();
    },
  );
}

class ProfileScreen extends StatefulWidget {
  final int selectedProfileIndex;

  const ProfileScreen({super.key, this.selectedProfileIndex = 0});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthProvider get auth => context.watch<AuthProvider>();
  model.User? get user => auth.currentUser;

  ImageProvider<Object> _profileImageProvider(model.User? user) {
    final photo = user?.profileImage;
    if (photo != null && photo.isNotEmpty) {
      if (photo.startsWith('http')) {
        return NetworkImage(photo);
      }
      return AssetImage(photo);
    }
    return const AssetImage('assets/images/profile.png');
  }

  bool _isLoadingPage = false;

  late final List<model.PostItem> _posts;
  late int _selectedProfileIndex = widget.selectedProfileIndex;
  int _selectedUserPostIndex = 0;
  int _selectedChurchPostIndex = 0;

  @override
  void initState() {
    super.initState();
    _posts = _createPosts();
  }

  void _onSelectUserPostTap(int index) {
    setState(() {
      _selectedUserPostIndex = index;
    });
  }

  void _onSelectChurchPostTap(int index) {
    setState(() {
      _selectedChurchPostIndex = index;
    });
  }

  void _onSelectProfileTap(int index) {
    setState(() {
      _selectedProfileIndex = index;
    });
  }

  void _modalAcountDelete(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Confirmación",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return const LogoutModal();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Skeletonizer(
            enabled: _isLoadingPage,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 170, 0),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/bg_pattern.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 36),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                showDragHandle: true,
                                isScrollControlled: true,
                                useRootNavigator: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return AnimatedPadding(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(
                                        context,
                                      ).viewInsets.bottom,
                                    ),
                                    child: SafeArea(
                                      top: false,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            if (_selectedProfileIndex == 1)
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                  ),
                                                  foregroundColor: Colors.black,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditChurchProfileScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Editar Información del Perfil',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.background,
                                                  ),
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32.0,
                                                    vertical: 0,
                                                  ),
                                              child: Divider(),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                ),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                  rootNavigator: true,
                                                ).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SettingsScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Configuraciones',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.background,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32.0,
                                                    vertical: 0,
                                                  ),
                                              child: Divider(),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                ),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                'Reportar',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.background,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32.0,
                                                    vertical: 0,
                                                  ),
                                              child: Divider(),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                ),
                                                foregroundColor:
                                                    Colors.redAccent[700],
                                              ),
                                              onPressed: () =>
                                                  _modalAcountDelete(context),
                                              child: Text(
                                                'Cerrar Sesión',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.redAccent[700],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32.0,
                                                    vertical: 0,
                                                  ),
                                              child: Divider(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: const Icon(
                              Icons.more_vert,
                              color: AppColors.botDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _onSelectProfileTap(0);
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  focusColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: _selectedProfileIndex == 0
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.shadow
                                              : Colors.transparent,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      color: _selectedProfileIndex == 0
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                      ),
                                    ),
                                    child: Text(
                                      'Personal',
                                      style: GoogleFonts.inter(
                                        color: _selectedProfileIndex == 0
                                            ? AppColors.botDark
                                            : Theme.of(
                                                context,
                                              ).colorScheme.background,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _onSelectProfileTap(1);
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  focusColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: _selectedProfileIndex == 1
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.shadow
                                              : Colors.transparent,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      color: _selectedProfileIndex == 1
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                      ),
                                    ),
                                    child: Text(
                                      'Iglesia',

                                      style: GoogleFonts.inter(
                                        color: _selectedProfileIndex == 1
                                            ? AppColors.botDark
                                            : Theme.of(
                                                context,
                                              ).colorScheme.background,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selectedProfileIndex == 0)
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 80),
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      width: 14,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        useRootNavigator: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AnimatedPadding(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            curve: Curves.easeOut,
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                            ),
                                            child: SafeArea(
                                              top: false,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                            ),
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        showGeneralDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          barrierLabel:
                                                              "Confirmación",
                                                          transitionDuration:
                                                              const Duration(
                                                                milliseconds:
                                                                    200,
                                                              ),
                                                          pageBuilder: (context, anim1, anim2) {
                                                            return AlertDialog(
                                                              contentPadding:
                                                                  EdgeInsets.all(
                                                                    0,
                                                                  ),
                                                              content: Container(
                                                                height: 300,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                  image: DecorationImage(
                                                                    image:
                                                                        _profileImageProvider(
                                                                          user,
                                                                        ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Ver Foto',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 32.0,
                                                            vertical: 0,
                                                          ),
                                                      child: Divider(),
                                                    ),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                            ),
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UploadImageScreen(),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        'Cambiar Foto',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 32.0,
                                                            vertical: 0,
                                                          ),
                                                      child: Divider(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: _profileImageProvider(user),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              user?.fullName ?? 'User Name',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cristiano',
                                style: GoogleFonts.inter(
                                  color: AppColors.neutralMidDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                width: 0.7,
                                height: 10,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                color: const Color.fromARGB(255, 209, 209, 209),
                              ),
                              Text(
                                'Evangélico',
                                style: GoogleFonts.inter(
                                  color: AppColors.neutralMidDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              user?.about ?? 'Sin descripción',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      '46',
                                      style: GoogleFonts.inter(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.background,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Congregaciones',
                                      style: GoogleFonts.inter(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                color: AppColors.neutralMidDark,
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      '2',
                                      style: GoogleFonts.inter(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.background,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Liderazgos',
                                      style: GoogleFonts.inter(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.shadow,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const MessagesUserScreen(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.comment_outlined,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.shadow,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditUserProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.shadow,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Share.share(
                                        'Compartiendo mi Perfil personal...!!',
                                      );
                                    },
                                    child: Icon(
                                      Icons.share_outlined,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45),
                                topRight: Radius.circular(45),
                              ),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 5,
                                  offset: const Offset(0, -3),
                                ),
                              ],
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.shadow,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        color: _selectedUserPostIndex == 0
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.surfaceContainer,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onSelectUserPostTap(0);
                                        },
                                        child: Text(
                                          'Mis "Me gusta"',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: _selectedUserPostIndex == 0
                                                ? AppColors.botDark
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.background,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.shadow,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        color: _selectedUserPostIndex == 0
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.surfaceContainer
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onSelectUserPostTap(1);
                                        },
                                        child: Text(
                                          'Eventos',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: _selectedUserPostIndex == 0
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.background
                                                : AppColors.botDark,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  height: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                if (_selectedUserPostIndex == 0)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      // spacing: 6,
                                      runSpacing: 8,
                                      children: [
                                        _postItem(
                                          context: context,
                                          itemIndex: 0,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/b5/a9/43/b5a9430392294777a51f458e988ec839.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 1,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/5a/23/5a/5a235ae814424cf6582430a85ce2e7af.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 2,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/24/54/df/2454df60e1d2578168e9f6a7c9d59903.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 3,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/cb/cc/f2/cbccf262d21924b5cefb554eb0461c3f.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 4,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/39/85/53/398553a737163c4b9cdf814d5d30d91e.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 5,
                                          postType: model.PostType.verse,
                                          verse:
                                              '"Todo lo puedo en Cristo que me fortalece". (Filipenses 4:13)',
                                          backgroundColor:
                                              AppColors.neutralMidDark,
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 6,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/01/3a/c8/013ac8cc64524d97e0e80d31b1575b28.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 7,
                                          postType: model.PostType.verse,
                                          verse:
                                              '"En el principio creo Dios los cielos y la tierra". (Genesis 1:1)',
                                          backgroundColor:
                                              AppColors.successLight,
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 8,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/0e/21/09/0e2109ae806cea9143855540568a1322.jpg",
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_selectedUserPostIndex == 1)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      // spacing: 6,
                                      runSpacing: 8,
                                      children: [
                                        _eventItem(
                                          context: context,
                                          day: '25',
                                          mon: 'Feb',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/0e/21/09/0e2109ae806cea9143855540568a1322.jpg',
                                          title: 'Encuentro de Oración',
                                          location: 'Parroquia Central',
                                          presential: true,
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '17',
                                          mon: 'May',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/01/3a/c8/013ac8cc64524d97e0e80d31b1575b28.jpg',
                                          title: 'Concierto de Alabanza',
                                          location: 'Auditorio Municipal',
                                          presential: true,
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '06',
                                          mon: 'Ene',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/39/85/53/398553a737163c4b9cdf814d5d30d91e.jpg',
                                          title: 'Retiro Espiritual',
                                          location: 'Casa de Retiros',
                                          presential: true,
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '18',
                                          mon: 'Sep',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/24/54/df/2454df60e1d2578168e9f6a7c9d59903.jpg',
                                          title: 'Misa de Acción de Gracias',
                                          location: 'Iglesia Central',
                                          presential: true,
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '24',
                                          mon: 'Abr',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/5a/23/5a/5a235ae814424cf6582430a85ce2e7af.jpg',
                                          title: 'Jornada Comunitaria',
                                          location: 'Plaza Mayor',
                                          presential: true,
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '03',
                                          mon: 'Dic',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/cb/cc/f2/cbccf262d21924b5cefb554eb0461c3f.jpg',
                                          title: 'Encuentro de Jóvenes',
                                          location: 'Parque Central',
                                          presential: true,
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '14',
                                          mon: 'Oct',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/b5/a9/43/b5a9430392294777a51f458e988ec839.jpg',
                                          title: 'Conferencia Pastoral',
                                          location: 'Centro Cultural',
                                          presential: true,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (_selectedProfileIndex == 1)
                      Column(
                        spacing: 0,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 80),
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          width: 14,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet<void>(
                                            showDragHandle: true,
                                            isScrollControlled: true,
                                            useRootNavigator: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AnimatedPadding(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                curve: Curves.easeOut,
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(
                                                    context,
                                                  ).viewInsets.bottom,
                                                ),
                                                child: SafeArea(
                                                  top: false,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        TextButton(
                                                          style: TextButton.styleFrom(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      24,
                                                                ),
                                                            foregroundColor:
                                                                Colors.black,
                                                          ),
                                                          onPressed: () {
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              barrierLabel:
                                                                  "Confirmación",
                                                              transitionDuration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        200,
                                                                  ),
                                                              pageBuilder:
                                                                  (
                                                                    context,
                                                                    anim1,
                                                                    anim2,
                                                                  ) {
                                                                    return AlertDialog(
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                            0,
                                                                          ),
                                                                      content: Container(
                                                                        height:
                                                                            300,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                          image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              "https://thumbs.dreamstime.com/b/una-biblia-abierta-con-el-cielo-y-fondo-de-las-puertas-peras-libro-biblias-celestial-perilla-333311086.jpg",
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                            );
                                                          },
                                                          child: Text(
                                                            'Ver Foto',
                                                            style: GoogleFonts.inter(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .background,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal:
                                                                    32.0,
                                                                vertical: 0,
                                                              ),
                                                          child: Divider(),
                                                        ),
                                                        TextButton(
                                                          style: TextButton.styleFrom(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      24,
                                                                ),
                                                            foregroundColor:
                                                                Colors.black,
                                                          ),
                                                          onPressed: () {},
                                                          child: Text(
                                                            'Cambiar Foto',
                                                            style: GoogleFonts.inter(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .background,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal:
                                                                    32.0,
                                                                vertical: 0,
                                                              ),
                                                          child: Divider(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                "https://thumbs.dreamstime.com/b/una-biblia-abierta-con-el-cielo-y-fondo-de-las-puertas-peras-libro-biblias-celestial-perilla-333311086.jpg",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 150,
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.shadow,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                                ),
                                              ),
                                              child: Text(
                                                '23.976',
                                                style: GoogleFonts.inter(
                                                  color: AppColors.botDark,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: -9,
                                      top: -9,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.shadow,
                                              blurRadius: 0.5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                            width: 5,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            _openBottomSheet(context);
                                          },
                                          child: Image.asset(
                                            "assets/icons/donacion.png",
                                            width: 22,
                                            height: 22,
                                            color: Colors.black,
                                            colorBlendMode: BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Obra Cristiana Puerta al Cielo',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            'Evangélica',
                            style: GoogleFonts.inter(
                              color: AppColors.neutralMidDark,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Comunidad de fe que promueve el encuentro con Dios a travez de la busqueda de la verdad bíblica y su aplicacion en nuestras vidas. Fundada en 2001.',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.shadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const MessagesChurchScreen(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.comment_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: AppColors.botDark,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  padding: EdgeInsets.symmetric(horizontal: 42),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Seguir',
                                  style: GoogleFonts.inter(
                                    color: AppColors.botDark,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.shadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Share.share(
                                      'Compartiendo mi perfil de Iglesia..!!',
                                    );
                                  },
                                  child: Icon(
                                    Icons.share_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Nuestro Equipo',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.background,
                                      ),
                                    ),
                                    Text(
                                      'Ver Todos (6)',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildOrganizerCard(
                                      user: 'guillermo',
                                      role: 'Organizador',
                                      imageUrl:
                                          'https://img.freepik.com/fotos-premium/selfie-facial-sonrisa-hombre-negocios-persona-que-toma-foto-memoria-feliz-carrera-redes-sociales-foto-perfil-retrato-empresario-profesional-o-asiatico-singapur-cargo_590464-183436.jpg',
                                    ),
                                    _buildOrganizerCard(
                                      user: 'Joaquin',
                                      role: 'Diacono',
                                      imageUrl:
                                          'https://scontent.fmrd1-1.fna.fbcdn.net/v/t39.30808-6/273216714_4987729637952904_2004981783024072287_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=vbK7uc97JykQ7kNvwGoQqUn&_nc_oc=AdkgWITVSQY-pm1fx0mT3gdz9mn2UhIRjJwuJk4K6tcN7lFVMp0rNrF5HdSaqu6ZsX4&_nc_zt=23&_nc_ht=scontent.fmrd1-1.fna&_nc_gid=j8wP6e24nhmTXah1Q2r1rQ&oh=00_Afe9BQbRa7RHjccA0YeMuGv2HtOff4wfae0lSHz6c8hY_w&oe=6901FC71',
                                    ),
                                    _buildOrganizerCard(
                                      user: 'Juana',
                                      role: 'Organizador',
                                      imageUrl:
                                          'https://www.seoptimer.com/storage/images/2014/08/selfie.jpg',
                                    ),
                                    _buildOrganizerCard(
                                      user: 'Juan',
                                      role: 'Organizador',
                                      imageUrl:
                                          'https://i.pinimg.com/736x/0e/21/09/0e2109ae806cea9143855540568a1322.jpg',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 170,
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.shadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(18),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/mapa.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 170,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color.fromARGB(188, 0, 0, 0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Av. Central, entre calle de Carretera 4 y 7, Santa Barbara, Zulia',
                                      style: GoogleFonts.inter(
                                        color: AppColors.botLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45),
                                topRight: Radius.circular(45),
                              ),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 5,
                                  offset: const Offset(0, -3),
                                ),
                              ],
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.shadow,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        color: _selectedChurchPostIndex == 0
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.surfaceContainer,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onSelectChurchPostTap(0);
                                        },
                                        child: Text(
                                          'Publicaciones',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: _selectedChurchPostIndex == 0
                                                ? AppColors.botDark
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.background,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.shadow,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        color: _selectedChurchPostIndex == 0
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.surfaceContainer
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onSelectChurchPostTap(1);
                                        },
                                        child: Text(
                                          'Eventos',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: _selectedChurchPostIndex == 0
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.background
                                                : AppColors.botDark,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  height: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                if (_selectedChurchPostIndex == 0)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      // spacing: 6,
                                      runSpacing: 8,
                                      children: [
                                        _postItem(
                                          context: context,
                                          itemIndex: 0,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/b5/a9/43/b5a9430392294777a51f458e988ec839.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 1,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/5a/23/5a/5a235ae814424cf6582430a85ce2e7af.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 2,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/24/54/df/2454df60e1d2578168e9f6a7c9d59903.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 3,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/cb/cc/f2/cbccf262d21924b5cefb554eb0461c3f.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 4,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/39/85/53/398553a737163c4b9cdf814d5d30d91e.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 5,
                                          postType: model.PostType.verse,
                                          verse:
                                              '"Todo lo puedo en Cristo que me fortalece". (Filipenses 4:13)',
                                          backgroundColor:
                                              AppColors.neutralMidDark,
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 6,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/01/3a/c8/013ac8cc64524d97e0e80d31b1575b28.jpg",
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 7,
                                          postType: model.PostType.verse,
                                          verse:
                                              '"En el principio creo Dios los cielos y la tierra". (Genesis 1:1)',
                                          backgroundColor:
                                              AppColors.successLight,
                                        ),
                                        _postItem(
                                          context: context,
                                          itemIndex: 8,
                                          postType: model.PostType.image,
                                          imageUrl:
                                              "https://i.pinimg.com/736x/0e/21/09/0e2109ae806cea9143855540568a1322.jpg",
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_selectedChurchPostIndex == 1)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      // spacing: 6,
                                      runSpacing: 8,
                                      children: [
                                        _eventItem(
                                          context: context,
                                          day: '25',
                                          mon: 'Feb',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/0e/21/09/0e2109ae806cea9143855540568a1322.jpg',
                                          title: 'Encuentro de Oración',
                                          location: 'Parroquia Central',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '17',
                                          mon: 'May',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/01/3a/c8/013ac8cc64524d97e0e80d31b1575b28.jpg',
                                          title: 'Concierto de Alabanza',
                                          location: 'Auditorio Municipal',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '06',
                                          mon: 'Ene',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/39/85/53/398553a737163c4b9cdf814d5d30d91e.jpg',
                                          title: 'Retiro Espiritual',
                                          location: 'Casa de Retiros',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '18',
                                          mon: 'Sep',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/24/54/df/2454df60e1d2578168e9f6a7c9d59903.jpg',
                                          title: 'Misa de Acción de Gracias',
                                          location: 'Iglesia Central',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '24',
                                          mon: 'Abr',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/5a/23/5a/5a235ae814424cf6582430a85ce2e7af.jpg',
                                          title: 'Jornada Comunitaria',
                                          location: 'Plaza Mayor',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '03',
                                          mon: 'Dic',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/cb/cc/f2/cbccf262d21924b5cefb554eb0461c3f.jpg',
                                          title: 'Encuentro de Jóvenes',
                                          location: 'Parque Central',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                        _eventItem(
                                          context: context,
                                          day: '14',
                                          mon: 'Oct',
                                          imageUrl:
                                              'https://i.pinimg.com/736x/b5/a9/43/b5a9430392294777a51f458e988ec839.jpg',
                                          title: 'Conferencia Pastoral',
                                          location: 'Centro Cultural',
                                          presential: true,
                                          user:
                                              'Obra Cristiana Puerta al Cielo',
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Lista de posts para el feed y el pager tipo Reels
  List<model.PostItem> _createPosts() {
    return [
      model.PostItem(
        type: model.PostType.image,
        user: "Iglesia Cristiana Renacer",
        role: "Pastor Miguel • Líder Juvenil",
        description:
            "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
        imageUser:
            "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
        fecha: "03/03/2025 - 10:30 AM",
        imageUrl:
            "https://i.pinimg.com/736x/b5/a9/43/b5a9430392294777a51f458e988ec839.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Movimiento Misionero Mundial",
        role: "Francisco Colmenarez • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
        imageChurch:
            "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
        fecha: "02/03/2025 - 05:16 PM",
        imageUrl:
            "https://i.pinimg.com/736x/5a/23/5a/5a235ae814424cf6582430a85ce2e7af.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Iglesia Cristiana Fuente de Salvacion",
        role: "Mauricio Alfonso • Líder de Caballeros",
        description:
            "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
        imageUser:
            "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
        fecha: "03/03/2025 - 10:30 AM",
        imageUrl:
            "https://i.pinimg.com/736x/24/54/df/2454df60e1d2578168e9f6a7c9d59903.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Movimiento Misionero Mundial",
        role: "Francisco Colmenarez • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
        imageChurch:
            "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
        fecha: "02/03/2025 - 05:16 PM",
        imageUrl:
            "https://i.pinimg.com/736x/cb/cc/f2/cbccf262d21924b5cefb554eb0461c3f.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Iglesia Cristiana Fuente de Salvacion",
        role: "Mauricio Alfonso • Líder de Caballeros",
        description:
            "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
        imageUser:
            "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
        fecha: "03/03/2025 - 10:30 AM",
        imageUrl:
            "https://i.pinimg.com/736x/39/85/53/398553a737163c4b9cdf814d5d30d91e.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.verse,
        user: "Centro Cristiano Renuevo",
        role: "Francisco Colmenares • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
        fecha: "02/03/2025 - 05:16 PM",
        verse: '"Todo lo puedo en Cristo que me fortalece". (Filipenses 4:13)',
        backgroundColor: AppColors.neutralMidDark,
        likesText: "245",
        commentsText: "67",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Movimiento Misionero Mundial",
        role: "Francisco Colmenarez • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
        imageChurch:
            "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
        fecha: "02/03/2025 - 05:16 PM",
        imageUrl:
            "https://i.pinimg.com/736x/01/3a/c8/013ac8cc64524d97e0e80d31b1575b28.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.verse,
        user: "Centro Cristiano Renuevo",
        role: "Francisco Colmenares • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
        fecha: "02/03/2025 - 05:16 PM",
        verse:
            '"En el Principio Creo Dios los Cielos y la Tierra". (Genesis 1:1)',
        backgroundColor: AppColors.successLight,
        likesText: "245",
        commentsText: "67",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Centro Cristiano Renuevo",
        role: "Francisco Colmenares • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
        fecha: "02/03/2025 - 05:16 PM",
        imageUrl:
            "https://i.pinimg.com/736x/0e/21/09/0e2109ae806cea9143855540568a1322.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: true,
      ),
    ];
  }

  // Widget para post parametrizable
  Widget _postItem({
    required BuildContext context,
    required int itemIndex,
    required model.PostType postType,
    Color? backgroundColor,
    String? imageUrl,
    String? videoUrl,
    String? verse,
  }) {
    // Contenido del post según el tipo
    Widget postContent;
    switch (postType) {
      case model.PostType.image:
        postContent = LayoutBuilder(
          builder: (context, constraints) {
            return InkWell(
              onTap: () {
                final posts = _posts;
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPagerScreen(
                      posts: posts,
                      initialIndex: itemIndex,
                    ),
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 145,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
        break;
      case model.PostType.video:
        postContent = LayoutBuilder(
          builder: (context, constraints) {
            return InkWell(
              onTap: () {
                final posts = _posts;
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPagerScreen(
                      posts: posts,
                      initialIndex: itemIndex,
                    ),
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 145,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(videoUrl!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
        break;
      case model.PostType.verse:
        postContent = InkWell(
          onTap: () {
            final posts = _posts;
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) =>
                    DetailPagerScreen(posts: posts, initialIndex: itemIndex),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            width: 100,
            height: 145,
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                verse!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.botDark,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
          ),
        );
        break;
    }

    return
    // Contenido del post
    postContent;
  }

  Widget _eventItem({
    required BuildContext context,
    required String day,
    required String mon,
    required String imageUrl,
    required String title,
    required String location,
    bool presential = true,
    bool online = false,
    bool live = false,
    String user = 'Iglesia Pentecostal Unida',
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => DetailEventScreen(
              title: title,
              day: day,
              mon: mon,
              user: user,
              location: location,
              image: imageUrl,
              presential: presential,
              online: online,
              live: live,
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 145,
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.8,
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black38,
              border: Border.all(color: AppColors.botLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.botLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  mon,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.botLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildOrganizerCard({
    required String user,
    required String role,
    required String imageUrl,
  }) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.neutralMidDark),
          ),
        ],
      ),
    );
  }
}
