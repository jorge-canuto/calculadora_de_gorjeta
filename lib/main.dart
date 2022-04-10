import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum Moeda { REAL, DOLAR }

List<DropdownMenuItem<Moeda>> _moedaList = [
  const DropdownMenuItem(
    value: Moeda.REAL,
    child: Text("Real-R\$"),
  ),
  const DropdownMenuItem(
    value: Moeda.DOLAR,
    child: Text("Dólar-US\$"),
  ),
];

class _HomePageState extends State<HomePage> {
  Moeda? _moedaDropdownValue;
  double _porcentagemGorjeta = 1.0;
  bool _value = true, flagAlert = false;
  late TextEditingController _cotacaoController,
      _valorCompraController,
      _gorjetaPadraoController,
      _gorjetaSelecionadaController;

  @override
  void initState() {
    super.initState();
    _cotacaoController = TextEditingController();
    _valorCompraController = TextEditingController();
    _gorjetaPadraoController = TextEditingController();
    _gorjetaSelecionadaController = TextEditingController();
  }

  @override
  void dispose() {
    _cotacaoController.dispose();
    _valorCompraController.dispose();
    _gorjetaPadraoController.dispose();
    _gorjetaSelecionadaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: 805,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calculadora de Gorjetas"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 634,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Moeda",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _buildDropdownButtonRow(),
                (_moedaDropdownValue == Moeda.REAL)
                    ? _buildTextFieldCotacao(!_value)
                    : _buildTextFieldCotacao(_value),
                const Text(
                  "Percentual da gorjeta",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _buildSlider(),
                _buildTextFieldValorCompra(),
                _buildBox("100", "0.00"),
                _buildRowButtons()
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildDropdownButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        DropdownButton<Moeda>(
          items: _moedaList,
          onChanged: _updateMoedaDropdown,
          value: _moedaDropdownValue,
          hint: const Text("Selecionar moeda"),
        )
      ],
    );
  }

  Widget _buildTextFieldCotacao(bool? value) {
    if(_moedaDropdownValue == Moeda.REAL){
      _cotacaoController.text = "";
    }
    return TextField(
      enabled: value,
      controller: _cotacaoController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: "Cotação da moeda:",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
  }

  Widget _buildTextFieldValorCompra() {
    return TextField(
      controller: _valorCompraController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: "Valor da compra:",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
  }

  Widget _buildSlider() {
    return Slider(
      min: 1.0,
      max: 20.0,
      divisions: 19,
      value: _porcentagemGorjeta,
      onChanged: _updateSlider,
      label: _porcentagemGorjeta.toInt().toString(),
    );
  }

  Widget _buildBox(String labelGorjetaPadrao, String labelGorjetaSelecionada) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 160,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          TextField(
            enabled: false,
            controller: _gorjetaPadraoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Valor com Gojeta Padrão (10%):",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            enabled: false,
            controller: _gorjetaSelecionadaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Valor com gorjeta Selecionada:",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () => calcular(_valorCompraController.text, _porcentagemGorjeta),
            child: const Text("Calcular")),
        ElevatedButton(onPressed: () => limpar(), child: const Text("Limpar"))
      ],
    );
  }

  _showAlertDialog(BuildContext context, String msg){

    Widget okButton = TextButton(onPressed: () {Navigator.pop(context, false);}, child: Text("ok"),);

    AlertDialog alerta = AlertDialog(
      title: Text("Atenção!"),
      content: Text(msg),
      actions: [okButton,],
    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alerta;
      }
    );
  }

  void _updateMoedaDropdown(Moeda? newValue) {
    setState(() {
      _moedaDropdownValue = newValue;
    });
  }

  void _updateSlider(double newValue) {
    setState(() {
      _porcentagemGorjeta = newValue;
    });
  }

  void calcular(String valorCompra, double gorjeta) {

    if(valorCompra == ""){
      _showAlertDialog(context, "Favor informar o valor da compra");
    }

    else{
      double valorCompra2 = double.parse(valorCompra);
    if (_moedaDropdownValue == Moeda.DOLAR && _cotacaoController.text != "") {
        double novoValorCompra = valorCompra2 * double.parse(_cotacaoController.text);
        double gorjetaDolar = novoValorCompra * (gorjeta / 100);
        _gorjetaSelecionadaController.text =
            "R\$ " + (novoValorCompra + gorjetaDolar).toString();
        _gorjetaPadraoController.text =
            "R\$ " + (novoValorCompra + novoValorCompra * 0.10).toString();
      } else if(_moedaDropdownValue == Moeda.DOLAR && _cotacaoController.text == "") {
        _showAlertDialog(context, "Informe a cotação do Dólar");
      } else{
        _cotacaoController.text = "";
        _gorjetaSelecionadaController.text = "R\$ " + (valorCompra2 + valorCompra2 * (gorjeta / 100)).toString();
        _gorjetaPadraoController.text = "R\$ " + (valorCompra2 + valorCompra2 * 0.10).toString();
      }
    }
  }

  void limpar() {
    setState(() {
      _gorjetaSelecionadaController.text = "";
      _gorjetaPadraoController.text = "";
      _cotacaoController.text = "";
      _valorCompraController.text = "";
    });
  }
}
