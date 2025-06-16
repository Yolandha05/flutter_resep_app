import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewResepPage extends StatefulWidget {
  const ViewResepPage({super.key});

  @override
  State<ViewResepPage> createState() => _ViewResepPageState();
}

class _ViewResepPageState extends State<ViewResepPage> {
  final supabase = Supabase.instance.client;
  Map? resep;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map && args['id'] != null) {
      fetchResep(args['id']);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> fetchResep(int id) async {
    final response = await supabase
        .from('tambah_resep')
        .select()
        .eq('id', id)
        .single();

    setState(() {
      resep = response;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (resep == null) {
      return const Scaffold(
        body: Center(child: Text("Data resep tidak ditemukan.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Lihat Resep")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resep!['nama_makanan'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Detail: ${resep!['detail_makanan']}"),
            const SizedBox(height: 12),
            Text("Resep:\n${resep!['resep_masakan']}"),
          ],
        ),
      ),
    );
  }
}
