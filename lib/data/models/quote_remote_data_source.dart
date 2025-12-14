import 'dart:convert';
import 'package:frases_do_dia/data/models/quote_moldels.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';

// Constantes de URL
const _urlProxy = 'https://api.codetabs.com/v1/proxy?quest=';
const _urlStoic = 'https://stoic.tekloon.net/stoic-quote';
const _urlTraducaoBase = 'https://api.mymemory.translated.net/get?';

// Implementação do Contrato (QuoteRepository)
class QuoteRemoteDataSource implements QuoteRepository {

  @override
  Future<QuoteEntity> getQuote() async {
    final response = await http.get(
      Uri.parse('${_urlProxy}${_urlStoic}') 
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> corpoCompleto = jsonDecode(response.body);
      final Map<String, dynamic> dadosDaFrase = corpoCompleto['data'] as Map<String, dynamic>;
      
      // Converte o Modelo (Map da API) para a Entity (Modelo de Domínio)
      return QuoteModel.fromJson(dadosDaFrase);
    } else {
      throw Exception('Falha ao carregar a frase da API. Status: ${response.statusCode}');
    }
  }

  @override
  Future<String> translateText(String text, String from, String to) async {
    final textoCodificado = Uri.encodeComponent(text); 
    final urlCompleta = '${_urlTraducaoBase}q=$textoCodificado&langpair=$from|$to';
    
    final response = await http.get(Uri.parse(urlCompleta));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String traducao = data['responseData']['translatedText'];
      
      if (traducao.toLowerCase().contains('ratelimit')) {
        throw Exception("Limite de requisições de tradução atingido.");
      }
      return traducao;
    } else {
      throw Exception('Falha ao traduzir. Status: ${response.statusCode}');
    }
  }
}