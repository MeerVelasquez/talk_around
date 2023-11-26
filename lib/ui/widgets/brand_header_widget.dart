import 'package:flutter/material.dart';

class BrandHeaderWidget extends StatelessWidget {
  const BrandHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.red,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Talk!',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 34,
                      color: Color(0xFF013E6A),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        'Please choose the topics that you would like to',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: ' Talk Around',
                                    style: TextStyle(
                                        color: Color(0x013E6A).withOpacity(1))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.green,
              child: Image.asset(
                'assets/img/graph_1 1.png',
                // width: 160,
                // height: 120,
              ),
            )
          ],
        ));
  }
}
