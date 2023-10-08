import 'dart:collection';

import 'package:lex/base/lexer.dart';

import '../typedefs.dart';
import 'impl/lexer_wrapper_impl.dart';
import 'lexer_token.dart';

abstract class LexerWrapper extends IterableMixin<LexerToken> {
  const LexerWrapper();

  Iterator<LexerToken> call() => iterator;

  factory LexerWrapper.forLexer({
    required String source,
    required Lexer lexer,
    Transformer<String, String> textPreprocessor,
    Predicate<TokenType> tokenFilter,
    TokenProcessor tokenProcessor,
  }) = LexerWrapperImpl.new;
}
