import 'package:flutter/material.dart';

class SimpleAccountMenu extends StatefulWidget {
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<int> onChange;

  const SimpleAccountMenu({
    this.borderRadius,
    this.backgroundColor = const Color(0xFF67C0B9),
    this.iconColor = Colors.black,
    required this.onChange,
  });

  @override
  _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
}

class _SimpleAccountMenuState extends State<SimpleAccountMenu>
    with SingleTickerProviderStateMixin {
  late GlobalKey _key;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  OverlayEntry? _overlayEntry;
  late BorderRadius _borderRadius;
  late AnimationController _animationController;
  int menuItemsCount =
      5; // Number of menu items (Account Settings, Notifications, etc.)

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust the position if it goes out of screen bounds
    if (buttonPosition.dx + 200 > screenWidth) {
      // 200 is the width of the menu
      buttonPosition = Offset(screenWidth - 200, buttonPosition.dy);
    }

    // If the dropdown would be below the screen, adjust its position upwards
    if (buttonPosition.dy +
            buttonSize.height +
            (menuItemsCount * buttonSize.height) >
        screenHeight) {
      buttonPosition = Offset(
          buttonPosition.dx,
          screenHeight -
              (menuItemsCount * buttonSize.height) -
              buttonSize.height);
    }
  }

  void closeMenu() {
    _overlayEntry?.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: _borderRadius,
      ),
      child: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationController,
        ),
        color: Colors.white,
        onPressed: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height, // Position below the icon
          left: buttonPosition.dx, // Align with the icon's left side
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(
                      width: 17,
                      height: 17,
                      color: widget.backgroundColor,
                      // Ensure the arrow aligns with the icon
                      margin:
                          EdgeInsets.only(left: (buttonSize.width / 2) - 8.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: 200, // Adjust width for labels
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: _borderRadius,
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: widget.iconColor,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuItem(Icons.person, "Account Settings", 0),
                          _buildMenuItem(
                              Icons.notifications, "Notifications", 1),
                          _buildMenuItem(Icons.language, "Change Language", 2),
                          _buildMenuItem(Icons.help_center, "Help Center", 3),
                          _buildMenuItem(Icons.exit_to_app, "Sign Out", 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData iconData, String label, int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        closeMenu();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(iconData, size: 20),
            SizedBox(width: 10),
            Text(label, style: TextStyle(color: widget.iconColor)),
          ],
        ),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(
        size.width / 2, 0); // Align the tip of the triangle to the middle
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
