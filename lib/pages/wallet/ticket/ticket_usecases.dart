import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';

class TicketUsecases {
  final TicketRepository ticketRepository;

  TicketUsecases({
    required this.ticketRepository,
  });

  /// Render the Aztec code and resize it
  Future<Image?> renderAztecCode() async {
    final String? aztecCode = await ticketRepository.getAztecCode();

    if (aztecCode == null) return null;

    Uint8List resizedData = base64Decode(aztecCode);
    final img.Image image = img.decodeImage(resizedData)!;
    final img.Image resized = img.copyResize(image, width: 200, height: 200);
    resizedData = img.encodePng(resized);

    return Image(
      image: MemoryImage(resizedData),
    );
  }

  /// Parse the content of the ticket details file
  Future<Map<String, dynamic>?> getTicketDetails() async {
    final String? ticketDetailsEncoded = await ticketRepository.getTicketDetails();

    if (ticketDetailsEncoded == null) return null;

    Map<String, dynamic>? ticketDetails;

    try {
      ticketDetails = jsonDecode(ticketDetailsEncoded);
    } catch (e) {
      return null;
    }

    if (ticketDetails == null || ticketDetails['owner'] == null) {
      return null;
    }

    return ticketDetails;
  }
}
