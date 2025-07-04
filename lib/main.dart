import 'package:flutter/material.dart';
import 'presentation/screens/tela_principal.dart';
import 'package:flame/flame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: TelaPrincipal()));
}

/*
Creature jonnas = Creature(1000, 500, Elemento.agua, Raridade.rara);
Creature kleber = Creature(2000, 350, Elemento.ar, Raridade.epica);

Creature jogador = Creature(0, 0, Elemento.nulo, Raridade.nulo);
Creature inimigo = Creature(0, 0, Elemento.nulo, Raridade.nulo);

int luta() {
  if ((jogador.elemento == Elemento.agua &&
          (inimigo.elemento == Elemento.fogo || inimigo.elemento == Elemento.terra)) ||
      (jogador.elemento == Elemento.terra &&
          (inimigo.elemento == Elemento.fogo || inimigo.elemento == Elemento.ar)) ||
      (jogador.elemento == Elemento.ar && inimigo.elemento == Elemento.fogo)) {
    inimigo.vida -= jogador.ataque * 3;
  } else {
    inimigo.vida -= jogador.ataque;
  }
  return 0;
}

int luta_pelo_inimigo() {
  if ((inimigo.elemento == Elemento.agua &&
          (jogador.elemento == Elemento.fogo || jogador.elemento == Elemento.terra)) ||
      (inimigo.elemento == Elemento.terra &&
          (jogador.elemento == Elemento.fogo || jogador.elemento == Elemento.ar)) ||
      (inimigo.elemento == Elemento.ar && jogador.elemento == Elemento.fogo)) {
    jogador.vida -= inimigo.ataque * 3;
  } else {
    jogador.vida -= inimigo.ataque;
  }
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
                      'https://imgs.search.brave.com/eCPAhLhNg0GffX6Tax37TlF_LRSdac_GQ5g6Da7EgwE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zbS5p/Z24uY29tL3QvaWdu/X2JyL3NjcmVlbnNo/b3QvZGVmYXVsdC9t/aW5pYXR1cmEtZG8t/eW91dHViZS1wZW50/ZWFkb3MtY2FiZWxv/cy1jYWNoZWFkb3Mt/bWFycm9tX2NyOG0u/NjQwLnBuZw',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text('Jogador: Fera Sombria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Vida: ${jogador.vida}'),
                          Text('Ataque: ${jogador.ataque}'),
                          Text('Elemento: ${jogador.elemento.name}'),
                          Text('Raridade: ${jogador.raridade.name}'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              luta();
                            });
                          },
                          child: Text("Ataque"),
                        ),
                        SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () { setState(() {
                            jogador.atk1(inimigo, inimigo.elemento as Creature);
                          });
                          },
                          child: Text("Ataque 1"),
                        ),
                        SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {setState(() {
                            jogador.atk2(inimigo);
                          });
                          },
                          child: Text("Ataque 2"),
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          jogador.ataque = jonnas.ataque;
                          jogador.vida = jonnas.vida;
                          jogador.elemento = jonnas.elemento;
                          jogador.raridade = jonnas.raridade;
                        });
                      },
                      child: Text("Escolher/restaurar"),
                    )
                  ],
                ),
              ),

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
                      child: Column(
                        children: [
                          Text('Inimigo: Dragão Verde', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Vida: ${inimigo.vida}'),
                          Text('Ataque: ${inimigo.ataque}'),
                          Text('Elemento: ${inimigo.elemento.name}'),
                          Text('Raridade: ${inimigo.raridade.name}'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              luta_pelo_inimigo();
                            });
                          },
                          child: Text("Ataque"),
                        ),
                        SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {setState(() {
                            inimigo.atk1(jogador, jogador.elemento as Creature);
                          });
                          },
                          child: Text("Ataque 1"),
                        ),
                        SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {setState(() {
                            inimigo.atk2(jogador);
                          });  
                          },
                          child: Text("Ataque 2"),
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          inimigo.ataque = kleber.ataque;
                          inimigo.vida = kleber.vida;
                          inimigo.elemento = kleber.elemento;
                          inimigo.raridade = kleber.raridade;
                        });
                      },
                      child: Text("Escolher/restaurar"),
                    )
                  ],
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}
*/
