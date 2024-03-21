import 'dart:convert';
import 'dart:io';

import 'package:campus_app/core/exceptions.dart';
import 'package:path_provider/path_provider.dart';

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
      if (e == 'No login credentials found.') {
        throw MissingCredentialsException();
      } else if (e == 'Invalid credentials.') {
        throw InvalidLoginIDAndPasswordException();
      } else if (e == 'Could not open ticket page.') {
        await deleteTicketQRCode();
        throw TicketNotFoundException();
      }
    }
    if (ticket == null) {
      throw TicketNotFoundException();
    }

    await saveTicketQRCode(ticket['barcode']);
  }

  Future<void> saveTicketQRCode(String code) async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Save the given png file to the app directory
    final File file = File('$directoryPath/ticket.png');

    await file.writeAsBytes(base64Decode(code));
  }

  Future<void> deleteTicketQRCode() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image file
    final File ticketFile = File('$directoryPath/ticket.png');

    if (await ticketFileExists()) {
      ticketFile.deleteSync();
    }
  }

  Future<File> getTicketFile() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image files
    final File ticketFile = File('$directoryPath/ticket.png');

    return ticketFile;
  }

  Future<bool> ticketFileExists() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image file
    final File ticketFile = File('$directoryPath/ticket.png');

    // If the images were parsed and saved in the past, they're loaded
    final bool ticketSaved = ticketFile.existsSync();

    return ticketSaved;
  }
}
