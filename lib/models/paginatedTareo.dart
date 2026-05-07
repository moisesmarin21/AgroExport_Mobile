import 'package:consorcio_app/models/tareo.dart';

class PaginatedTareo {
  final List<Tareo> items;
  final int totalCount;
  final int pageNumber;
  final int totalPages;

  PaginatedTareo({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.totalPages,
  });
}