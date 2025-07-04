import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 94, 67),
      body: Column(
        children: [
          const SizedBox(height: 120),
          Center(
            child: Image.network(
              'https://static.wikia.nocookie.net/clashroyale/images/e/ed/Legendary_Arena.png/revision/latest/scale-to-width-down/250?cb=20170505222335',
            ),
          ),

          Text(
            "4571 - 5000",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 55, 94, 131),
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 2.5),
              ),
            ),
            child: Text(
              "LUTAR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://gom-s3-user-avatar.s3.us-west-2.amazonaws.com/wp-content/uploads/2025/06/15120701/item_icon_510006.png",
              ),
              Text(
                "FALTAM 4H 23MIN\n PARA SEU BAÚ\n DIÁRIO",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
