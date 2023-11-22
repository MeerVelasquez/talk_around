import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:talk_around/ui/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color(0xFF013E6A),
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: Image.asset('assets/Logo.png', width: 50, height: 50),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.search),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.more_vert),
        //     ),
        //   ],
        // ),
        drawer: DrawerWidget(),
        body: Stack(
          children: [
            // Fondo de imagen
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/Home.png'), // Reemplaza con la ruta de tu imagen de fondo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                // Contenedor con imagen y texto
                Container(
                  width: 400,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFE7FCFD),
                    border: Border.all(
                      color: Color(0xFF53F2D0),
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            '¡Talk!',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 34,
                              color: Color(0xFF013E6A),
                            ),
                          ),
                          Text(
                            'Please choose the',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'topics that you would like',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'to Talk Around:',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xFF013E6A),
                            ),
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/graph_1 1.png',
                        width: 160,
                        height: 120,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildClickableBox(
                        'Sports: Messi', 'is love', 'assets/sports.jpg'),
                    buildClickableBox(
                        'Games', 'of the season', 'assets/games.jpg'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildClickableBox(
                        'AOT: ', 'Grand Finale', 'assets/aot.png'),
                    buildClickableBox(
                        'Tips: ', 'Treats for dogs', 'assets/perfil.jpeg'),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.people, title: 'Profile'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'New chat'),
          ],
          initialActiveIndex: 2, //optional, default as 0
          onTap: (int i) => print('click index=$i'),
          backgroundColor: Color(0xFF013E6A),
        ));
  }

  Widget buildClickableBox(String title, String description, String imagePath) {
    return InkWell(
      onTap: () {
        // Acción al hacer clic en el cuadro
        print('Clic en $title');
      },
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          color: Color(0xFF799AB1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // Fondo de la caja
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Container con la imagen en el centro
            Positioned(
              left: 20,
              right: 20,
              top: 20,
              bottom: 70,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF234E6C)),
                ),
                child: Image.asset(
                  imagePath,
                  width: 20, // Ajusta el tamaño según tus necesidades
                  // height: 50,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Container con el texto en la parte inferior
            Positioned(
              left: 20,
              right: 20,
              bottom: 10,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE7FCFD),
                  border: Border.all(
                    color: Color(0xFF7FA6B9),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    '$title\n$description',
                    style: TextStyle(
                        color: Color(0xFF013E6A),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
