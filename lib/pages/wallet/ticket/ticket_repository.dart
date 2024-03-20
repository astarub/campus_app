import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'package:campus_app/pages/wallet/ticket/ticket_datasource.dart';

class TicketRepository {
  final TicketDataSource ticketDataSource;

  TicketRepository({
    required this.ticketDataSource,
  });

  Future<void> loadTicket() async {
    Map<String, dynamic>? ticket;

    try {
      ticket = await ticketDataSource.getTicket();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }

    if (ticket['barcode'] == null) {
      return;
    }

    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Save the given pdf file to the apps directory
    final File file = File('$directoryPath/ticket.png');

    await file.writeAsBytes(base64Decode(ticket['barcode']));
  }

  Future<Image> renderQRCode(File ticketFile) async {
    Uint8List resizedData = ticketFile.readAsBytesSync();
    final img.Image image = img.decodeImage(resizedData)!;
    final img.Image resized = img.copyResize(image, width: 250, height: 250);
    resizedData = img.encodePng(resized);

    return Image(
      image: MemoryImage(resizedData),
    );
  }
}
