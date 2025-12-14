// Mapeamento limpo para o domínio
class QuoteEntity {
  final String text; // Frase original (Inglês)
  final String author; 
  final String? translatedText; // Tradução (Português)

  const QuoteEntity({
    required this.text, 
    required this.author, 
    this.translatedText
  });

  // Método auxiliar para adicionar a tradução (imutabilidade)
  QuoteEntity copyWith({String? translatedText}) {
    return QuoteEntity(
      text: this.text,
      author: this.author,
      translatedText: translatedText ?? this.translatedText,
    );
  }
}