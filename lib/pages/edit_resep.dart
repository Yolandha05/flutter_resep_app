import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class EditResepPage extends StatefulWidget {
  final int id; 
  final String nama;
  final String detail;
  final String resep;

  const EditResepPage({
    super.key,
    required this.id,
    required this.nama,
    required this.detail,
    required this.resep,
  });

  @override
  State<EditResepPage> createState() => _EditResepPageState();
}

class _EditResepPageState extends State<EditResepPage> {
  final _client = Supabase.instance.client;

  late TextEditingController namaController;
  late TextEditingController detailController;
  late TextEditingController resepController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    detailController = TextEditingController(text: widget.detail);
    resepController = TextEditingController(text: widget.resep);
  }

  Future<void> updateResep() async {
  try {
    await _client
        .from('tambah_resep')
        .update({
          'nama_makanan': namaController.text,
          'detail_makanan': detailController.text,
          'resep_masakan': resepController.text,
        })
        .eq('id', widget.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resep berhasil diperbarui!')),
      );
       Navigator.pop(context, true);
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal memperbarui resep: $error')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Resep')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Makanan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailController,
              decoration: const InputDecoration(
                labelText: 'Detail Makanan',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resepController,
              decoration: const InputDecoration(
                labelText: 'Resep Masakan',
                border: OutlineInputBorder(),
              ),
              minLines: 6,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: updateResep,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
