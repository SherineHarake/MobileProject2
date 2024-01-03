import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  final double finalPrice;

  Checkout({Key? key, required this.finalPrice}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double discount = 0.10;
  double discountedPrice = 0.0;
  bool promoCodeApplied = false;

  String name = '';
  String email = '';
  String address = '';
  String city = '';
  String country = '';
  String telephone = '';

  void applyPromoCode() {
    setState(() {
      promoCodeApplied = true;
      discountedPrice = widget.finalPrice * (1 - discount);
    });
  }

  void placeOrder(BuildContext context) {
    if (validateInputs()) {
      double orderPrice = promoCodeApplied ? discountedPrice : widget.finalPrice;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Order Placed Successfully"),
            content: Text("The order with price : \$${orderPrice.toStringAsFixed(2)} will be sent soon to the provided address."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all required fields."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  bool validateInputs() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        address.isNotEmpty &&
        city.isNotEmpty &&
        country.isNotEmpty &&
        telephone.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
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
                    'Do you have a PROMO CODE  ? ',
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
                            onChanged: (value) => name = value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Promo Code for 10% ',
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
                  // ... (unchanged code)

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              onChanged: (value) => name = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email: ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              onChanged: (value) => email = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              onChanged: (value) => address = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City: ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              onChanged: (value) => city = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'City',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Country: ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              onChanged: (value) => country = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Country',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Telephone: ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              onChanged: (value) => telephone = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Telephone',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => placeOrder(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 14.0 : 12.0,
                          color: Colors.white,
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
    );
  }
}
