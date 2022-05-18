import 'package:flutter/material.dart';

class NoDataChat extends StatelessWidget {
  const NoDataChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.grey,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'No Massage',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
