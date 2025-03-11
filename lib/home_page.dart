import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/cart_provider.dart';

import 'item.dart';
import 'cart_provider.dart';

class  HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    CartProvider cartProvider = Provider.of<CartProvider>(context);

    final List<Item> _catalog = [
      Item(1, 'bags', 10.00, 'bags.jpg'),
      Item(2, 'books', 20.00, 'books.jpg'),
      Item(3, 'cake', 30.00, 'cake.jpg'),
      Item(4, 'hats', 40.00, 'hats.jpg'),
      Item(5, 'shirts', 50.00, 'shirts.jpg'),
      Item(6, 'shoes', 60.00, 'shoes.jpg'),
      Item(7, 'tie', 70.00, 'tie.jpg'),
    ];

     return Scaffold(
       appBar: AppBar(
         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: Text('State_Management'),
         
       ),
       body: ListView.separated(
         itemBuilder: (BuildContext context, int index) {
           return ListTile(
             leading: CircleAvatar(
               backgroundImage: AssetImage('assets/images/${_catalog[index].ItemImage}'),
             ),
             
             title: Text(_catalog[index].ItemDescription),
             
             subtitle: Text('RM ${_catalog[index].ItemPrice.toStringAsFixed(2)}'),
             
             trailing: Checkbox(
                 value: cartProvider.itemList.contains(_catalog[index]),
                 onChanged: (value){}),
           );
         },

         separatorBuilder: (BuildContext context, int index) {
            return const Divider();
         }, //line between

         itemCount: _catalog.length,

       ),
     );
  }
}
