import 'package:lex/base/lexer.dart';

import '../lexical_analyzer.dart';

/// A function that transforms the given value of type [T] into a value of type [R].
typedef Transformer<T, R> = R Function(T t);

/// A function that performs a check on a value of type [T].
typedef Predicate<T> = Transformer<T, bool>;

/// An alias for [Token] from `lex`.
typedef TokenType = Token;

/// A function used to transform a token. If the token is an identifier, it must assign an id to the
/// token and return a respective type.
typedef TokenProcessor = LexerToken Function(UnprocessedToken token, Map<String, int> identifiers);
