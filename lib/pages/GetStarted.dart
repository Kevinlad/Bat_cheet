import 'package:bat_cheet/pages/Sigup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class GetStartedSreen extends StatelessWidget {
  const GetStartedSreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Image.network(
            'https://png.pngtree.com/background/20210715/original/pngtree-handheld-mobile-phone-chat-design-concept-picture-image_1305458.jpg',
            height: 480,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Enjoy the new experience of ',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            'chatting with global friends',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Connect people arround the world for free',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.purple[400],
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text(
                'Get Started',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Powered by '),
              Icon(Icons.dashboard),
              Text(
                'ussage',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[800]),
              )
            ],
          )
        ],
      ),
    );
  }
}
