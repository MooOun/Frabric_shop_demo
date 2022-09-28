import 'package:flutter/material.dart';
import 'package:fabricshopdemo/minor_screens/subCategoryProducts.dart';
import 'package:fabricshopdemo/utilities/categ_list.dart';

class WomanCategory extends StatefulWidget {
  @override
  State<WomanCategory> createState() => _WomanCategory();
}

class _WomanCategory extends State<WomanCategory> {
  List<String> label = [
    'shirt',
    'jeans',
    'shoes',
    'jacket',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryHeaderLabel(
                  headlable: 'ผู้หญิง',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.63,
                  child: GridView.count(
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 15,
                    crossAxisCount: 2,
                    children: List.generate(
                      men.length - 1,
                      (index) {
                        return SubCategoryButton(
                          menCategoryName: 'women',
                          subCategoryName: men[index + 1],
                          assetName: 'assets/images/women/women$index.jpg',
                          subCategoryLabel: men[index + 1],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(
                    0.2,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Row(
                    children: [
                      Text(
                        '<<',
                        style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 10,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'woman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SubCategoryButton extends StatelessWidget {
  final String menCategoryName;
  final String subCategoryName;
  final String assetName;
  final String subCategoryLabel;
  const SubCategoryButton({
    required this.menCategoryName,
    required this.subCategoryLabel,
    required this.assetName,
    required this.subCategoryName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => SubCategoryProducts(
                  subCategoryName: subCategoryName,
                  menCategoryName: menCategoryName,
                ))));
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image.asset(assetName),
          ),
          Text(
            subCategoryLabel,
          ),
        ],
      ),
    );
  }
}

class CategoryHeaderLabel extends StatelessWidget {
  final String headlable;
  const CategoryHeaderLabel({
    required this.headlable,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        headlable,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}
