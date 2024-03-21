import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';

class TicketUsecases {
  final TicketRepository ticketRepository;

  TicketUsecases({
    required this.ticketRepository,
  });

  Future<Image?> renderQRCode() async {
    try {
      await ticketRepository.loadTicket();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    if (await ticketRepository.ticketFileExists() == false) return null;

    final File ticketFile = await ticketRepository.getTicketFile();

    Uint8List resizedData = ticketFile.readAsBytesSync();
    final img.Image image = img.decodeImage(resizedData)!;
    final img.Image resized = img.copyResize(image, width: 250, height: 250);
    resizedData = img.encodePng(resized);

    return Image(
      image: MemoryImage(resizedData),
    );
  }
}
