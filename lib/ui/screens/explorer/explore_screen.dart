import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';



class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isLoadingPage = false;
  bool isNotEmptyField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Skeletonizer(
              enabled: _isLoadingPage,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12),
                    // Search
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search_outlined,
                              color: AppColors.neutralMidDark,
                            ),
                            onPressed: () {},
                          ),
                          hintText: "Buscar iglesia, lider o religión",
                          hintStyle: TextStyle(
                            color: AppColors.neutralMidDark,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                
                    const SizedBox(height: 12),
                    Text(
                      'Iglesias cercanas',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      textAlign: TextAlign.left,
                    ),
                
                    const SizedBox(height: 12),
                
                    // Mapa
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mapa.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black38,
                            BlendMode.srcOver,
                          ),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 55),
                      child: Text(
                        'Abrir mapa',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                
                    const SizedBox(height: 16),
                
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                
                    _itemProfile(
                      image:
                          'https://cdn.pixabay.com/photo/2022/01/16/13/02/budapest-6941969_1280.jpg',
                      iglesia: 'Iglesia de la Paz',
                      lider: 'Juan Perez',
                      seguidores: '1.323',
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                
                    _itemProfile(
                      image:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s',
                      iglesia: 'Centro Cristiano Renuevo',
                      lider: 'Jesus Maria Semprum',
                      seguidores: '145',
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                
                    _itemProfile(
                      image:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdjDP-mUKtG5VC4bBrVvnfEGdcdoN1nxkwoA&s',
                      iglesia: 'Obra Evangelica Luz del Mundo',
                      lider: 'Jaime Puerta',
                      seguidores: '24.987',
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                  ],
                ),
            ),
            
          ),
        ),
      ),
      floatingActionButton: SizedBox(width: 200,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isLoadingPage = !_isLoadingPage;
            });
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text('Simular Skeleton'),
        ),
      ),
      // BottomNavigationBar se maneja desde HomeTabs
    );
  }

  Widget _itemProfile({
    required String image,
    required String iglesia,
    required String lider,
    required String seguidores,
  }) {
    return ListTile(
      style: ListTileStyle.drawer,
      horizontalTitleGap: 8,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      leading: CircleAvatar(
        backgroundImage: Image.network(image, fit: BoxFit.cover).image,
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
              iglesia,
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
              lider,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                transform: Matrix4.translationValues(0, -1.5, 0),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  seguidores,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
    
              Container(
                transform: Matrix4.translationValues(0, -1.5, 0),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  ' seguidores',
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
        ],
      ),
      trailing: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 4)),
        ),
        onPressed: () {},
        child: Text(
          'Seguir',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
