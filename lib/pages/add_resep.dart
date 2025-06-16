import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddResepPage extends StatefulWidget {
  const AddResepPage({super.key});

  @override
  State<AddResepPage> createState() => _AddResepPageState();
}

class _AddResepPageState extends State<AddResepPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController resepController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    detailController.dispose();
    resepController.dispose();
    super.dispose();
  }

  Future<void> simpanData() async {
  final supabase = Supabase.instance.client;

  final nama = namaController.text.trim();
  final detail = detailController.text.trim();
  final resep = resepController.text.trim();

  if (nama.isNotEmpty && detail.isNotEmpty && resep.isNotEmpty) {
    try {
      await supabase.from('tambah_resep').insert({
        'nama_makanan': nama,
        'detail_makanan': detail,
        'resep_masakan': resep,
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal simpan: $e')),
      );
    }
  } else {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua kolom wajib diisi')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Resep",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "NAMA MAKANAN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFD9D9D9),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "DETAIL MAKANAN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: detailController,
              maxLines: 2,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFD9D9D9),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "RESEP MASAKAN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TextField(
                controller: resepController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("SIMPAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
