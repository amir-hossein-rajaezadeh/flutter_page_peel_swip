import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Page Peel Swip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Defines the drag calculation function, which handles the user's swipe gesture.
  void dragCalculation(
      int index, PointerMoveEvent details, double deviceWidth) {
    setState(() {
      selectedIndex = index;
    });

    if (details.delta.dx > 0 || details.delta.dx < 0) {
      setState(() {
        secLayerImageWidth = details.localPosition.dx;
        imageWidth = (deviceWidth - 40) - secLayerImageWidth;
      });

      if (imageWidth < 25 && details.delta.dx > 0) {
        setState(() {
          secLayerImageWidth =
              MediaQueryData.fromView(View.of(context)).size.width - 30;
          imageWidth = (deviceWidth - 40);
        });
      }

      if (details.delta.distance > 30) {
        if (details.delta.dx > 0) {
          setState(() {
            secLayerImageWidth =
                MediaQueryData.fromView(View.of(context)).size.width - 30;
            imageWidth = (deviceWidth - 20);
          });
        } else {
          setState(
            () {
              secLayerImageWidth = 50;
              imageWidth = (deviceWidth - 40) - secLayerImageWidth;
            },
          );
        }
      }
    }
  }

  // Defines the initial width of the image.
  double imageWidth = 10;

  // Defines the initial width of the second layer image.
  double secLayerImageWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width - 30;

  // Defines the index of the selected item.
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Defines the device width.
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFC7CDCA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for the Search Movies text.
            Container(
              margin: const EdgeInsets.only(top: 28, left: 14),
              child: const Text(
                "Search Movies",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                  hintText: "Search Movies...",
                  hintStyle: TextStyle(color: Color(0xFFA2A8A5), fontSize: 18),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  filled: true,
                  fillColor: Color(0xFFB6BCBB),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Listener(
                      // Listener for the user's swipe gesture.
                      onPointerMove: (details) {
                        dragCalculation(index, details, deviceWidth);
                      },
                      child: SizedBox(
                        height: 175,
                        width: double.infinity,
                        child: selectedIndex == index
                            ? _buildCardWidget(
                                context,
                                index,
                                selectedIndex,
                                secLayerImageWidth,
                                deviceWidth,
                                imageWidth,
                              )
                            : _buildImageItem(index, selectedIndex,
                                secLayerImageWidth, deviceWidth),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 20,
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

AnimatedContainer _buildImageItem(int index, int selectedIndex,
    double secLayerImageWidth, double deviceWidth) {
  return AnimatedContainer(
    // Animated container for the second layer image.
    margin: const EdgeInsets.only(right: 0, left: 20),
    width: secLayerImageWidth,
    height: 175,
    duration: const Duration(milliseconds: 0),
    child: ClipRRect(
      borderRadius:
          selectedIndex != index || secLayerImageWidth == deviceWidth - 30
              ? BorderRadius.circular(18)
              : const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
      child: Image.asset(
        "assets/images/img$index.jpeg",
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topLeft,
      ),
    ),
  );
}

// Defines the buildCardWidget function, which builds the card widget.
Widget _buildCardWidget(BuildContext context, int index, int selectedIndex,
    double secLayerImageWidth, double deviceWidth, double imageWidth) {
  return Stack(
    children: [
      Center(
        child: Container(
          margin: const EdgeInsets.only(right: 0, left: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20,
            ),
            gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 226, 49, 37),
                  Color.fromARGB(255, 244, 107, 107),
                ],
                begin: FractionalOffset(0, 1),
                end: FractionalOffset(0, 0),
                tileMode: TileMode.clamp),
          ),
          height: 160,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                CupertinoIcons.delete,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
      // Animated container for the second layer image.
      _buildImageItem(index, selectedIndex, secLayerImageWidth,
          deviceWidth), // Positioned container for the swipe effect.
      if (secLayerImageWidth != deviceWidth - 30)
        Positioned(
          right: imageWidth < 0 ? imageWidth *= -1 : imageWidth,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: AnimatedContainer(
                    width: imageWidth,
                    height: 220,
                    duration: const Duration(milliseconds: 0),
                    child: Transform.flip(
                      flipX: true,
                      child: Opacity(
                        opacity: 0.7,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.asset(
                            "assets/images/img$index.jpeg",
                            fit: BoxFit.cover,
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 3,
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
