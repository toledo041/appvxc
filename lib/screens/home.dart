import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/screens/pdf_screen.dart';
import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../screens/details.dart';
import '../model/categories_model.dart';
import '../../utils/constants.dart';
import '../model/base_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  final int _currentIndex = 2;

  @override
  void initState() {
    _pageController =
        PageController(initialPage: _currentIndex, viewportFraction: 0.7);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    textTheme.bodySmall;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Text
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Vx",
                            style: textTheme.headlineLarge,
                            children: [
                              TextSpan(
                                text: "C",
                                style: textTheme.headlineLarge?.copyWith(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: "Compras por catalogo en un click",
                            style: TextStyle(
                              color: Color.fromARGB(186, 0, 0, 0),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Categories
                FadeInUp(
                  delay: const Duration(milliseconds: 450),
                  child: Container(
                      margin: const EdgeInsets.only(top: 7),
                      width: size.width,
                      height: size.height * 0.17,
                      child: Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (ctx, index) {
                              CategoriesModel current = categories[index];
                              return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PdfScreen(
                                                          path: current.pdfUrl,
                                                          marca: current.title,
                                                        )));
                                          },
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage:
                                                AssetImage(current.imageUrl),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.008,
                                        ),
                                        Text(
                                          current.title,
                                          style: textTheme.bodySmall,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                      )),
                ),

                /// Body Slider
                FadeInUp(
                  delay: const Duration(milliseconds: 550),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: size.width,
                    height: size.height * 0.36,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: mainList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Details(
                                    data: mainList[index],
                                    isCameFromMostPopularPart: false,
                                  ),
                                ),
                              );
                            },
                            child: view(index, textTheme, size));
                      },
                    ),
                  ),
                ),

                /// Most Popular Text
                FadeInUp(
                  delay: const Duration(milliseconds: 650),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mas Popular", style: TextStyle(fontSize: 14)),
                        //Text("Ver todo", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),

                /// Most Popular Content
                FadeInUp(
                  delay: const Duration(milliseconds: 750),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    width: size.width,
                    height: size.height * 0.5, //0.44
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: mainList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.63), //0.63
                        itemBuilder: (context, index) {
                          BaseModel current = mainList[index];
                          return GestureDetector(
                            onTap: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    return Details(
                                      data: current,
                                      isCameFromMostPopularPart: true,
                                    );
                                  }),
                                )),
                            child: Hero(
                              tag: current.imageUrl,
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width * 0.45,
                                    height: size.height * 0.2,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      image: DecorationImage(
                                        image: AssetImage(current.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                          color: Color.fromARGB(61, 0, 0, 0),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      current.name,
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text:
                                              "${String.fromCharCode(36)} ", //"peso",
                                          style:
                                              textTheme.headlineSmall?.copyWith(
                                            color: primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                        TextSpan(
                                          text: current.price.toString(),
                                          style:
                                              textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ])),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Page View
  Widget view(int index, TextTheme theme, Size size) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0.0;
          if (_pageController.position.haveDimensions) {
            value = index.toDouble() - (_pageController.page ?? 0);
            value = (value * 0.04).clamp(-1, 1);
          }
          return Transform.rotate(
            angle: 3.14 * value,
            child: card(mainList[index], theme, size),
          );
        });
  }

  /// Page view Cards
  Widget card(BaseModel data, TextTheme theme, Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Hero(
            tag: data.id,
            child: Container(
              width: size.width * 0.42,
              height: size.height * 0.22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                image: DecorationImage(
                  image: AssetImage(data.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Color.fromARGB(61, 0, 0, 0))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              data.name,
              style: theme.bodyLarge,
            ),
          ),
          RichText(
            text: TextSpan(
              text: "${String.fromCharCode(36)} ", //"peso",
              style: theme.headlineSmall?.copyWith(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: data.price.toString(),
                  style: theme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
