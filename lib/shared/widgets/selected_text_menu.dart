import 'package:bibleplan/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SelectedTextMenu extends CupertinoTextSelectionControls{
  final void Function(Color?)? colorSelected;
  final void Function()? onNote;
  final void Function()? onShare;

  SelectedTextMenu({this.colorSelected, this.onNote, this.onShare});

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    return _TextSelectionControlsToolbar(
      globalEditableRegion: globalEditableRegion,
      textLineHeight: textLineHeight,
      selectionMidpoint: selectionMidpoint,
      endpoints: endpoints,
      clipboardStatus: clipboardStatus,
      delegate: delegate,
      handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
      handleCopy: canCopy(delegate) ? () => handleCopy(delegate) : null,
      handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
      handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
      colorSelected: colorSelected,
      onNote: onNote,
      onShare: onShare,
    );
  }
}

const double _kHandleSize = 22.0;

// Padding between the toolbar and the anchor.
const double _kToolbarContentDistanceBelow = _kHandleSize - 2.0;
const double _kToolbarContentDistance = 16.0;

// The label and callback for the available default text selection menu buttons.
class _TextSelectionToolbarItemData {
  const _TextSelectionToolbarItemData({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

// The highest level toolbar widget, built directly by buildToolbar.
class _TextSelectionControlsToolbar extends StatefulWidget {
  final void Function(Color?)? colorSelected;
  final void Function()? onNote;
  final void Function()? onShare;

  const _TextSelectionControlsToolbar({
    Key? key,
    required this.clipboardStatus,
    required this.delegate,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.handleCut,
    required this.handleCopy,
    required this.handlePaste,
    required this.handleSelectAll,
    required this.selectionMidpoint,
    required this.textLineHeight,
    this.colorSelected,
    this.onNote,
    this.onShare,
  }) : super(key: key);

  final ValueListenable<ClipboardStatus>? clipboardStatus;
  final TextSelectionDelegate delegate;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final VoidCallback? handleCut;
  final VoidCallback? handleCopy;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;
  final Offset selectionMidpoint;
  final double textLineHeight;

  @override
  _TextSelectionControlsToolbarState createState() =>
      _TextSelectionControlsToolbarState();
}

class _Anchors {
  final Offset anchorAbove;
  final Offset anchorBelow;

  _Anchors({required this.anchorAbove, required this.anchorBelow});
}

class _TextSelectionControlsToolbarState
    extends State<_TextSelectionControlsToolbar> with TickerProviderStateMixin {
  bool showColorOptions = false;

  _Anchors getAnchors() {
    final TextSelectionPoint startTextSelectionPoint = widget.endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        widget.endpoints.length > 1 ? widget.endpoints[1] : widget.endpoints[0];
    final Offset anchorAbove = Offset(
      widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
      widget.globalEditableRegion.top +
          startTextSelectionPoint.point.dy -
          widget.textLineHeight -
          _kToolbarContentDistance,
    );
    final Offset anchorBelow = Offset(
      widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
      widget.globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );
    return _Anchors(anchorAbove: anchorAbove, anchorBelow: anchorBelow);
  }

  List<_TextSelectionToolbarItemData> getToolbarItens() {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return <_TextSelectionToolbarItemData>[
      if (widget.handleCut != null)
        _TextSelectionToolbarItemData(
          label: localizations.cutButtonLabel,
          onPressed: widget.handleCut!,
        ),
      if (widget.handleCopy != null)
        _TextSelectionToolbarItemData(
          label: localizations.copyButtonLabel,
          onPressed: widget.handleCopy!,
        ),
      if (widget.handlePaste != null &&
          widget.clipboardStatus!.value == ClipboardStatus.pasteable)
        _TextSelectionToolbarItemData(
          label: localizations.pasteButtonLabel,
          onPressed: widget.handlePaste!,
        ),
      if (widget.handleSelectAll != null)
        _TextSelectionToolbarItemData(
          label: localizations.selectAllButtonLabel,
          onPressed: widget.handleSelectAll!,
        ),
    ];
  }

  List<Widget> getColorOptions() {
    return AppStyle.highlightColors
        .map(
          (e) => TextSelectionToolbarTextButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.circle, color: e, size: 36),
            onPressed: () {
              widget.delegate.hideToolbar();
              widget.colorSelected?.call(e);
            },
          ),
        )
        .toList()
      ..add(
        TextSelectionToolbarTextButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.cancel_outlined, color: Colors.red, size: 36),
          onPressed: () {
            widget.delegate.hideToolbar();
            widget.colorSelected?.call(null);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var _anchors = getAnchors();

    List<Widget> itens = [];
    if (!showColorOptions) {
      var itemDatas = getToolbarItens();
      itens = itemDatas
          .asMap()
          .entries
          .map((MapEntry<int, _TextSelectionToolbarItemData> entry) {
        return TextSelectionToolbarTextButton(
          padding: TextSelectionToolbarTextButton.getPadding(
              entry.key, itemDatas.length),
          onPressed: entry.value.onPressed,
          child: Txt.b(entry.value.label, color: AppStyle.primaryColor),
        );
      }).toList();

      itens.insert(
        0,
        TextSelectionToolbarTextButton(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/highlight.png"),
          ),
          onPressed: () {
            setState(() {
              showColorOptions = true;
            });
          },
        ),
      );

      itens.insert(
        1,
        TextSelectionToolbarTextButton(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit, color: AppStyle.primaryColor),
          ),
          onPressed: () {
            setState(() {
              widget.onNote?.call();
            });
          },
        ),
      );

      itens.insert(
        2,
        TextSelectionToolbarTextButton(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.share, color: AppStyle.primaryColor),
          ),
          onPressed: () {
            setState(() {
              widget.onShare?.call();
            });
          },
        ),
      );
    } else {
      itens = getColorOptions();
      itens.insert(
          0,
          TextSelectionToolbarTextButton(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.arrow_back_ios_new,
                size: 25, color: AppStyle.primaryColor),
            onPressed: () {
              setState(() {
                showColorOptions = false;
              });
            },
          ));
    }

    if (itens.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return TextSelectionToolbar(
      toolbarBuilder: (context, child) =>
          _TextSelectionToolbarContainer(child: child),
      anchorAbove: _anchors.anchorAbove,
      anchorBelow: _anchors.anchorBelow,
      children: itens,
    );
  }
}

class _TextSelectionToolbarContainer extends StatelessWidget {
  const _TextSelectionToolbarContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 3.0,
      color: Colors.white,
      type: MaterialType.card,
      child: child,
    );
  }
}
