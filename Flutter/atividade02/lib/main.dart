import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'LIGUE'),
        _buildButtonColumn(color, Icons.near_me, 'ROTA'),
        _buildButtonColumn(color, Icons.share, 'COMPARTILHE'),
      ],
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.webp',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection
          ],
        ),
      ),
    );
  }
}

Widget textSection = Container(
  padding: const EdgeInsets.all(32),
  child: const Text(
    '   O Buraco Azul em Jericoacoara realmente se tornou a nova atração turística no estado. Esse lago com águas de coloração extremamente azul-turquesa se formou por conta das fortes chuvas que ocorreram em 2019 no Ceará e agora, quase em 2023, já se consagrou como um ponto turístico definitivo do local.\n\n'
    '   Primeiramente, houve uma escavação e remoção de barro e areia no local que foram utilizados na construção da estrada CE-182, rodovia que liga a Lagoa do Monteiro à Praia do Preá, uma rota turística importante na região, inaugurada em setembro de 2018. Com as chuvas fortes de 2019, a água se acumulou nesse buraco, criando mais um cenário paradisíaco no Ceará.\n\n'
    '   Portanto, essa é uma atração realmente muito nova, existente desde agosto/setembro de 2019. Na verdade, é importante saber que a lagoa não fica propriamente dita em Jeri, mas sim em Caiçara, distrito do município de Cruz, a aproximadamente 20 km de Jeri. Mas, por Jeri ser a vila mais famosa da região, é bem normal você ler e escutar viajantes dizendo que vão para o Buraco Azul em Jericoacoara, ok?',
    softWrap: true,
  ),
);

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}

Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        /*1*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text(
                'Buraco azul',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Ceará, Brasil',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      /*3*/
      Icon(
        Icons.star,
        color: Colors.yellow[700],
      ),
      const Text('41'),
    ],
  ),
);
