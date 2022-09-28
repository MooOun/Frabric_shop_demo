import 'package:flutter/material.dart';
import 'package:fabricshopdemo/gallery/kids_gallery.dart';
import 'package:fabricshopdemo/gallery/shoes_gallery.dart';
import 'package:fabricshopdemo/gallery/women_gallery.dart';
import 'package:fabricshopdemo/minor_screens/search_screen.dart';
import 'package:fabricshopdemo/widgets/fake_search.dart';

import '../gallery/men_gallery.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: FakeSearch(),
          bottom: TabBar(
            indicatorColor: Colors.purple.shade500,
            indicatorWeight: 2,
            isScrollable: true,
            tabs: [
              RepeatedTab(
                text: 'Men',
              ),
              RepeatedTab(
                text: 'Women',
              ),
              RepeatedTab(
                text: 'Shoes',
              ),
              RepeatedTab(
                text: 'Kids',
              ),
              RepeatedTab(
                text: 'Brandname',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          MenGallery(),
          WomenGallery(),
          ShoesGallery(),
          KidsGallery(),
          Center(child: Text('Brandname'))
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String text;
  const RepeatedTab({Key? key, required this.text})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
