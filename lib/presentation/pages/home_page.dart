import 'package:flutter/material.dart';
import 'package:frases_do_dia/data/models/quote_remote_data_source.dart';
import '../../domain/entities/quote_entity.dart';
// Importa o UseCase e o Repositório/DataSource
import '../../domain/usecases/get_translated_quote_usecase.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  QuoteEntity? _quoteAtual;
  bool _isLoading = false;

  // 1. INSTANCIAÇÃO (Dependências)
  // No Clean Architecture, geralmente usamos Injeção de Dependência, mas para
  // simplificar, vamos instanciar aqui.
  late final GetTranslatedQuoteUseCase _getTranslatedQuote;

  @override
  void initState() {
    super.initState();
    // Instancia o repositório e injeta no UseCase
    final repository = QuoteRemoteDataSource();
    _getTranslatedQuote = GetTranslatedQuoteUseCase(repository);
    
    _loadNewQuote(); 
  }

  void _loadNewQuote() async {
    setState(() {
      _isLoading = true;
      _quoteAtual = null;
    });

    try {
      // 2. CHAMA O CASO DE USO (A camada Domain cuida de buscar e traduzir)
      final newQuote = await _getTranslatedQuote.call(); 
      
      setState(() {
        _quoteAtual = newQuote;
        _isLoading = false; 
      });

    } catch (e) {
      print('Erro fatal ao carregar UseCase: $e');
      setState(() {
        _quoteAtual = QuoteEntity(
            text: 'Erro de rede ou API. Tente novamente.', 
            author: 'Sistema',
            translatedText: null,
        );
        _isLoading = false;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    // ... (Seu código UI de build, adaptado para _quoteAtual) ...
    // Note: use _quoteAtual.text, _quoteAtual.author, _quoteAtual.translatedText
    
    String textoOriginal = _quoteAtual?.text ?? 'Pressione o botão para gerar uma frase de Marco Aurélio e outros.';
    String autorExibido = _quoteAtual?.author ?? '';
    String? traducaoExibida = _quoteAtual?.translatedText; // Adaptação para o novo nome

    return Scaffold(
      appBar: AppBar(
        title: const Text("Frases do dia", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 3, color: Colors.amber),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("images/frase_do_dia.jpeg"),
                  
                  const SizedBox(height: 30),
                  
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.green)
                      : Column(
                          children: [
                            Text(
                              textoOriginal, 
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 19, fontStyle: FontStyle.italic, color: Colors.black),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            if (traducaoExibida != null && traducaoExibida.isNotEmpty)
                              Text(
                                traducaoExibida,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                              ),
                              
                            const SizedBox(height: 15),

                            if (_quoteAtual != null && !_isLoading)
                              Text(
                                '- $autorExibido',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                          ],
                        ),
                  
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _loadNewQuote, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      disabledBackgroundColor: Colors.grey, 
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                    ),
                    child: const Text(
                      "Nova Frase",
                      style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}