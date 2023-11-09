import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

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
                // Botones
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton('Sports', 'Messi is love'),
                      MyButton('News', 'Covid-19'),
                      MyButton('Programming', 'Flutter'),
                      MyButton('Animals', 'Cats'),
                      MyButton('Sports', 'Messi is love'),
                    ],
                  ),
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
}

class MyButton extends StatelessWidget {
  final String topText;
  final String bottonText;

  MyButton(this.topText, this.bottonText);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add your onTap code here.
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        width: 600,
        height: 75,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFD4DFE6),
          border: Border.all(
            color: Color(0xFF013E6A),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              topText,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0xFF799AB1),
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: 10),
            Text(
              bottonText,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0xFF013E6A),
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
