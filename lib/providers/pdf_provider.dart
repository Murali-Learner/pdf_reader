import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pocket_pdf/models/pdf_model.dart';
import 'package:pocket_pdf/utils/constants.dart';
import 'package:pocket_pdf/utils/toast_utils.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class PdfProvider with ChangeNotifier {
  PdfViewerController? _pdfController;

  PdfModel? _currentPDF;
  bool _isLoading = false;
  List<SharedMediaFile> sharedFiles = [];
  late StreamSubscription _intentSub;
  int _pdfCurrentPage = 0;

  PdfViewerController? get pdfController => _pdfController;
  PdfModel? get currentPDF => _currentPDF;
  bool get isLoading => _isLoading;
  int get pdfCurrentPage => _pdfCurrentPage;

  void incrementPage() {
    _pdfCurrentPage++;
    notifyListeners();
    pdfController!.goToPage(pageNumber: pdfCurrentPage);
  }

  void gotoFirstPage() {
    _pdfCurrentPage = 0;
    notifyListeners();
    pdfController!.goToPage(pageNumber: pdfCurrentPage);
  }

  void gotoLastPage() {
    _pdfCurrentPage = pdfController!.pageCount;
    notifyListeners();
    pdfController!.goToPage(pageNumber: pdfController!.pageCount);
  }

  void zoomUp() {
    pdfController!.zoomUp();
  }

  void zoomDown() {
    pdfController!.zoomDown();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCurrentPDF(PdfModel? pdf) {
    _currentPDF = null;

    _currentPDF = pdf;
    notifyListeners();
  }

  Future<void> init() async {
    await Future.delayed(Duration.zero).whenComplete(() {
      setIsLoading(true);
      _pdfController = PdfViewerController();
      setIsLoading(false);
    });
  }

  void setZoomControl(PdfViewerController controller) {
    if (currentPDF != null) {
      log("message");
      controller.addListener(() async {
        if (controller.currentZoom == 0.2) {
          await controller.setZoom(
            controller.centerPosition,
            0.2,
          );
        }
      });
    }
  }

  void handlePDF() {
    if (_pdfController != null && _currentPDF != null) {
      if (_pdfController!.isReady) {
        _pdfController!.goToPage(
          pageNumber: currentPDF!.pageNumber,
          duration: Constants.globalDuration,
        );
      } else {
        log("PDF Controller is not ready yet.");
      }
    }
  }

  Future<void> handleIntent() async {
    try {
      setIsLoading(true);

      _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
        (files) {
          _processSharedFiles(files);
        },
        onError: (err) {
          log("Error in media stream: $err");
          setIsLoading(false);
        },
      );

      final initialMedia =
          await ReceiveSharingIntent.instance.getInitialMedia();
      _processSharedFiles(initialMedia);

      setIsLoading(false);
    } catch (e) {
      log("Error handling intent: $e");
      setIsLoading(false);
    }
  }

  void _processSharedFiles(List<SharedMediaFile> files) {
    if (files.isNotEmpty) {
      sharedFiles = files;
      final file = File(sharedFiles[0].path);
      final pdf = PdfModel(
        id: DateTime.now().microsecondsSinceEpoch,
        filePath: file.path,
        pageNumber: 0,
        lastSeen: DateTime.now(),
      );
      setCurrentPDF(pdf);
      handlePDF();
    }
  }

  void disposeIntentListener() {
    _intentSub.cancel();
  }

  Future<void> pickFile() async {
    setIsLoading(true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final pdf = PdfModel(
        id: DateTime.now().microsecondsSinceEpoch,
        filePath: file.path,
        pageNumber: 0,
        lastSeen: DateTime.now(),
      );
      setCurrentPDF(pdf);
      handlePDF();
      setIsLoading(false);
    } else {
      ToastUtils.showErrorToast("No file selected");
      setIsLoading(false);
    }
  }
}
