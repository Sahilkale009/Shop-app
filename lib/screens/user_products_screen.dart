import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
        title: Text('Your Products'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: ((context, value, child) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemBuilder: ((_, index) => Column(
                                      children: [
                                        UserProductItem(
                                          productsData.items[index].id,
                                          productsData.items[index].title,
                                          productsData.items[index].imageUrl,
                                        ),
                                        Divider(),
                                      ],
                                    )),
                                itemCount: productsData.items.length,
                              ),
                            )),
                      ),
                    )),
    );
  }
}
