class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }
}

class Funcionario {
  String _nome;
  List<Dependente> _dependentes;

  Funcionario(this._nome, this._dependentes);
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
}

void main() {
  Dependente mae1 = Dependente('MAE_1');
  Dependente filho1 = Dependente('FILHO_1');
  Dependente esposa2 = Dependente('ESPOSA_2');
  Dependente marido3 = Dependente('MARIDO_3');
  Dependente filho3 = Dependente('FILHO_3');
  Dependente neto4 = Dependente('NETO_4');

  List<Dependente> DenpendentesFunc1 = [mae1, filho1];
  List<Dependente> DenpendentesFunc2 = [esposa2];
  List<Dependente> DenpendentesFunc3 = [marido3, filho3];
  List<Dependente> DenpendentesFunc4 = [neto4];

  Funcionario funcionario1 = Funcionario('jefferson', DenpendentesFunc1);
  Funcionario funcionario2 = Funcionario('abraao', DenpendentesFunc2);
  Funcionario funcionario3 = Funcionario('joana', DenpendentesFunc3);
  Funcionario funcionario4 = Funcionario('carlos', DenpendentesFunc4);

  List<Funcionario> participantes = [
    funcionario1,
    funcionario2,
    funcionario3,
    funcionario4
  ];

  EquipeProjeto projeto = EquipeProjeto(
      'Curso de Desenvolvimento de Aplicativos - IFCE', participantes);

  print(projeto._nomeProjeto);
  projeto._funcionarios.forEach((element) {
    print('\n Participante: ${element._nome} \n  Depedentes');
    element._dependentes.forEach((element2) {
      print('  - ${element2._nome}');
    });
  });
}
