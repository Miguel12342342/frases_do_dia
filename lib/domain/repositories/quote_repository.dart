import '../entities/quote_entity.dart';

abstract class QuoteRepository {
  Future<QuoteEntity> getQuote();
  Future<String> translateText(String text, String from, String to);
}