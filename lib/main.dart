import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/add_resep.dart';
import 'pages/list_resep.dart';
import 'pages/view_resep.dart';   
import 'pages/edit_resep.dart';   

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://urwkexjmsmlghlavetrc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVyd2tleGptc21sZ2hsYXZldHJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNDAzNjIsImV4cCI6MjA2NDYxNjM2Mn0.BYbovEdv4HSWL7pRRAbAnqmYEPKrxszgT8rvsaB6x7w',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Masakan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
     initialRoute: '/',
onGenerateRoute: (settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ListResepPage());
    case '/add':
      return MaterialPageRoute(builder: (_) => const AddResepPage());
    case '/view':
  final args = settings.arguments as Map<String, dynamic>?;
  return MaterialPageRoute(
    builder: (_) => const ViewResepPage(),
    settings: RouteSettings(arguments: args),
  );

    case '/edit':
  final args = settings.arguments as Map<String, dynamic>;
  return MaterialPageRoute(
    builder: (_) => EditResepPage(
      id: args['id'],
      nama: args['nama_makanan'],
      detail: args['detail_makanan'],
      resep: args['resep_masakan'],
    ),
  );

  }
  return null;
},

    );
  }
}
