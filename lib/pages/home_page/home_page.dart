import 'package:computing_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:get/get.dart';
import '../../navigation/app_routes.dart';

class HomePage extends StatelessWidget {
  final ColorScheme colorScheme;
  const HomePage({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          buildShelfRow(constraints),
          buildClockRow(constraints),
          buildDesktop(constraints),
          buildTableLegRow(constraints)
        ],
      );
    });
  }

  Container buildShelfRow(BoxConstraints constraints) {
    return Container(
      color: Colors.brown[500],
      height: constraints.maxHeight * 0.15,
      padding: const EdgeInsets.all(20),
      child: Container(
        color: Colors.brown[800],
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: (constraints.maxHeight * 0.15 - 40),
                  height: (constraints.maxHeight * 0.15 - 40),
                  alignment: Alignment.center,
                  child: CustomPaint(
                    foregroundPainter: BookPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
                SizedBox.square(
                  dimension: (constraints.maxHeight * 0.15 - 40),
                  child: GestureDetector(
                    onTap: () {
                      print("Book tapped");
                      Get.toNamed(AppRoutes.studyMethod);
                    },
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.settings);
              },
              child: Container(
                width: constraints.maxHeight * 0.15 - 40,
                height: constraints.maxHeight * 0.15 - 40,
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.white,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(Icons.person, size: 200),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: CustomPaint(
                        foregroundPainter: FrameLegPainter(),
                        child: const SizedBox.expand(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildDesktop(BoxConstraints constraints) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
                padding: const EdgeInsets.all(10),
                height: constraints.maxHeight * 0.3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CarouselView.weighted(
                    flexWeights: [1],
                    itemSnapping: true,
                    enableSplash: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    children: [
                      Container(
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: ButtonWidget(
                            colorScheme: colorScheme,
                            onPressed: () {
                              print("Study Method tapped");
                              Get.toNamed(AppRoutes.taskList);
                            },
                            child: Text("Study Method"),
                          )),
                      Container(
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: Text("I dont know what to put here"),
                      ),
                    ])),
          ),
          Container(
              height: constraints.maxHeight * 0.175,
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.brown[800],
                    ),
                  ),
                  Positioned(
                      bottom: (constraints.maxHeight * 0.15 / 2) - 30,
                      left: constraints.maxWidth * 0.3,
                      right: constraints.maxWidth * 0.3,
                      child: Column(
                        children: [
                          CustomPaint(
                            foregroundPainter: DesktopBasePainter(),
                            willChange: false,
                            child: Container(
                              height: 40,
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            height: 10,
                          ),
                        ],
                      )),
                  Positioned(
                      top: 0,
                      bottom: (constraints.maxHeight * 0.15 / 2),
                      left: constraints.maxWidth * 0.45,
                      right: constraints.maxWidth * 0.45,
                      child: Container(color: Colors.black)),
                ],
              )),
        ],
      ),
    );
  }

  Container buildClockRow(BoxConstraints constraints) {
    return Container(
      color: colorScheme.surface,
      height: constraints.maxHeight * 0.2,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(
                    (constraints.maxHeight * 0.2 - 40) / 2),
              ),
              child: AnalogClock(
                isLive: true,
                secondHandColor: Colors.red,
                showDigitalClock: false,
                showSecondHand: true,
                tickColor: Colors.black,
                textScaleFactor: 2,
                width: constraints.maxHeight * 0.2 - 50,
                height: constraints.maxHeight * 0.2 - 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      (constraints.maxHeight * 0.2 - 50) / 2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 40,
            child: SizedBox.square(
              dimension: (constraints.maxHeight * 0.15 - 40) / 1.5,
              child: Container(
                alignment: Alignment.center,
                color: Colors.green,
                child: Text("I am TourGuide"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildTableLegRow(BoxConstraints constraints) {
    return Container(
      color: Colors.brown[500],
      height: constraints.maxHeight * 0.15,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        color: colorScheme.surface,
      ),
    );
  }
}

class BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    double bookWidth = width / 4;

    Path path = Path();
    path
      ..moveTo(0, height * 0.1)
      ..lineTo(bookWidth, height * 0.1)
      ..lineTo(bookWidth, height)
      ..lineTo(bookWidth, height * 0.3)
      ..lineTo(bookWidth * 2, height * 0.3)
      ..lineTo(bookWidth * 2, height)
      ..lineTo(bookWidth * 2, height * 0.2)
      ..lineTo(bookWidth * 3, height * 0.2)
      ..lineTo(bookWidth * 3, height)
      ..lineTo(bookWidth * 3, height * 0.5)
      ..lineTo(bookWidth * 4, height * 0.5)
      ..lineTo(bookWidth * 4, height)
      ..lineTo(0, height);

    canvas.clipPath(path);

    Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    Paint strokePaint = Paint()
      ..strokeWidth = 3
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class FrameLegPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Path path = Path();
    Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    path
      ..moveTo(0, height / 2)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DesktopBasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Path path = Path();
    Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    path
      ..moveTo(0, height)
      ..lineTo(20, 0)
      ..lineTo(width - 20, 0)
      ..lineTo(width, height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
