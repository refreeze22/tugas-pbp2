import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_testing/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Todo App Integration Test', () {
    testWidgets('Skenario: User menambahkan todo items dan menggunakan fitur checkbox',
        (WidgetTester tester) async {
      // 1. Jalankan app
      app.main();
      await tester.pumpAndSettle();

      // 2. Verify app terbuka dengan benar
      expect(find.text('My Todo List'), findsOneWidget);
      expect(find.text('Belum ada todo. Yuk tambahkan!'), findsOneWidget);

      // 3. User mengetik todo pertama
      final inputField = find.byKey(const Key('todoInputField'));
      expect(inputField, findsOneWidget);

      await tester.enterText(inputField, 'Belajar Flutter');
      await tester.pumpAndSettle();

      // 4. User menekan tombol Add
      final addButton = find.byKey(const Key('addButton'));
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // 5. Verify todo pertama muncul di list
      expect(find.text('Belajar Flutter'), findsOneWidget);
      expect(find.text('Belum ada todo. Yuk tambahkan!'), findsNothing);

      // 6. User menambahkan todo kedua
      await tester.enterText(inputField, 'Ngerjain Tugas');
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // 7. Verify ada 2 todo items di list
      expect(find.text('Belajar Flutter'), findsOneWidget);
      expect(find.text('Ngerjain Tugas'), findsOneWidget);

      // 8. Test checkbox functionality - centang todo pertama
      final checkbox0 = find.byKey(const Key('checkbox_0'));
      expect(checkbox0, findsOneWidget);

      await tester.tap(checkbox0);
      await tester.pumpAndSettle();

      // 9. Verify todo pertama sudah dicoret (completed)
      final completedTodo = find.text('Belajar Flutter');
      expect(completedTodo, findsOneWidget);

      // 10. Uncheck todo pertama
      await tester.tap(checkbox0);
      await tester.pumpAndSettle();

      // 11. Test delete functionality
      final deleteButton = find.byKey(const Key('deleteButton_0'));
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // 12. Verify item pertama terhapus
      expect(find.text('Belajar Flutter'), findsNothing);
      expect(find.text('Ngerjain Tugas'), findsOneWidget);

      print('✅ Integration test dengan checkbox berhasil!');
    });

    testWidgets('Skenario: Input kosong tidak menambahkan item',
        (WidgetTester tester) async {
      // Jalankan app
      app.main();
      await tester.pumpAndSettle();

      // Tap Add button tanpa input
      final addButton = find.byKey(const Key('addButton'));
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify tidak ada item yang ditambahkan
      expect(find.text('Belum ada todo. Yuk tambahkan!'), findsOneWidget);

      print('✅ Test validasi input kosong berhasil!');
    });

    testWidgets('Skenario: User menyelesaikan beberapa todo dengan checkbox',
        (WidgetTester tester) async {
      // Jalankan app
      app.main();
      await tester.pumpAndSettle();

      // Tambah 3 todo items
      final inputField = find.byKey(const Key('todoInputField'));
      final addButton = find.byKey(const Key('addButton'));

      await tester.enterText(inputField, 'Todo 1');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      await tester.enterText(inputField, 'Todo 2');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      await tester.enterText(inputField, 'Todo 3');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check todo pertama dan ketiga
      await tester.tap(find.byKey(const Key('checkbox_0')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('checkbox_2')));
      await tester.pumpAndSettle();

      // Verify semua todo masih ada (tidak dihapus saat dicheck)
      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
      expect(find.text('Todo 3'), findsOneWidget);

      print('✅ Test checkbox multiple items berhasil!');
    });
  });
}