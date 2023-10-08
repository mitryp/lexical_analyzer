import 'package:lex/base/lexer.dart';

import '../typedefs.dart';

const _identifierTokenType = TokenType.Name;

class LexerToken {
  /// A type of this lexer token.
  final TokenType type;

  /// A text of this token.
  final String text;

  /// A position of this token in the source text.
  final int position;

  const LexerToken({
    required this.text,
    required this.type,
    required this.position,
  });

  /// Creates a new [LexerToken] from the given [UnprocessedToken].
  factory LexerToken.fromUnprocessed(UnprocessedToken token) =>
      LexerToken(text: token.match, type: token.token, position: token.pos);

  factory LexerToken.fromIterationData(UnprocessedToken token, Map<String, int> identifiers) =>
      token.token == _identifierTokenType
          ? IdentifierLexerToken.fromUnprocessed(token, identifiers: identifiers)
          : LexerToken.fromUnprocessed(token);

  /// Copies this token with the type of error.
  LexerToken toError() => copyWith(type: TokenType.Error);

  /// Copies this token with the given values of [type], [text], and [position].
  LexerToken copyWith({TokenType? type, String? text, int? position}) => LexerToken(
        text: text ?? this.text,
        type: type ?? this.type,
        position: position ?? this.position,
      );

  @override
  String toString() => 'LexerToken<${type.name}>($position:$_processedText)';

  String get _processedText =>
      text.replaceAll('\n', '\\n').replaceAll('\t', '\\t').replaceAll(RegExp(r' +'), '\\s');
}

class IdentifierLexerToken extends LexerToken {
  final int id;

  const IdentifierLexerToken({required super.text, required super.position, required this.id})
      : super(type: _identifierTokenType);

  factory IdentifierLexerToken.fromUnprocessed(
    UnprocessedToken token, {
    required Map<String, int> identifiers,
  }) {
    assert(token.token == _identifierTokenType);

    final text = token.match;
    final id = identifiers[text] ?? identifiers.length;
    identifiers[text] = id;

    return IdentifierLexerToken(text: text, position: token.pos, id: id);
  }

  @override
  IdentifierLexerToken copyWith({TokenType? type, String? text, int? position, int? id}) =>
      IdentifierLexerToken(
        text: text ?? this.text,
        position: position ?? this.position,
        id: id ?? this.id,
      );

  @override
  String toString() => 'IdentifierLexerToken@$id($position:$_processedText)';
}
