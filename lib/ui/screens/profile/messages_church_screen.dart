import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'chat_church_screen.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';

class MessagesChurchScreen extends StatefulWidget {
  const MessagesChurchScreen({super.key});

  @override
  State<MessagesChurchScreen> createState() => _MessagesChurchScreenState();
}

class _MessagesChurchScreenState extends State<MessagesChurchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Conversaciones",
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _itemProfile(
              image:
                  'https://labsaenzrenauld.com/wp-content/uploads/2020/10/Perfil-hombre-ba%CC%81sico_738242395.jpg',
              iglesia: 'Obra Evangelica Luz del Mundo',
              user: 'Jaime Vanz Puerta',
              religion: 'Cristiano',
              trailingFecha: '20/10/2025',
              trailingStatus: "read",
              unreadMessages: 2,
            ),
            Divider(color: Theme.of(context).colorScheme.shadow),
            _itemProfile(
              image:
                  'https://img.freepik.com/fotos-premium/joven-hispano-pulgares-arriba-aplausos-algo-concepto-apoyo-respeto_1187-113166.jpg',
              iglesia: 'Centro Cristiano Renuevo',
              user: 'Juan Perez',
              religion: 'Evangelico',
              trailingFecha: 'Hace 2 horas',
              trailingStatus: "sended",
              unreadMessages: 6,
            ),
            Divider(color: Theme.of(context).colorScheme.shadow),
            _itemProfile(
              image:
                  'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyZmlsfGVufDB8fDB8fHww&fm=jpg&q=60&w=3000',
              iglesia: 'Iglesia de la Paz',
              user: 'Miguel Vilchez',
              religion: 'Cristiano',
              trailingFecha: 'hace 1 minuto',
              trailingStatus: "unread",
              unreadMessages: 0,
            ),
            Divider(color: Theme.of(context).colorScheme.shadow),
          ],
        ),
      ),
    );
  }

  Widget _itemProfile({
    required String image,
    required String iglesia,
    required String user,
    required String religion,
    required String trailingFecha,
    String trailingStatus = "sended",
    required int unreadMessages,

  }) 
  {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatChurchScreen(
              title: user,
              subtitle: iglesia,
              avatarUrl: image,
            ),
          ),
        );
      },
      style: ListTileStyle.drawer,
      horizontalTitleGap: 8,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: Image.network(image, fit: BoxFit.cover).image,
          ),
          if (unreadMessages > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 16,
                height: 16,
                // padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    unreadMessages.toString(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.botLight,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Column(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            transform: Matrix4.translationValues(0, 1.5, 0),
            child: Text(
              overflow: TextOverflow.ellipsis,
              user,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, 0, 0),
            child: Text(
              overflow: TextOverflow.ellipsis,
              iglesia,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -1.5, 0),
            child: Text(
              overflow: TextOverflow.ellipsis,
              religion,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: AppColors.neutralMidDark,
                fontSize: 10,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      trailing: Column(
        spacing: 1,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            trailingStatus == "sended" ? Icons.done : Icons.done_all,
            color: trailingStatus == "read"
                ? AppColors.successLight
                : AppColors.neutralMidDark,
            size: 16,
          ),
          Text(
            trailingFecha,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              color: AppColors.neutralMidDark,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
