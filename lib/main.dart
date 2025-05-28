import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
} // running the app

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // main widget of the app
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: TemperatureConverter(), // main screen of the app
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  // stateful widget helps in interactive UI
  const TemperatureConverter({super.key});
  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

enum ConversionType { fToC, cToF }

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _inputController = TextEditingController();
  String _convertedValue = '';
  ConversionType _selectedConversion = ConversionType.fToC;
  final List<String> _history = [];

  void _convertTemperature() {
    // this is the fx that converts the inputs
    final input = _inputController.text;
    if (input.isEmpty) return;

    final temp = double.tryParse(input);
    if (temp == null) return;

    double result;
    String historyEntry;

    if (_selectedConversion == ConversionType.fToC) {
      result = (temp - 32) * 5 / 9;
      historyEntry = 'F to C: $temp ➡️ ${result.toStringAsFixed(2)}';
    } else {
      result = (temp * 9 / 5) + 32;
      historyEntry = 'C to F: $temp ➡️ ${result.toStringAsFixed(2)}';
    }

    setState(() {
      _convertedValue = result.toStringAsFixed(2);
      _history.insert(0, historyEntry);
    });
  }

  void _clearAll() {
    setState(() {
      _inputController.clear();
      _convertedValue = '';
      _history.clear();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Converter'), backgroundColor: Colors.blue),
      body: SafeArea(
        child: OrientationBuilder(
          // this widget helps to build different layouts for portrait and landscape modes
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  orientation == Orientation.portrait
                      ? _buildPortraitLayout()
                      : _buildLandscapeLayout(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Conversion:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _buildConversionSelector(),
          SizedBox(height: 20),
          _buildInputOutputRow(),
          SizedBox(height: 30),
          _buildConvertButton(),
          SizedBox(height: 20),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Conversion:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _buildConversionSelector(),
              SizedBox(height: 10),
              _buildInputOutputRow(),
              SizedBox(height: 30),
              _buildConvertButton(),
            ],
          ),
        ),
        VerticalDivider(),
        Expanded(child: _buildHistoryList()),
      ],
    );
  }

  Widget _buildConversionSelector() {
    // this widget helps to select the conversion type using radio buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<ConversionType>(
          // radio button for Fahrenheit to Celsius conversion vice vesra
          value: ConversionType.fToC,
          groupValue: _selectedConversion,
          onChanged: (value) {
            setState(() {
              _selectedConversion = value!;
            });
          },
        ),
        Flexible(
          child: Text('Fahrenheit to Celsius', overflow: TextOverflow.ellipsis),
        ),

        SizedBox(width: 20),

        Radio<ConversionType>(
          value: ConversionType.cToF,
          groupValue: _selectedConversion,
          onChanged: (value) {
            setState(() {
              _selectedConversion = value!;
            });
          },
        ),
        Flexible(
          child: Text('Celsius to Fahrenheit', overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildInputOutputRow() {
    // this widget helps to create the input and output text fields
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            controller: _inputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter value',
            ),
          ),
        ),
        SizedBox(width: 10),
        Text('=', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Flexible(
          child: TextField(
            readOnly: true,
            controller: TextEditingController(text: _convertedValue),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Result',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    // this widget helps to create the convert and clear buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _convertTemperature,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text('CONVERT'),
        ),
        SizedBox(width: 20), // spacing between buttons
        OutlinedButton(
          onPressed: _clearAll,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text('CLEAR'),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    // this widget helps to create the history list of conversions
    return _history.isEmpty
        ? Center(child: Text('No conversions yet.'))
        : ListView.builder(
          shrinkWrap: true, // important when not inside Expanded
          itemCount: _history.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.arrow_right_alt),
              title: Text(_history[index]),
            );
          },
        );
  }
}
