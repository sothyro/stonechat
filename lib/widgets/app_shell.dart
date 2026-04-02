import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'app_header.dart';
import 'app_footer.dart';
import 'app_drawer.dart';
import 'sticky_cta_bar.dart';

/// Wraps each route with persistent header and footer.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

/// Scroll offsets for header visibility (hysteresis avoids oscillation when resize
/// changes scroll extent / maxScroll and the offset sits near a single threshold).
const double _menuShowScrollBelow = 360;
const double _menuHideScrollAbove = 440;

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showBackToTop = false;
  bool _menuVisible = true;
  bool _scrollStateUpdateScheduled = false;
  /// Hysteresis so sticky CTA is not inserted/removed every frame when width jitters at 768.
  bool? _wideChromeSticky;
  /// After window metrics change (web resize), skip hit-testing overlays for a few frames so
  /// pointer routing does not walk header/CTA subtrees while layout is still settling.
  bool _overlayPointersSafe = true;
  int _overlayPointerResumeGeneration = 0;
  double? _lastViewWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _suspendOverlayPointers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final w = MediaQuery.sizeOf(context).width;
    if (_lastViewWidth != null && (_lastViewWidth! - w).abs() > 0.5) {
      _suspendOverlayPointers();
    }
    _lastViewWidth = w;
  }

  void _suspendOverlayPointers() {
    _overlayPointerResumeGeneration++;
    final gen = _overlayPointerResumeGeneration;
    if (_overlayPointersSafe) {
      setState(() => _overlayPointersSafe = false);
    }
    void resume() {
      if (!mounted || gen != _overlayPointerResumeGeneration) return;
      setState(() => _overlayPointersSafe = true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => resume());
      });
    });
  }

  /// Wide layout (desktop chrome + sticky CTA): same hysteresis as admin hub.
  bool _wideChromeForWidth(double width) {
    const low = Breakpoints.mobile - 16;
    const high = Breakpoints.mobile + 16;
    if (width < low) return false;
    if (width >= high) return true;
    return _wideChromeSticky ?? !Breakpoints.isMobile(width);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
        setState(() {
          _menuVisible = true;
          _showBackToTop = false;
        });
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    bool menuVisible;
    bool showBackToTop;
    if (offset <= _menuShowScrollBelow) {
      menuVisible = true;
      showBackToTop = false;
    } else if (offset >= _menuHideScrollAbove) {
      menuVisible = false;
      showBackToTop = true;
    } else {
      menuVisible = _menuVisible;
      showBackToTop = _showBackToTop;
    }
    if (showBackToTop == _showBackToTop && menuVisible == _menuVisible) return;

    // Scroll notifications can be delivered during pointer/mouse device updates on desktop/web.
    // Deferring avoids re-entrant rebuilds that trip mouse tracker assertions in debug mode.
    if (_scrollStateUpdateScheduled) return;
    _scrollStateUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollStateUpdateScheduled = false;
      if (!mounted) return;
      if (showBackToTop == _showBackToTop && menuVisible == _menuVisible) return;
      setState(() {
        _showBackToTop = showBackToTop;
        _menuVisible = menuVisible;
      });
    });
  }

  void _scrollToContent() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final useWideChrome = _wideChromeForWidth(width);
    _wideChromeSticky = useWideChrome;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final fabBottomPadding = (useWideChrome ? 60.0 : 24.0) + bottomSafe;
    // New key per route so dismiss on one screen does not hide Hub/Subscribe elsewhere.
    final stickyCtaKey = ValueKey<String>(
      'sticky_cta_${GoRouterState.of(context).matchedLocation}',
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: const AppDrawer(),
      floatingActionButton: _showBackToTop
          ? Padding(
              padding: EdgeInsets.only(bottom: fabBottomPadding),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppShadows.stickyCta,
                ),
                child: FloatingActionButton.small(
                  onPressed: _scrollToContent,
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  elevation: 0,
                  highlightElevation: 0,
                  tooltip: AppLocalizations.of(context)!.backToTop,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            )
          : null,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            container: true,
            label: l10n.semanticsMainContent,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.child,
                  Semantics(
                    container: true,
                    label: l10n.semanticsFooter,
                    child: const AppFooter(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: IgnorePointer(
              ignoring: !_overlayPointersSafe || !_menuVisible,
              child: AnimatedSlide(
                offset: _menuVisible ? Offset.zero : const Offset(0, -1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: _menuVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: AppHeader(
                        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Sticky CTA bar: hidden on mobile to avoid overlapping content and improve UX
          if (useWideChrome)
            Positioned(
              right: 0,
              top: 160,
              bottom: 100,
              child: IgnorePointer(
                ignoring: !_overlayPointersSafe,
                child: SafeArea(
                  left: false,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: StickyCtaBar(key: stickyCtaKey),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
