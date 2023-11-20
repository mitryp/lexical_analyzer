import 'package:lex/base/lexer.dart';

import '../typedefs.dart';

class ParseRule {
  final String pattern;
  final TokenType tokenType;
  final List<String> newStates;
  final RegExpFlags? flags;

  const ParseRule(this.tokenType, this.pattern, {this.newStates = const [], this.flags});

  const ParseRule.include(String ruleName) : this(Token.IncludeOtherParse, ruleName);

  factory ParseRule.byGroups(String pattern, List<TokenType> tokenTypes) = GroupParseRule.new;

  Parse toParse() => Parse(pattern, tokenType, newStates, flags);
}

class GroupParseRule extends ParseRule {
  final List<TokenType> tokenTypes;

  GroupParseRule(String pattern, this.tokenTypes) : super(TokenType.ParseByGroups, pattern);

  @override
  Parse toParse() => GroupParse(pattern, tokenTypes);
}
