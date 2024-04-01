import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_datasource.dart';

class TicketRepository {
  final TicketDataSource ticketDataSource;

  TicketRepository({
    required this.ticketDataSource,
  });

  /// Load the semester ticket
  Future<void> loadTicket() async {
    Map<String, dynamic>? ticket;

    try {
      ticket = await ticketDataSource.getRemoteTicket();
    } catch (e) {
      if (e == 'No login credentials found.') {
        throw MissingCredentialsException();
      } else if (e == 'Invalid credentials.') {
        throw InvalidLoginIDAndPasswordException();
      } else if (e == 'Could not open ticket page.') {
        await deleteTicket();
        throw TicketNotFoundException();
      }
    }
    if (ticket == null || ticket['barcode'].toString().isEmpty) {
      throw TicketNotFoundException();
    }

    await saveTicket(ticket);
  }

  /// Load the qr code file from storage
  Future<File> getQRCodeFile() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image file
    final File qrCodeFile = File('$directoryPath/ticket.png');

    return qrCodeFile;
  }

  /// Load the ticket details file from storage
  Future<File> getTicketDetailsFile() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the ticket details file
    final File ticketDetailsFile = File('$directoryPath/ticket_details.json');

    return ticketDetailsFile;
  }

  /// Checks whether the qr code file exists
  Future<bool> qrCodeFileExists() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image file
    final File qrCodeFile = File('$directoryPath/ticket.png');

    final bool exists = qrCodeFile.existsSync();

    return exists;
  }

  /// Checks whether the ticket details file exists
  Future<bool> ticketDetailsFileExists() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    final File ticketDetailsFile = File('$directoryPath/ticket_details.json');

    final bool exists = ticketDetailsFile.existsSync();

    return exists;
  }

  /// Save both the QR code and it's details to storage
  Future<void> saveTicket(Map<String, dynamic> ticket) async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Save the given png file to the app directory
    final File qrCodeFile = File('$directoryPath/ticket.png');
    final File ticketDetailsFile = File('$directoryPath/ticket_details.json');

    await qrCodeFile.writeAsBytes(base64Decode(ticket['barcode']));
    await ticketDetailsFile.writeAsString(jsonEncode(ticket));
  }

  /// Delete the ticket files
  Future<void> deleteTicket() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image file
    final File qrCodeFile = File('$directoryPath/ticket.png');
    final File ticketDetailsFile = File('$directoryPath/ticket_details.json');

    if (await qrCodeFileExists()) {
      await qrCodeFile.delete();
    }

    if (await ticketDetailsFileExists()) {
      await ticketDetailsFile.delete();
    }
  }
}
