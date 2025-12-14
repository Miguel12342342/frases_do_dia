import '../../domain/entities/quote_entity.dart';

// Modelo usado para mapear a resposta da API Stoic
class QuoteModel extends QuoteEntity {

  QuoteModel({required super.text, required super.author, super.translatedText}); 

  // Mapeia o objeto JSON da API Stoic para a nossa Entity
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: (json['quote'] ?? "Frase indisponível.").toString(), 
      author: (json['author'] ?? "Autor desconhecido").toString(), 
    );
  }
}