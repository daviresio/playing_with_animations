import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';
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
  late final AnimationController _animationEnterPageController;
  Animation<Size>? _scaleAnimation;
  Animation<Size>? _translateAnimation;
  Animation<double>? _translateElementsAnimation;

  final secondDuration = 1 / 31;

  @override
  void initState() {
    super.initState();

    _animationCronController =
        AnimationController(vsync: this, duration: const Duration(seconds: 31));

    _animationEnterPageController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _translateElementsAnimation = Tween(
        begin: MediaQuery.of(context).size.width / 2,
        end: 0.0,
      ).animate(CurvedAnimation(
          parent: _animationEnterPageController, curve: Curves.easeIn));

      _animationEnterPageController.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCron(Size screenSize) {
    // _scaleAnimation = Tween(
    //   begin: Size(Tick.tickSize.width, Tick.tickSize.height),
    //   end: screenSize,
    // ).animate(CurvedAnimation(
    //   parent: _animationCronController,
    //   curve: Interval(0, secondDuration),
    // ));

    final fraction = screenSize.height / 30;
    var _lastHeight = screenSize.height;
    var _lastTranslated = screenSize.height;

    _scaleAnimation = TweenSequence(<TweenSequenceItem<Size>>[
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

    _translateAnimation = TweenSequence(<TweenSequenceItem<Size>>[
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

    // _translateAnimation = Tween(
    //   begin: const Size(0, 0),
    //   end: screenSize,
    // ).animate(CurvedAnimation(
    //   parent: _animationCronController,
    //   curve: Interval(0, secondDuration),
    // ));

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
    final middleY = size.height / 2 + Tick.tickSize.height / 2;

    return Material(
      child: Container(
        color: SciensaColors.background,
        child: Stack(
          children: [
            AnimatedBuilder(
                animation: _animationCronController,
                builder: (_, __) {
                  return Positioned(
                    left: -(_translateElementsAnimation?.value ?? 0),
                    top: middleY,
                    child: Row(
                      children: const [
                        Tick(),
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
              animation: _animationCronController,
              builder: (_, __) {
                return Positioned(
                  right: -(_translateElementsAnimation?.value ?? 0),
                  top: middleY,
                  child: Row(
                    children: const [
                      Tick(),
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

            IgnorePointer(
              ignoring: true,
              child: AnimatedBuilder(
                  animation: _animationCronController,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: Offset(
                          195 - (_translateAnimation?.value.width ?? 0) / 2,
                          middleY -
                              (_translateAnimation?.value.height ?? 0) / 2),
                      child: Container(
                        color: SciensaColors.red,
                        width:
                            _scaleAnimation?.value.width ?? Tick.tickSize.width,
                        height: _scaleAnimation?.value.height ??
                            Tick.tickSize.height,
                      ),
                    );
                  }),
            ),
            Container(
              width: size.width,
              margin: EdgeInsets.only(top: middleY - 180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _currentSeconds.toString(),
                    style: const TextStyle(
                        color: SciensaColors.white, fontSize: 60),
                  ),
                  const Text('seconds',
                      style:
                          TextStyle(color: SciensaColors.gray2, fontSize: 20))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: CircleButton(
                  title: 'START',
                  onPressed: () => _startCron(size),
                ),
              ),
            ),
            // AnimatedTick(animation: _animation),
          ],
        ),
      ),
    );
  }
}
