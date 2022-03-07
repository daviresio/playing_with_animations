import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/math_helper.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';
import 'package:test_sciensa/helpers/sciensa_radius.dart';
import 'package:test_sciensa/home/components/circle_button.dart';
import 'package:test_sciensa/home/components/tick.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _defaultSeconds = 30;
  var _currentSeconds = 30;
  Timer? _timer;

  late final AnimationController _animationCronController;
  late final AnimationController _animationElementsController;
  Animation<Size>? _scaleBackgroundAnimation;
  Animation<Size>? _translateBackgroundAnimation;
  Animation<double>? _translateTicksAnimation;
  Animation<double>? _translateTextAnimation;

  final secondDuration = 1 / 31;

  @override
  void initState() {
    super.initState();

    _animationCronController =
        AnimationController(vsync: this, duration: const Duration(seconds: 31));

    _animationCronController.addListener(() {
      if (_animationCronController.status == AnimationStatus.completed) {
        _animationCronController.reset();
        _animationElementsController.forward();
      }
    });

    _animationElementsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _translateTicksAnimation = Tween(
        begin: MediaQuery.of(context).size.width / 2,
        end: 0.0,
      ).animate(CurvedAnimation(
          parent: _animationElementsController, curve: Curves.easeIn));

      _translateTextAnimation = Tween(
        begin: 0.0,
        end: 130.0,
      ).animate(CurvedAnimation(
          parent: _animationElementsController, curve: Curves.easeIn));

      _animationElementsController.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCron(Size screenSize) {
    final fraction = screenSize.height / 30;
    var _lastHeight = screenSize.height;
    var _lastTranslated = screenSize.height;

    _scaleBackgroundAnimation = TweenSequence(<TweenSequenceItem<Size>>[
      TweenSequenceItem(
        tween: Tween(
          begin: Size(Tick.tickSize.width, Tick.tickSize.height),
          end: screenSize,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      ...List.generate(30, (index) {
        final _currentHeight = _lastHeight;
        _lastHeight = _lastHeight - fraction;
        return TweenSequenceItem(
          tween: Tween(
            begin: Size(screenSize.width, _currentHeight),
            end:
                Size(screenSize.width, _lastHeight.clamp(0, screenSize.height)),
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        );
      }),
    ]).animate(_animationCronController);

    _translateBackgroundAnimation = TweenSequence(<TweenSequenceItem<Size>>[
      TweenSequenceItem(
        tween: Tween(
          begin: const Size(0, 0),
          end: screenSize,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      ...List.generate(30, (index) {
        final _currentTranslated = _lastTranslated;
        _lastTranslated = _lastTranslated - fraction * 2;
        return TweenSequenceItem(
          tween: Tween(
            begin: Size(screenSize.width, _currentTranslated),
            end: Size(screenSize.width, _lastTranslated),
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        );
      }),
    ]).animate(_animationCronController);

    _animationElementsController.reverse();
    _animationCronController.forward();

    setState(() {
      _currentSeconds = _defaultSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentSeconds > 0) {
          setState(() {
            _currentSeconds = _currentSeconds - 1;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final middleY = size.height / 2;

    return Material(
      child: Container(
        color: SciensaColors.background,
        child: Stack(
          children: [
            AnimatedBuilder(
                animation: _animationElementsController,
                builder: (_, __) {
                  return Positioned(
                    left: -(_translateTicksAnimation?.value ?? 0),
                    top: middleY + Tick.tickSize.height / 2,
                    child: Row(
                      children: const [
                        Tick(),
                        Tick(),
                        Tick(),
                        Tick(),
                        Tick(),
                      ],
                    ),
                  );
                }),
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) {
                return Positioned(
                  right: -(_translateTicksAnimation?.value ?? 0),
                  top: middleY + Tick.tickSize.height / 2,
                  child: Row(
                    children: const [
                      Tick(),
                      Tick(),
                      Tick(),
                      Tick(),
                      Tick(),
                    ],
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) {
                return Positioned(
                  left: size.width / 2 - CircleButton.size / 2,
                  bottom: MathHelper.remap(_animationElementsController.value,
                      0, 1, -CircleButton.size, 80),
                  child: CircleButton(
                    title: 'START',
                    onPressed: () => _startCron(size),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_animationCronController, _animationElementsController]),
              builder: (_, __) {
                return Positioned(
                  left: 0,
                  top: MathHelper.remap(
                    _animationCronController.status == AnimationStatus.forward
                        ? 1
                        : _animationElementsController.value,
                    0,
                    1,
                    middleY,
                    0,
                  ),
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: Offset(
                          size.width / 2 -
                              (_translateBackgroundAnimation?.value.width ??
                                      0) /
                                  2,
                          middleY -
                              (_translateBackgroundAnimation?.value.height ??
                                      0) /
                                  2),
                      child: Container(
                        width: _scaleBackgroundAnimation?.value.width ??
                            Tick.tickSize.width,
                        height: _scaleBackgroundAnimation?.value.height ??
                            Tick.tickSize.height * 1.5,
                        decoration: BoxDecoration(
                          color: SciensaColors.red,
                          borderRadius:
                              BorderRadius.circular(SciensaRadius.small),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) {
                return Positioned(
                  left: 0,
                  top: middleY - (_translateTextAnimation?.value ?? 0),
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _currentSeconds.toString(),
                          style: const TextStyle(
                            color: SciensaColors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Opacity(
                          opacity: (_animationElementsController.value * 10)
                              .clamp(0, 1),
                          child: const Text(
                            'seconds',
                            style: TextStyle(
                              color: SciensaColors.gray2,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
