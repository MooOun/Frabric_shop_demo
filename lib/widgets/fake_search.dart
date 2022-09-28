import 'package:fabricshopdemo/minor_screens/search_screen.dart';
import 'package:flutter/material.dart';


class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return SearchScreen();
        }));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.purple.shade400,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(
            25,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(Icons.search, color: Colors.purple.shade500),
            Text(
              'ค้นหาสิ่งที่คุณสนใจ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.purple.shade500,
                borderRadius: BorderRadius.circular(
                  25,
                ),
              ),
              child: Center(
                child: Text(
                  'ค้นหา',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
