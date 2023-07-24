import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background/valores.png',
                    ),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background/antivalores.png',
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/inicio/bg-icon2.png',
                  height: 80,
                  width: 80,
                ),
                Image.asset(
                  'assets/inicio/icon-play.png',
                  height: 30,
                  width: 30,
                ),
              ],
          ),
            ),),
        ],
      ),
    );
  }
}
