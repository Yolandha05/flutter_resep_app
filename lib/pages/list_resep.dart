import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListResepPage extends StatefulWidget {
  const ListResepPage({super.key});

  @override
  State<ListResepPage> createState() => _ListResepPageState();
}

class _ListResepPageState extends State<ListResepPage> {
  List<dynamic> resepList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResep();
  }

  Future<void> fetchResep() async {
    final response = await Supabase.instance.client
        .from('tambah_resep')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      resepList = response;
      isLoading = false;
    });
  }

  Future<void> deleteResep(int id) async {
    await Supabase.instance.client
        .from('tambah_resep')
        .delete()
        .eq('id', id);
    fetchResep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Masakan'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : resepList.isEmpty
              ? const Center(child: Text('Belum ada resep')) 
              : ListView.builder(
                   itemCount: resepList.length,
                   itemBuilder: (context, index) {
                     final resep = resepList[index];
                     return Card(
                       margin: const EdgeInsets.all(8.0),
                       child: ListTile(
                         title: Text(resep['nama_makanan']),
                         subtitle: Text(resep['detail_makanan']),
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             IconButton(
                               icon: const Icon(Icons.visibility),
                               onPressed: () {
                                 Navigator.pushNamed(
                                   context,
                                   "/view",
                                   arguments: resep,
                                 );
                               },
                             ),
                             IconButton(
                               icon: const Icon(Icons.edit),
                               onPressed: () async {
                                   final result = await Navigator.pushNamed(
                                     context,
                                     "/edit",
                                     arguments: resep,
                                   );
                                   if (result == true) {
                                     fetchResep();
                                   }
                                },
                             ),
                             IconButton(
                               icon: const Icon(Icons.delete, color: Colors.red),
                               onPressed: () {
                                   showDialog(
                                     context: context,
                                     builder: (context) {
                                      return AlertDialog(
                                         title: const Text('Hapus Resep'),
                                         content: const Text('Yakin ingin menghapus resep ini?'),
                                         actions: [
                                           TextButton(
                                             onPressed: () {
                                               Navigator.of(context).pop();
                                             },
                                             child: const Text('Batal'),
                                           ),
                                           TextButton(
                                             onPressed: () async {
                                               await deleteResep(resep['id']); 
                                               Navigator.of(context).pop();
                                             },
                                             child: const Text('Hapus'),
                                           )
                                         ],
                                      );
                                   },
                                   );
                                },
                             )
                           ],
                         ),
                       ),
                     );
                   },
                 ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.brown),
        ),
        onPressed: () async {
  final result = await Navigator.pushNamed(context, "/add");

  if (result == true) { // Kalau memang saat back dia return true
    fetchResep();
  }
},

        child: const Icon(Icons.add, color: Colors.brown),
      ),
    );
  }
}
