import 'product.dart';
import 'cartpage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  void navigateToCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => cartpage(),
      ),
    );
  }

  @override
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = ProductController().getproduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width > 600 ? 200 : 150,
        ),
        elevation: 8.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              navigateToCartPage(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [

          CarouselSlider(
            options: CarouselOptions(
              height:
              MediaQuery.of(context).size.width > 600 ? 200.0 : 150.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: [
              'assets/001.png',
              'assets/002.jpg',
              'assets/003.png',
            ].map((String assetPath) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              );
            }).toList(),
          ),

          FutureBuilder<List<Product>>(
            future: productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No products available.');
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.all(3),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10.0),
                            title: Row(
                              children: [
                                // Image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(product.image),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 70),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${product.productName}',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${product.price}',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              ElevatedButton.icon(
                                                  onPressed: () {
                                                    Product product = snapshot.data![index];
                                                    CartController().addToCart(product);

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('${product.productName} added to cart'),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}