import 'package:flutter/material.dart';
import 'product.dart';
import 'Login.dart';

class cartpage extends StatefulWidget {
  const cartpage({Key? key}) : super(key: key);

  @override
  State<cartpage> createState() => _cartpageState();
}

class _cartpageState extends State<cartpage> {
  List<Product> cartItems = CartController().cartItems;
  double calculateTotalPrice() {
    double total = 0.0;

    for (Product product in CartController().cartItems) {
      total += (product.price * product.quantity);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    List<Product> cartItems = CartController().cartItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          width: 200,
        ),
        elevation: 8.0,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          Product product = cartItems[index];

          return ListTile(
            title: Text(product.productName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${product.price.toString()}'),
              ],
            ),
            leading: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(product.image),
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (product.quantity > 1) {
                        product.quantity--;
                      }
                    });
                  },
                  iconSize: 20,
                ),
                Text(
                  ' ${product.quantity}',
                  style: TextStyle(fontSize: 15),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (product.quantity < 10) {
                        product.quantity++;
                      }
                    });
                  },
                  iconSize:20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '\$${(product.price * product.quantity).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      CartController().cartItems.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price: \$${calculateTotalPrice()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed:  calculateTotalPrice() == 0
                    ? null
                    : () {
                  double finalPrice = calculateTotalPrice();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(finalPrice: finalPrice),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(200.0, 0),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}