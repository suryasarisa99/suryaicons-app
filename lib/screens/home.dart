import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suryaicons_app/utils/debounce.dart';
import 'package:suryaicons_app/utils/search.dart';
import 'package:suryaicons_app/widgets/icon_editor.dart';
import 'package:suryaicons_app/widgets/color_popup_editor.dart';
import 'package:suryaicons_app/widgets/nav_bar.dart';

// icon sets
import 'package:suryaicons/bulk_rounded.dart';
import 'package:suryaicons/duotone_rounded.dart';
import 'package:suryaicons/solid_rounded.dart';
import 'package:suryaicons/solid_sharp.dart';
import 'package:suryaicons/solid_standard.dart';
import 'package:suryaicons/stroke_rounded.dart';
import 'package:suryaicons/stroke_sharp.dart';
import 'package:suryaicons/stroke_standard.dart';
import 'package:suryaicons/suryaicons.dart';
import 'package:suryaicons/twotone_rounded.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const iconSets = [
  SIBulk.all,
  SIDuotone.all,
  SITwotone.all,
  SIStrokeS.all,
  SIStroke.all,
  SIStrokeR.all,
  SISolidS.all,
  SISolid.all,
  SISolidR.all,
];

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  final searchFocusNode = FocusNode();
  Color pickerColor = Color(0xffF13583);
  final searchDebouncer = Debouncer(milliseconds: 180);
  final scrollDebouncer = Debouncer(milliseconds: 150);
  bool searching = false;

  List<int> indexes = [];

  bool _isScrolling = false;

  void _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification ||
        notification is ScrollUpdateNotification) {
      // user is scrolling → mark as scrolling
      if (_isScrolling == false) {
        setState(() => _isScrolling = true);
      }

      scrollDebouncer.run(() {
        setState(() => _isScrolling = false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(handleEvent);
  }

  bool handleEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final hk = HardwareKeyboard.instance;
    final lk = event.logicalKey;
    if ((lk == LogicalKeyboardKey.keyF) && hk.isMetaPressed) {
      searchFocusNode.requestFocus();
      return true;
    }
    return false;
  }

  showIconEditor(int i, j) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      barrierColor: darkTheme
          ? const Color.fromARGB(169, 0, 0, 0)
          : const Color.fromARGB(18, 228, 228, 228),
      context: context,
      builder: (context) {
        return IconEditor(iconIndex: i, variantIndex: j, color: pickerColor);
      },
    );
  }

  handleColorPicker() {
    showColorPicker(context, pickerColor, (color) {
      setState(() {
        pickerColor = color;
      });
    });
  }

  void handleTextChange(String v) {
    if (v.isEmpty) {
      setState(() {
        indexes = [];
        searching = false;
      });
      return;
    }
    if (searching == false) {
      setState(() {
        searching = true;
      });
    }
    searchDebouncer.run(() {
      setState(() {
        debugPrint("debounce run");
        indexes = SearchManager.search(v);
        searching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsLen = controller.text.isEmpty
        ? SIStrokeS.all.length
        : indexes.length;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: NavBar(
        searchController: controller,
        searchFocusNode: searchFocusNode,
        color: pickerColor,
        handleTextChange: handleTextChange,
        showColorPicker: handleColorPicker,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification &&
              notification.dragDetails != null) {
            _onScrollNotification(notification);
          }
          return false;
        },
        child: Center(
          child: SizedBox(
            width: 1250,

            child: searching
                ? Center(
                    child: Text(
                      "Searching...",
                      style: TextStyle(fontSize: 24, color: pickerColor),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1250,
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: kToolbarHeight + 30,
                        ),
                        itemCount: itemsLen,
                        // controller: scrollController,
                        itemBuilder: (context, index) {
                          final iconIndex = controller.text.isEmpty
                              ? index
                              : indexes[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: iconSets.mapIndexed((index, iconSet) {
                              return buildIcon(iconIndex, index);
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildIcon(int iconIndex, int variantIndex) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    final iconData = iconSets[variantIndex][iconIndex];
    if (_isScrolling) {
      return Container(
        width: 96,
        height: 96,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          showIconEditor(iconIndex, variantIndex);
        },
        child: Ink(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            border: Border.all(
              color: darkTheme ? Colors.white24 : Colors.black12,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SuryaIcon(
            opacity: 0.4,
            icon: iconData,
            color: pickerColor,
            size: 38,
          ),
        ),
      ),
    );
  }
}
