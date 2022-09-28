import 'package:flutter/material.dart';

class FullImageScreen extends StatefulWidget {
  final List<dynamic> imagesList;

  const FullImageScreen({super.key, required this.imagesList});
  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  final PageController _pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                ("${index + 1}") + ('/') + widget.imagesList.length.toString(),
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 1.7,
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                controller: _pageController,
                children: List.generate(widget.imagesList.length, (index) {
                  return InteractiveViewer(
                    transformationController: TransformationController(),
                    child: Image(
                        image:
                            NetworkImage(widget.imagesList[index].toString())),
                  );
                }),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imagesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(index);
                      },
                      child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.cyan,
                            ),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Image.network(
                            widget.imagesList[index].toString(),
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
