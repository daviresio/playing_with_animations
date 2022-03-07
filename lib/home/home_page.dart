import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';
import 'package:test_sciensa/helpers/sciensa_radius.dart';
import 'package:test_sciensa/helpers/sciensa_spacing.dart';
import 'package:test_sciensa/helpers/text_extension.dart';
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

  var _size = Size.zero;
  var _middleY = 0.0;

  final _animatedTickHeight = Tick.tickSize.height * 1.5;

  Timer? _timer;

  late final AnimationController _animationCronController;
  late final AnimationController _animationElementsController;
  Animation<Size>? _scaleBackgroundAnimation;
  Animation<Size>? _translateBackgroundAnimation;
  Animation<double>? _translateTicksAnimation;
  Animation<double>? _translateTextAnimation;
  Animation<double>? _translateButtonAnimation;
  Animation<double>? _translateAnimatedTick;

  @override
  void initState() {
    super.initState();

    _animationCronController = AnimationController(
        vsync: this, duration: Duration(seconds: _defaultSeconds + 1));

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
        begin: _size.width / 2,
        end: 0.0,
      ).animate(CurvedAnimation(
          parent: _animationElementsController, curve: Curves.easeIn));

      _translateTextAnimation = Tween(
        begin: 0.0,
        end: SciensaSpacing.xxl,
      ).animate(CurvedAnimation(
          parent: _animationElementsController, curve: Curves.easeIn));

      _translateButtonAnimation = Tween(
        begin: -CircleButton.size,
        end: SciensaSpacing.xl,
      ).animate(CurvedAnimation(
          parent: _animationElementsController, curve: Curves.easeIn));

      _translateAnimatedTick = Tween(
        begin: _middleY,
        end: 0.0,
      ).animate(CurvedAnimation(
          parent: _animationElementsController, curve: Curves.easeIn));

      final fraction = _size.height / _defaultSeconds;
      var _lastHeight = _size.height;
      var _lastTranslated = _size.height;

      _scaleBackgroundAnimation = TweenSequence(<TweenSequenceItem<Size>>[
        TweenSequenceItem(
          tween: Tween(
            begin: Size(Tick.tickSize.width, _animatedTickHeight),
            end: _size,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 1,
        ),
        ...List.generate(_defaultSeconds, (index) {
          final _currentHeight = _lastHeight;
          _lastHeight = _lastHeight - fraction;

          return TweenSequenceItem(
            tween: Tween(
              begin: Size(_size.width, _currentHeight),
              end: Size(_size.width, _lastHeight.clamp(0, _size.height)),
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1,
          );
        }),
      ]).animate(_animationCronController);

      _translateBackgroundAnimation = TweenSequence(<TweenSequenceItem<Size>>[
        TweenSequenceItem(
          tween: Tween(
            begin: Size.zero,
            end: _size,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 1,
        ),
        ...List.generate(_defaultSeconds, (index) {
          final _currentTranslated = _lastTranslated;
          _lastTranslated = _lastTranslated - fraction * 2;
          return TweenSequenceItem(
            tween: Tween(
              begin: Size(_size.width, _currentTranslated),
              end: Size(_size.width, _lastTranslated),
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1,
          );
        }),
      ]).animate(_animationCronController);

      _animationElementsController.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationCronController.dispose();
    _animationElementsController.dispose();
    super.dispose();
  }

  Future<void> _startCron() async {
    _animationElementsController.reverse();
    _animationCronController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_currentSeconds > 0) {
          _currentSeconds = _currentSeconds - 1;
        } else {
          _timer?.cancel();
          _currentSeconds = _defaultSeconds;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_size == Size.zero) {
      _size = MediaQuery.of(context).size;
      _middleY = _size.height / 2 - _animatedTickHeight / 2;
    }

    return Material(
      color: SciensaColors.background,
      child: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) => _leftTicks,
            ),
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) => _rightTicks,
            ),
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) => _startButton,
            ),
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_animationCronController, _animationElementsController]),
              builder: (_, __) => _animatedTick,
            ),
            AnimatedBuilder(
              animation: _animationElementsController,
              builder: (_, __) => _counter,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _ticksList {
    return const [
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
      Tick(),
      SizedBox(width: SciensaSpacing.xs),
    ];
  }

  final _tickListSize = SciensaSpacing.xs * 8 + Tick.tickSize.width * 7;

  Widget get _leftTicks {
    var _extraSize = _tickListSize - _size.width / 2;

    return Positioned(
      left: -((_translateTicksAnimation?.value ?? 0) + _extraSize),
      top: _middleY + Tick.tickSize.height / 2,
      child: SizedBox(
        width: _tickListSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _ticksList,
        ),
      ),
    );
  }

  Widget get _rightTicks {
    var _extraSize = _tickListSize - _size.width / 2;

    return Positioned(
      right: -((_translateTicksAnimation?.value ?? 0) + _extraSize),
      top: _middleY + Tick.tickSize.height / 2,
      child: SizedBox(
        width: _tickListSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _ticksList,
        ),
      ),
    );
  }

  Widget get _animatedTick {
    final translateBgValue =
        (_translateBackgroundAnimation?.value ?? const Size(0, 0));

    final scaleBgValue = _scaleBackgroundAnimation?.value ??
        Size(Tick.tickSize.width, _animatedTickHeight);

    final translatedTickValue =
        _animationCronController.status == AnimationStatus.forward
            ? 0.0
            : _translateAnimatedTick?.value ?? 0;

    return Positioned(
      left: 0,
      top: translatedTickValue,
      child: IgnorePointer(
        child: Transform.translate(
          offset: Offset(
            _size.width / 2 - translateBgValue.width / 2,
            _middleY - translateBgValue.height / 2,
          ),
          child: Container(
            width: scaleBgValue.width,
            height: scaleBgValue.height,
            decoration: BoxDecoration(
              color: SciensaColors.red,
              borderRadius: BorderRadius.circular(SciensaRadius.small),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _startButton {
    return Positioned(
      left: _size.width / 2 - CircleButton.size / 2,
      bottom: _translateButtonAnimation?.value ?? -CircleButton.size,
      child: CircleButton(
        label: 'START',
        onPressed: _startCron,
      ),
    );
  }

  Widget get _counter {
    return Positioned(
      left: 0,
      top: _middleY - (_translateTextAnimation?.value ?? 0),
      child: SizedBox(
        width: _size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_currentSeconds.toString()).title(),
            AnimatedOpacity(
              opacity: _animationElementsController.value == 1 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Text('seconds').subtitle(),
            ),
          ],
        ),
      ),
    );
  }
}
