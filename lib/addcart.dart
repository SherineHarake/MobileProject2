import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'home.dart';


const String _baseURL = 'https://sherinemobile.000webhostapp.com';

EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();


class AddtoCart extends StatefulWidget {

  const AddtoCart({super.key});

  @override
  State<AddtoCart> createState() => _AddtoCartState();
}

class _AddtoCartState extends State<AddtoCart> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  bool _loading = false;


  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: () {
            _encryptedData.remove('myKey').then((success) =>
                Navigator.of(context).pop());
          }, icon: const Icon(Icons.logout))
        ],
          title: const Text('Add Category'),
          centerTitle: true,

          automaticallyImplyLeading: false,
        ),
        body: Center(child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _controllerID,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    labelText: '12',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  readOnly: true,
                  showCursor: false,
                  onTap: () {

                  },

                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _controllerName,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  readOnly: true,
                  showCursor: false,
                  onTap: () {

                  },

                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _loading ? null : () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    saveCategory(update, int.parse(_controllerID.text.toString()), _controllerName.text.toString());
                  }
                },
                icon: Icon(
                  Icons.add_shopping_cart,
                  size: 15,
                ),
                label: Text(''),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.all(0),
                  shadowColor: Colors.transparent,
                ),
              ),

              const SizedBox(height: 10),
              Visibility(visible: _loading, child: const CircularProgressIndicator())
            ],
          ),
        )));
  }
}

// below function sends the cid, name and key using http post to the REST service
void saveCategory(Function(String text) update, int cid, String name) async {
  try {
    // we need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // send a JSON object using http post
    final response = await http.post(
        Uri.parse('$_baseURL/addcart.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, // convert the cid, name and key to a JSON object
        body: convert.jsonEncode(<String, String>{
          'cid': '$cid', 'name': name, 'key': myKey
        })).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      // if successful, call the update function
      update(response.body);
    }
  }
  catch(e) {
    update("connection error");
  }
}
