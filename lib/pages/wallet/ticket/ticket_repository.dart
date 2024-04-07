import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_datasource.dart';

class TicketRepository {
  final TicketDataSource ticketDataSource;
  final FlutterSecureStorage secureStorage;

  TicketRepository({
    required this.ticketDataSource,
    required this.secureStorage,
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
      } else if (e == 'Ticket removed.') {
        await deleteTicket();
        throw TicketNotFoundException();
      } else if (e == 'Could not open ticket page.') {
        throw TicketNotFoundException();
      }
    }
    if (ticket == null || ticket['aztec_code'].toString().isEmpty) {
      throw TicketNotFoundException();
    }

    await saveTicket(ticket);
  }

  /// Loads the Aztec code from secure storage
  Future<String?> getAztecCode() async {
    final String? aztecCode = await secureStorage.read(key: 'ticket_aztec_code');

    return aztecCode;
  }

  /// Loads the ticket details from secure storage
  Future<String?> getTicketDetails() async {
    final String? ticketDetails = await secureStorage.read(key: 'ticket_details');

    return ticketDetails;
  }

  /// Save both the Aztec code and it's details to storage
  Future<void> saveTicket(Map<String, dynamic> ticket) async {
    await secureStorage.write(key: 'ticket_aztec_code', value: ticket['aztec_code']);
    await secureStorage.write(key: 'ticket_details', value: jsonEncode(ticket));
  }

  /// Delete the stored ticket
  Future<void> deleteTicket() async {
    await secureStorage.delete(key: 'ticket_aztec_code');
    await secureStorage.delete(key: 'ticket_details');
  }
}
