import 'dart:convert';
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
    if (await ticketRepository.qrCodeFileExists() == false) return null;

    final File ticketFile = await ticketRepository.getQRCodeFile();

    Uint8List resizedData = ticketFile.readAsBytesSync();
    final img.Image image = img.decodeImage(resizedData)!;
    final img.Image resized = img.copyResize(image, width: 200, height: 200);
    resizedData = img.encodePng(resized);

    return Image(
      image: MemoryImage(resizedData),
    );
  }

  Future<Map<String, dynamic>?> getTicketDetails() async {
    if (await ticketRepository.ticketDetailsFileExists() == false) return null;

    final File ticketDetailsFile = await ticketRepository.getTicketDetailsFile();

    Map<String, dynamic>? ticketDetails;

    try {
      ticketDetails = jsonDecode(await ticketDetailsFile.readAsString());
    } catch (e) {
      return null;
    }

    if (ticketDetails == null || ticketDetails['owner'] == null) {
      return null;
    }

    return ticketDetails;
  }
}
