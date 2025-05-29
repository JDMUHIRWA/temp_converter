import 'package:flutter_test/flutter_test.dart';
import 'package:temp_converter/main.dart'; // Make sure the import path is correct

void main() {
  testWidgets('App loads and shows Converter title', (WidgetTester tester) async {
    // Use your actual app widget name
    await tester.pumpWidget(const TemperatureConverterApp());

    // Check if the AppBar title is rendered
    expect(find.text('Converter'), findsOneWidget);
  });
}
