import 'package:flutter/material.dart';
/* 1-fogo; 2-agua; 3-terra */

enum Elemento {
  fogo,
  agua,
  terra,
  ar,
  nulo
}

class personagem {
  int vida;
  int ataque;
  Elemento elemento;

  personagem(this.vida, this.ataque, this.elemento);
}

personagem jonnas = personagem(1000, 500, Elemento.agua);
personagem kleber = personagem(2000, 350, Elemento.ar);

personagem jogador = personagem(0, 0, Elemento.nulo);
personagem inimigo = personagem(0, 0, Elemento.nulo);



int luta(){
    if (jogador.elemento == Elemento.agua && inimigo.elemento == Elemento.fogo || inimigo.elemento == Elemento.terra ){
      inimigo.vida -= jogador.ataque * 3;
    }
    if (jogador.elemento == Elemento.terra && inimigo.elemento == Elemento.fogo || inimigo.elemento == Elemento.ar){
      inimigo.vida -= jogador.ataque * 2;
    }
    if (jogador.elemento == Elemento.ar && inimigo.elemento == Elemento.fogo){
      inimigo.vida -= jogador.ataque * 4;
    }
    else {inimigo.vida -= jogador.ataque;};
    return 0;
}

int luta_pelo_inimigo(){
    if (inimigo.elemento == Elemento.agua && jogador.elemento == Elemento.fogo || jogador.elemento == Elemento.terra ){
      jogador.vida -= inimigo.ataque * 3;
    }
    if (inimigo.elemento == Elemento.terra && jogador.elemento == Elemento.fogo || jogador.elemento == Elemento.ar){
      jogador.vida -= inimigo.ataque * 2;
    }
    if (inimigo.elemento == Elemento.ar && jogador.elemento == Elemento.fogo){
      jogador.vida -= inimigo.ataque * 4;
    }
    else {jogador.vida -= inimigo.ataque;};
    return 0;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {setState(() {luta_pelo_inimigo();});}, icon: Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 0))),
          title: IconButton(onPressed: () {setState(() {luta();});  }, icon: Icon(Icons.circle, color: Color.fromARGB(255, 0, 255, 0))),
          actions: [IconButton(onPressed: () {setState(() {inimigo.vida += 100; jogador.vida += 100;}); }, icon: Icon(Icons.circle, color: Color.fromARGB(255, 255, 255, 0)))],
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://media.istockphoto.com/id/1370669162/pt/foto/scary-monster-on-white-background-closeup-of-hand-halloween-character.jpg?s=612x612&w=is&k=20&c=W8mdKZOSGm6UZU5cFD172q0QozyCsKrYLdvY3DfouIk=',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(children: [
                        Text('Nome: Dragão Verde', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(inimigo.vida.toString()),
                        Text(inimigo.ataque.toString()),
                      ]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(onPressed: (){setState(() {
                inimigo.ataque = kleber.ataque;
                inimigo.vida = kleber.vida;
                inimigo.elemento = kleber.elemento;
              });}, child: Icon(Icons.abc_outlined)),
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://imgs.search.brave.com/eCPAhLhNg0GffX6Tax37TlF_LRSdac_GQ5g6Da7EgwE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zbS5p/Z24uY29tL3QvaWdu/X2JyL3NjcmVlbnNo/b3QvZGVmYXVsdC9t/aW5pYXR1cmEtZG8t/eW91dHViZS1wZW50/ZWFkb3MtY2FiZWxv/cy1jYWNoZWFkb3Mt/bWFycm9tX2NyOG0u/NjQwLnBuZw',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(children: [
                        Text('Nome: Fera Sombria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(jogador.vida.toString()),
                        Text(jogador.ataque.toString()),
                      ]),
                    ),
                  ],
                ),
              ),ElevatedButton(onPressed: () {setState(() {
                jogador.ataque = jonnas.ataque;
                jogador.vida = jonnas.vida;
                jogador.elemento = jonnas.elemento;});},
  child: Icon(Icons.abc_outlined),
),

            ],
          ),
        ),
      ),
    );
  }
}
