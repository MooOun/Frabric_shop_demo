import 'package:fabricshopdemo/categories/men_category.dart';
import 'package:fabricshopdemo/categories/woman_category.dart';
import 'package:flutter/material.dart';


class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final PageController _pageController = PageController();
  List<ItemsData> _items = [
    ItemsData(label: 'ผู้ชาย'),
    ItemsData(label: 'ผู้หญิง'),
    ItemsData(label: 'เด็ก'),
    ItemsData(label: 'แบรนด์เนม'),
    ItemsData(label: 'รองเท้า'),
    ItemsData(label: 'อื่นๆ'),
   
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('หมวดหมู่สินค้า'),
        backgroundColor: Colors.purple.shade500,
      ),
      body: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: sideNavigator(size),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: categoryView(size),
        ),
      ]),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.823,
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(index,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.bounceIn);
            },
            child: Container(
              color: _items[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              height: 100,
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _items[index].label,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget categoryView(Size size) {
    return Container(
        height: size.height * 0.85,
        width: size.width * 0.8,
        color: Colors.white,
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              for (var element in _items) {
                element.isSelected = false;
              }
              setState(() {
                _items[value].isSelected = true;
              });
            });
          },
          scrollDirection: Axis.vertical,
          children: [
            MenCategory(),
            WomanCategory(),
            Center(
              child: Text('เด็ก Category'),
            ),
            Center(
              child: Text('แบรนด์เนม Category'),
            ),
            Center(
              child: Text('รองเท้า Category'),
            ),
            Center(
              child: Text('อื่นๆ Category'),
            ),
          ],
        ));
  }
}

class ItemsData {
  final String label;
  bool isSelected;

  ItemsData({required this.label, this.isSelected = false});
}
