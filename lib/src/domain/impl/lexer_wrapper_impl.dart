import 'package:lex/base/lexer.dart';

import '../../typedefs.dart';
import '../lexer_token.dart';
import '../lexer_wrapper.dart';

class LexerWrapperImpl extends LexerWrapper {
  static String _defaultPreprocessor(String text) => text;

  static bool _defaultTokenFilter(TokenType tokenType) => tokenType != TokenType.Text;

  final String _source;
  final Lexer _lexer;
  final Transformer<String, String> _textPreprocessor;
  final Predicate<TokenType> _tokenFilter;
  final TokenProcessor _tokenProcessor;

  const LexerWrapperImpl({
    required String source,
    required Lexer lexer,
    Transformer<String, String> textPreprocessor = _defaultPreprocessor,
    Predicate<TokenType> tokenFilter = _defaultTokenFilter,
    TokenProcessor tokenProcessor = LexerToken.fromIterationData,
  })  : _source = source,
        _lexer = lexer,
        _textPreprocessor = textPreprocessor,
        _tokenFilter = tokenFilter,
        _tokenProcessor = tokenProcessor;

  @override
  Iterator<LexerToken> get iterator => _LexerTokenIterator(
        _lexer.getTokensUnprocessed(_textPreprocessor(_source)),
        _tokenFilter,
        _tokenProcessor,
      );

  @override
  ({List<LexerToken> tokens, Map<String, int> identifiers}) analyze() {
    final identifiers = <String, int>{};
    final tokens = <LexerToken>[];

    final iterator = _LexerTokenIterator(
      _lexer.getTokensUnprocessed(_textPreprocessor(_source)),
      _tokenFilter,
      _tokenProcessor,
      identifiers: identifiers,
    );

    while (iterator.moveNext()) {
      tokens.add(iterator.current);
    }

    return (tokens: tokens, identifiers: identifiers);
  }
}

class _LexerTokenIterator implements Iterator<LexerToken> {
  final List<UnprocessedToken> _tokens;
  final Predicate<TokenType> _filter;
  final TokenProcessor _processor;
  int _pos = -1;

  final Map<String, int> _identifiers;

  LexerToken? _cache;
  int _cachePos = -1;

  _LexerTokenIterator(
    Iterable<UnprocessedToken> tokens,
    this._filter,
    this._processor, {
    Map<String, int>? identifiers,
  })  : _tokens = tokens.toList(growable: false),
        _identifiers = identifiers ?? {};

  int get _length => _tokens.length;

  @override
  bool moveNext() {
    if (_pos + 1 >= _length) return false;

    final token = _tokens[++_pos];
    if (_filter(token.token)) return true;
    return moveNext();
  }

  @override
  LexerToken get current {
    if (_pos < 0 || _pos >= _length) throw StateError('Iteration has not been started yet');

    final cache = _cache;

    if (_cachePos == _pos && cache != null) return cache;

    final token = _processor(_tokens[_pos], _identifiers);
    _cache = token;
    _cachePos = _pos;

    return token;
  }
}
