import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _baseURL = 'https://sherinemobile.000webhostapp.com/';

class Order extends StatefulWidget {
  final double finalPrice;

  Order({Key? key, required this.finalPrice}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerCity = TextEditingController();
  TextEditingController _controllerCountry = TextEditingController();
  TextEditingController _controllerTelephone = TextEditingController();

  bool _loading = false;
  double discount = 0.10;
  double discountedPrice = 0.0;
  bool promoCodeApplied = false;

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerAddress.dispose();
    _controllerCity.dispose();
    _controllerCountry.dispose();
    _controllerTelephone.dispose();

    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  void applyPromoCode() {
    setState(() {
      promoCodeApplied = true;
      discountedPrice = widget.finalPrice * (1 - discount);
    });
  }

  void saveOrder() async {
    try {
      final double priceToSend = promoCodeApplied ? discountedPrice : widget.finalPrice;

      final response = await http.post(
        Uri.parse('$_baseURL/order.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, dynamic>{
          'name': _controllerName.text,
          'email': _controllerEmail.text,
          'address': _controllerAddress.text,
          'city': _controllerCity.text,
          'country': _controllerCountry.text,
          'telephone': _controllerTelephone.text,
          'price': priceToSend.toString(),
        }),
      ).timeout(const Duration(seconds: 5));


      if (response.statusCode == 200) {
        update(response.body);
      } else {
        update("Error: ${response.statusCode}");
      }
    } catch (e) {
      update("Connection error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Thanks for Shopping!',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ClipOval(
                  child: Image.asset(
                    "assets/bag.jpg",
                    width: MediaQuery.of(context).size.width > 600 ? 120.0 : 80.0,
                    height: MediaQuery.of(context).size.width > 600 ? 120.0 : 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Final Price: \$${widget.finalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? 20 : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Do you have a PROMO CODE?',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 40.0,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Promo Code for 10%',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: applyPromoCode,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600 ? 14.0 : 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (promoCodeApplied)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width > 600 ? 16.0 : 10.0),
                      child: Text(
                        'Discounted Price: \$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? 20 : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Full Name',
                              hintText: 'Enter Full Name',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Enter Email',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Address',
                              hintText: 'Enter Address',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerCity,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'City',
                              hintText: 'Enter City',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(

                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerCountry,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Country',
                              hintText: 'Enter Country',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your country';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerTelephone,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Telephone',
                              hintText: 'Enter Telephone',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your telephone';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: _loading
                          ? null
                          : () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          saveOrder();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all the required fields.'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 120,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _loading ? Colors.grey : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
