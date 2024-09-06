import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_reader/pages/download/dummy_utills.dart';
import 'package:pdf_reader/providers/pdf_provider.dart';

class DocumentSaveScreen extends StatefulWidget {
  final DirType dirType;

  const DocumentSaveScreen({super.key, required this.dirType});

  @override
  State<DocumentSaveScreen> createState() => _DocumentSaveScreenState();
}

class _DocumentSaveScreenState extends State<DocumentSaveScreen> {
  bool _isSavingTaskOngoing = false;
  bool _docAvailable = false;
  bool _isExists = false;
  String _fileUri = "";

  String fileName = "dart_flutter.pdf";

  File getFile({
    String? relativePath,
    required String fileName,
    required DirType dirType,
    required DirName dirName,
  }) {
    return File(
      "${dirType.fullPath(relativePath: relativePath.orAppFolder, dirName: dirName)}/$fileName",
    );
  }

  @override
  void initState() {
    super.initState();
    checkIfExist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Folder Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Document can be appear here after saving"),
              ElevatedButton(
                onPressed: () async {
                  final Uri? uri = await mediaStorePlugin.getFileUri(
                      fileName: fileName,
                      dirType: widget.dirType,
                      dirName: widget.dirType.defaults);
                  if (uri != null) {
                    setState(() {
                      _fileUri = uri.path;
                    });
                  }
                },
                child: const Text("Get File Uri"),
              ),
              if (_fileUri.isNotEmpty)
                Text.rich(
                  TextSpan(text: 'File Uri: ', children: [
                    TextSpan(
                        text: _fileUri,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ]),
                ),
              if (!_isSavingTaskOngoing)
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSavingTaskOngoing = true;
                    });

                    Directory directory =
                        await getApplicationSupportDirectory();
                    File tempFile = File("${directory.path}/$fileName");
                    await (await rootBundle.load("assets/dart_flutter.pdf"))
                        .writeToFile(tempFile);
                    final SaveInfo? saveInfo = await mediaStorePlugin.saveFile(
                      tempFilePath: tempFile.path,
                      dirType: widget.dirType,
                      dirName: widget.dirType.defaults,
                    );
                    print(saveInfo);
                    setState(() {
                      _isSavingTaskOngoing = false;
                      _docAvailable = saveInfo?.uri != null;
                    });
                  },
                  child: const Text("Save Audio"),
                ),
              if (_isSavingTaskOngoing)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              if (_docAvailable)
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _docAvailable = false;
                      });

                      final bool status = await mediaStorePlugin.deleteFile(
                          fileName: fileName,
                          dirType: widget.dirType,
                          dirName: widget.dirType.defaults);
                      print("Delete Status: $status");

                      if (status) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('File Deleted!'),
                        ));
                      }
                    },
                    child: const Text("Delete")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkIfExist() async {
    print("checkIfExist");

    // Using direct path
    // File file = getFile(
    //     fileName: fileName,
    //     dirType: widget.dirType,
    //     dirName: widget.dirType.defaults);
    //
    // if ((await file.exists())) {
    //   setState(() {
    //     _audioAvailable = true;
    //   });
    // }

    // Using uri

    final Uri? uri = await mediaStorePlugin.getFileUri(
        fileName: fileName,
        dirType: widget.dirType,
        dirName: widget.dirType.defaults);

    if (uri != null) {
      File tempFile =
          File("${(await getApplicationSupportDirectory()).path}/$fileName");
      // read using uri
      bool status = await mediaStorePlugin.readFile(
          fileName: fileName,
          tempFilePath: tempFile.path,
          dirType: widget.dirType,
          dirName: widget.dirType.defaults);

      if (status) {
        setState(() {
          _docAvailable = true;
        });
      }
    }
  }
}
