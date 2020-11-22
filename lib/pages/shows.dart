import 'package:flutter/material.dart';

class Shows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(),
      // child: Container(
      //   height: 500,
      //   width: 350,
      //   color: Colors.grey[800],
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: Image(
      //           image: AssetImage('ett.jpeg'),
      //         ),
      //       ),
      //       Expanded(
      //         child: Row(
      //           children: [
      //             Column(
      //               children: [
      //                 Text('Show Title'),
      //                 Text('Show Description'),
      //                 Text('Broadcasting time'),
      //               ],
      //             ),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 GestureDetector(
      //                   child: Container(
      //                     height: 10,
      //                     width: 25,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(10.0),
      //                     ),
      //                     child: Text('Edit Show'),
      //                   ),
      //                 ),
      //                 GestureDetector(
      //                   child: Container(
      //                     height: 10,
      //                     width: 25,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(10.0),
      //                     ),
      //                     child: Text('Delete'),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
