import 'package:flutter/material.dart';
import 'package:uts_crud_smarthphone/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Penjualan Hp',
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      home: const MyHomePage(title: 'Data Penjualan Hp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController tipeController = TextEditingController();
  TextEditingController warnaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stokController = TextEditingController();

  @override
  void initState() {
    refreshCatatan();
    super.initState();
  }

  //ambil data dari database
  List<Map<String, dynamic>> Catatan = [];
  void refreshCatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      Catatan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Catatan);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: Catatan.length,
          itemBuilder: (context, index) => Card(
                color: Colors.green,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(Catatan[index]['nama'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // height: 5,
                          fontSize: 20,
                          color: Color(0xFFFFFFFF))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Catatan[index]['tipe'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFFFFFFF))),
                      Text(Catatan[index]['warna'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 2,
                              color: Color(0xFFFFFFFF))),
                      Text(Catatan[index]['harga'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 2,
                              color: Color(0xFFFFFFFF))),
                      Text(Catatan[index]['stok'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 2,
                              color: Color(0xFFFFFFFF))),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => modalForm(Catatan[index]['id']),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () =>
                                deleteCatatan(Catatan[index]['id']),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //fungsi -> add
  Future<void> addCatatan(int id) async {
    await SQLHelper.addCatatan(namaController.text, tipeController.text,
        warnaController.text, hargaController.text, stokController.text);
    refreshCatatan();
  }

  //fungsi -> update
  Future<void> updateCatatan(int id) async {
    await SQLHelper.updateCatatan(id, namaController.text, tipeController.text,
        hargaController.text, warnaController.text, stokController.text);
    refreshCatatan();
  }

  //fungsi -> delete
  void deleteCatatan(int id) async {
    await SQLHelper.deleteCatatan(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfull Delete Catatan")));
    refreshCatatan();
  }

  //form add
  void modalForm(int id) async {
    if (id != null) {
      final dataCatatan = Catatan.firstWhere((element) => element['id'] == id);
      namaController.text = dataCatatan['nama'];
      tipeController.text = dataCatatan['tipe'];
      warnaController.text = dataCatatan['warna'];
      hargaController.text = dataCatatan['harga'];
      stokController.text = dataCatatan['stok'];
    }

    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(hintText: 'Nama'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: tipeController,
                      decoration: const InputDecoration(hintText: 'Tipe'),
                    ),
                    TextField(
                      controller: warnaController,
                      decoration: const InputDecoration(hintText: 'Warna'),
                    ),
                    TextField(
                      controller: hargaController,
                      decoration: const InputDecoration(hintText: 'Harga'),
                    ),
                    TextField(
                      controller: stokController,
                      decoration: const InputDecoration(hintText: 'Stok'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await addCatatan(id);
                          } else {
                            await updateCatatan(id);
                          }

                          // await tambahCatatan();
                          namaController.text = " ";
                          tipeController.text = " ";
                          warnaController.text = " ";
                          hargaController.text = " ";
                          stokController.text = " ";
                          Navigator.pop(context);
                        },
                        child: Text(id == null ? 'Add' : 'Update'))
                  ],
                ),
              ),
            ));
  }
}
