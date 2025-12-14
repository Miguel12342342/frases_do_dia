import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// O Caso de Uso orquestra as chamadas para o repositório
class GetTranslatedQuoteUseCase {
  final QuoteRepository repository;

  GetTranslatedQuoteUseCase(this.repository);

  Future<QuoteEntity> call() async {
    // 1. Obtém a frase (em inglês)
    final quote = await repository.getQuote();

    // 2. Tenta traduzir imediatamente para PT
    try {
      final translatedText = await repository.translateText(
        quote.text, 
        'en', 
        'pt',
      );
      
      // Retorna a Entity com a tradução anexada
      return quote.copyWith(translatedText: translatedText);
    } catch (e) {
      // Se a tradução falhar, retorna a frase original com a mensagem de erro
      return quote.copyWith(translatedText: 'Erro ao traduzir: ${e.toString()}');
    }
  }
}