import 'package:flutter/material.dart';
import 'package:frases_do_dia/data/models/quote_remote_data_source.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/usecases/get_translated_quote_usecase.dart'; 
import 'dart:ui';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  QuoteEntity? _quoteAtual;
  bool _isLoading = false;
  late AnimationController _borderAnimationController;

  late final GetTranslatedQuoteUseCase _getTranslatedQuote;

  @override
  void initState() {
    super.initState();
    final repository = QuoteRemoteDataSource();
    _getTranslatedQuote = GetTranslatedQuoteUseCase(repository);
    
    _borderAnimationController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 4),
    )..repeat();
    
    _loadNewQuote(); 
  }

  void _loadNewQuote() async {
    setState(() {
      _isLoading = true;
      _quoteAtual = null;
    });

    try {
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
  void dispose() {
    _borderAnimationController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    String textoOriginal = _quoteAtual?.text ?? 'Prepare-se para expandir seus horizontes\ncom sabedoria intemporal.';
    String autorExibido = _quoteAtual?.author ?? '';
    String? traducaoExibida = _quoteAtual?.translatedText;
    bool hasQuote = _quoteAtual != null && !_isLoading;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (!_isLoading && details.primaryVelocity != null && details.primaryVelocity!.abs() > 300) {
          _loadNewQuote();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Background Effect - Deep Neutral Navy
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF0A1024), Color(0xFF03050C)], 
                  center: Alignment(-0.5, -0.8),
                  radius: 1.5,
                ),
              ),
            ),
            
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Texto Elegante Substituindo a Imagem
                        Column(
                          children: [
                            Text(
                              "SABEDORIA",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                color: Colors.white.withOpacity(0.95),
                                letterSpacing: 4.0,
                                shadows: [
                                  Shadow(
                                    color: const Color(0xFF7B61FF).withOpacity(0.5),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ATEMPORAL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF00E5FF).withOpacity(0.8),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Animated Border Beam + Painel de Leitura
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // 1. O Card Principal (Glassmorphism)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12), 
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.04), 
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 1.0, 
                                      color: Colors.white.withValues(alpha: 0.1)
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF7B61FF),
                                              strokeWidth: 2,
                                            ),
                                          )
                                        )
                                      : Column(
                                          children: [
                                            Text(
                                              textoOriginal, 
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17, 
                                                fontStyle: FontStyle.italic, 
                                                fontWeight: FontWeight.w500, 
                                                color: Colors.white.withValues(alpha: 0.85), 
                                                height: 1.5,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            
                                            if (traducaoExibida != null && traducaoExibida.isNotEmpty) ...[
                                              const SizedBox(height: 24),
                                              Container(
                                                height: 1,
                                                width: 60,
                                                color: Colors.white.withValues(alpha: 0.15),
                                              ),
                                              const SizedBox(height: 24),
                                              Text(
                                                traducaoExibida,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 20, 
                                                  fontWeight: FontWeight.w400, 
                                                  color: Colors.white,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                              
                                            const SizedBox(height: 30),
                                            
                                            if (autorExibido.isNotEmpty)
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  '— $autorExibido', 
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                    fontSize: 15, 
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400, 
                                                    color: Color(0xFF00E5FF),
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            
                                            if (!hasQuote)
                                              Text(
                                                'Sincronizando mentes brilhantes...',
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.4),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              
                                            if (hasQuote) ...[
                                              const SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.favorite_border),
                                                    color: Colors.white60,
                                                    iconSize: 22,
                                                    onPressed: () {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Frase favoritada com sucesso!')),
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(width: 16),
                                                  IconButton(
                                                    icon: const Icon(Icons.share_outlined),
                                                    color: Colors.white60,
                                                    iconSize: 22,
                                                    onPressed: () {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Preparando compartilhamento...')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ]
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            
                            // 2. Animated Border Beam (ShaderMask) que desenha SÓ na borda
                            Positioned.fill(
                              child: IgnorePointer( // Para não roubar os toques dos botões do card
                                child: AnimatedBuilder(
                                  animation: _borderAnimationController,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (Rect bounds) {
                                        return SweepGradient(
                                          center: Alignment.center,
                                          startAngle: 0.0,
                                          endAngle: 3.14 * 2,
                                          transform: GradientRotation(_borderAnimationController.value * 2 * 3.14),
                                          colors: const [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Color(0x0000E5FF), // Fade da cauda
                                            Color(0xFF00E5FF), // Cabeça (Ciano)
                                            Color(0xFF7B61FF), // Corpo (Roxo)
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 0.5, 0.7, 0.8, 0.9, 0.95, 1.0],
                                        ).createShader(bounds);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent, // Interior totalmente vazado
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            width: 1.5, // Linha brilhante de 1.5px
                                            color: Colors.white, // Pintura que receberá o gradiente da máscara
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),

                        // Botão Futurista Premium
                        GestureDetector(
                          onTap: _isLoading ? null : _loadNewQuote,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), 
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isLoading 
                                    ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
                                    : [const Color(0xFF1E40AF), const Color(0xFF00E5FF)], 
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(40), 
                              boxShadow: _isLoading ? [] : [
                                BoxShadow(
                                  color: const Color(0xFF1E40AF).withOpacity(0.2), 
                                  blurRadius: 15,
                                  spreadRadius: -2,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                if (_isLoading) ...[
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Text(
                                  _isLoading ? "RECUPERANDO DADOS..." : "NOVA FRASE", 
                                  style: const TextStyle(
                                    fontSize: 13, 
                                    color: Colors.white, 
                                    fontWeight: FontWeight.w700, 
                                    letterSpacing: 2.5, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        Text(
                          "Deslize para os lados para nova frase",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}