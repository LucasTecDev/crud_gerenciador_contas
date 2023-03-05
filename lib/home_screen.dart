import 'dart:ffi';

import 'package:crud_sqlite/db.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;
  //Get All Data From Database

  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
   super.initState();
   _refreshData();
  }

  //ADD Data
  Future<void> _addData() async {
    await SQLHelper.createData(_titleController.text, _emailController.text, _senhaController.text);
    _refreshData();
  }
  
  //Update Data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _titleController.text, _emailController.text, _senhaController.text);
    _refreshData();
  }

  //delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('dado deletado'),
    )
    );
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();


  // se id náo é nulo, entao isso pode atualizar outra novo dado
  void showBottomSheet(int? id) async {
    if (id!= null) {
      final existingData = _allData.firstWhere((element) => element['id']==id);
      _titleController.text = existingData['title'];
      _emailController.text = existingData['email'];
      _senhaController.text = existingData['senha'];
    }

    showModalBottomSheet(
      elevation: 5,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  'Nova Conta',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30
                  ),
                  ),),
              SizedBox(height: 20,),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nome do App",
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _senhaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Senha",
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addData();
                    }
                    if (id != null) {
                      await _updateData(id);
                    }
                    _titleController.text = "";
                    _emailController.text = "";
                    _senhaController.text = "";
        
                    Navigator.of(context).pop();
                    print('dado adicionado');
                  },
                   child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(id == null ? "Adicinionar" : "Atualizar",
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                   ),
                    ),   
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title: Center(child: Text('Gerenciador de Contas')),
      ),
      body: _isLoading ? 
      Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(15),
          // child: ListTile(
          //   title: Padding(padding: EdgeInsets.symmetric(vertical: 5),
          //   child: Text(_allData[index]['title'],
          //   style: TextStyle(
          //     fontSize: 20,
          //   ),
          //   ),
          //   ),
          //   subtitle: Text(_allData[index]['email']),
          //   trailing: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //      IconButton(onPressed: () {
          //       showBottomSheet(_allData[index]['id']);
          //      }, 
          //      icon: Icon(Icons.edit, color: Colors.indigo,),
          //      ),
          //      IconButton(onPressed: () {
          //       _deleteData(_allData[index]['id']);
          //      }, 
          //      icon: Icon(Icons.delete, color: Colors.red,),
          //      ),
          //     ],
          //   ),
          // ),
          child: ListTile(
            title: Padding(padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Text(_allData[index]['title'],
                style: TextStyle(
                fontSize: 20,
                ),
              ),
              Row(
                children: [
                  Text('Email:',style: TextStyle(color: Colors.indigo),),
                  SizedBox(width: 4,),
                  Text(
                    _allData[index]['email'],
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Senha:',style: TextStyle(color: Colors.indigo)),
                  SizedBox(width: 4,),
                  Text(
                    _allData[index]['senha'],
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              
              Row(
                
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(),
                  SizedBox(width: 252,),
                  IconButton(onPressed: () {
                showBottomSheet(_allData[index]['id']);
               }, 
               icon: Icon(Icons.edit, color: Colors.indigo,),
               ),
               IconButton(onPressed: () {
                _deleteData(_allData[index]['id']);
               }, 
               icon: Icon(Icons.delete, color: Colors.red,),
               ),
                ],
              )
              ],
            ),
          ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
        ),
    );
  }
}