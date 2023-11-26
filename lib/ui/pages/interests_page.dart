import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:talk_around/ui/routes.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({Key? key}) : super(key: key);

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/img/interesesbg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 300),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Please choose the topics that you would like to',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Talk About:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff013E6A),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // ChoiceChips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildChoiceChip('Sports'),
                      SizedBox(width: 10),
                      buildChoiceChip('VideoGames'),
                      SizedBox(width: 10),
                      buildChoiceChip('News'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildChoiceChip('Programming'),
                      SizedBox(width: 10),
                      buildChoiceChip('Animals'),
                    ],
                  ),
                  SizedBox(
                      height:
                          40), // Añadir espacio entre los ChoiceChips y el botón
                  Container(
                    width: double.infinity,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción al presionar el botón
                      },
                      child: Text(
                        'Let\'s Start',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffE7FCFD)),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff013E6A), // Color de fondo del botón
                        onPrimary: Colors.white, // Color del texto del botón
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selectedInterests.contains(label)
              ? Color(0xffE7FCFD)
              : Color(0xff013E6A),
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
        ),
      ),
      selected: selectedInterests.contains(label),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedInterests.add(label);
          } else {
            selectedInterests.remove(label);
          }
        });
      },
      backgroundColor: Color(0xffD6E0E7),
      selectedColor: Color(0xff104973),
      elevation: 5,
      pressElevation: 6,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Color(0xff013E6A),
          width: 2,
        ),
      ),
    );
  }
}
