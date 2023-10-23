import 'package:lexical_analyzer2/lexical_analyzer.dart';

final lexer = ConfigurableLexer(
  flags: const RegExpFlags(unicode: true, dotAll: true),
  rootRules: const [
    ParseRule(TokenType.String, r"'(\\'|\\\\|[^'])*'"),
    ParseRule(TokenType.String, r'"(\\"|\\\\|[^"])*"'),
    ParseRule(TokenType.Keyword, r'\b(if|else|for|while|return)\b'),
    ParseRule(TokenType.KeywordDeclaration, r'\b(var|final|const)\b'),
    ParseRule(TokenType.Text, r'[^\S\n]+'),
    ParseRule(TokenType.CommentSingle, r'///?.*?\n'),
    ParseRule(TokenType.Operator, r'[+\-*/=><!%~]'),
    ParseRule(TokenType.NumberFloat, r'\d+\.\d*'),
    ParseRule(TokenType.NumberInteger, r'\d+'),
    ParseRule(TokenType.Punctuation, r'[,(){}\[\];.]'),
    ParseRule(TokenType.NameBuiltin, r'\b(sin|cos|abs)\b'),
    ParseRule(TokenType.Name, r'\b([a-zA-Z_]\w*)\b'),
  ],
);

void main() {
  const test = r'''
  // hello
  var a = 1;
  final b = 1.5 == 2;
  const c = abs(1-2); 
  a = "It's a nice day";
  a = 'How\'re u doin\'?';
  
  for (var i = 0; i < 5; i++) {
    if (i % 2 != 0) continue;
    print(i);
  }
  
  var d = помилкова лексема;
  ''';

  final wrapper = LexerWrapper.forLexer(
    lexer: lexer,
    source: test,
  );

  print(test);

  print(wrapper.analyze());
}
