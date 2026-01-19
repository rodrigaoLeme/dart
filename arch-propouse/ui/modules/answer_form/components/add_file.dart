import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../../share/files/adra_file_manager.dart';
import '../../../components/action_file_button.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';
import '../../../helpers/extensions/string_extension.dart';

// ignore: must_be_immutable
class AddFile extends StatefulWidget {
  QuestionViewModel? question;
  final void Function(String) onChanged;

  AddFile({
    required this.question,
    required this.onChanged,
    super.key,
  });

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final List<PlatformFile> _uploadedFiles = [];

  Future<void> _handleUpload(BuildContext context) async {
    final file =
        await FileSelectorService.instance.pickFileWithSourcePrompt(context);

    if (file != null) {
      setState(() {
        _uploadedFiles.add(file);
        widget.question = widget.question?.copyWith(
          answer: file.path ?? '',
        );
        widget.onChanged(widget.question?.answer ?? '');
      });
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _uploadedFiles.remove(file);
    });
  }

  @override
  void initState() {
    super.initState();
    final files = widget.question?.answerFile?.trim().isEmpty ?? true
        ? null
        : widget.question?.answerFile?.split(',');
    files?.asMap().forEach((index, path) {
      _uploadedFiles.add(path.fakePlatformFileFromPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 16.0),
          child: AdraText(
            text: (widget.question?.pergunta ?? '') +
                (widget.question?.required == true ? ' *' : ''),
            textSize: AdraTextSizeEnum.callout,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.black,
            adraStyles: AdraStyles.poppins,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: ActionFileButton(
            onTap: () {
              _handleUpload(context);
            },
          ),
        ),
        if (_uploadedFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: _uploadedFiles.map(
                (file) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AdraColors.secondaryFixed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AdraText(
                              text: file.name,
                              textSize: AdraTextSizeEnum.subheadlineW400,
                              textStyleEnum: AdraTextStyleEnum.regular,
                              adraStyles: AdraStyles.poppins,
                              color: AdraColors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _removeFile(file),
                            child: SvgPicture.asset(
                              'lib/ui/assets/images/icon/trash-can-regular.svg',
                              height: 16,
                              width: 16,
                              color: AdraColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
      ],
    );
  }
}
