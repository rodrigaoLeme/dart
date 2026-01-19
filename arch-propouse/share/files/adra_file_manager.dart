import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum FilePickType {
  images,
  documents,
  all,
}

class FileSelectorService {
  static final FileSelectorService _instance = FileSelectorService._internal();

  FileSelectorService._internal();

  static FileSelectorService get instance => _instance;

  final ImagePicker _imagePicker = ImagePicker();

  Future<PlatformFile?> pickFileWithSourcePrompt(BuildContext context) async {
    final FilePickType? selectedType =
        await _showFileSourceBottomSheet(context);
    if (selectedType != null) {
      return pickSingleFile(type: selectedType);
    }
    return null;
  }

  Future<PlatformFile?> pickSingleFile(
      {FilePickType type = FilePickType.all}) async {
    try {
      if (type == FilePickType.images) {
        final picked =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          final file = File(picked.path);
          return PlatformFile(
            name: picked.name,
            path: picked.path,
            size: await file.length(),
            bytes: await file.readAsBytes(),
          );
        }
        return null;
      }

      final result = await FilePicker.platform.pickFiles(
        type: _getFileType(type),
        allowedExtensions: _getAllowedExtensions(type),
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first;
      }
    } catch (e) {
      print('Erro ao selecionar arquivo: $e');
    }
    return null;
  }

  Future<List<PlatformFile>> pickMultipleFiles(
      {FilePickType type = FilePickType.all}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: _getFileType(type),
        allowedExtensions: _getAllowedExtensions(type),
      );

      if (result != null) {
        return result.files;
      }
    } catch (e) {
      print('Erro ao selecionar arquivos: $e');
    }
    return [];
  }

  FileType _getFileType(FilePickType type) {
    switch (type) {
      case FilePickType.images:
      case FilePickType.documents:
        return FileType.custom;
      case FilePickType.all:
        return FileType.any;
    }
  }

  List<String>? _getAllowedExtensions(FilePickType type) {
    switch (type) {
      case FilePickType.images:
        return ['jpg', 'jpeg', 'png'];
      case FilePickType.documents:
        return ['pdf', 'doc', 'docx', 'txt'];
      case FilePickType.all:
        return null;
    }
  }

  Future<FilePickType?> _showFileSourceBottomSheet(BuildContext context) {
    return showModalBottomSheet<FilePickType>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Selecionar imagem da galeria'),
                onTap: () => Navigator.pop(context, FilePickType.images),
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Selecionar arquivo'),
                onTap: () => Navigator.pop(context, FilePickType.documents),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancelar'),
                onTap: () => Navigator.pop(context, null),
              ),
            ],
          ),
        );
      },
    );
  }
}
