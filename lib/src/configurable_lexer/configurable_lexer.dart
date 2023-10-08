import 'package:lex/base/lexer.dart';

import 'parse_rule.dart';
import 'rule_group.dart';

class ConfigurableLexer extends RegexLexer {
  @override
  final String? name;

  @override
  final RegExpFlags flags;

  @override
  final Map<String, List<Parse>> parses;

  const ConfigurableLexer._({
    required this.flags,
    required this.parses,
    this.name,
  });

  factory ConfigurableLexer({
    required List<ParseRule> rootRules,
    RegExpFlags flags = const RegExpFlags(dotAll: true, multiline: true),
    List<RuleGroup> groups = const [],
    String? name,
  }) {
    final parses = <String, List<Parse>>{};

    for (final group in [RuleGroup('root', rootRules), ...groups]) {
      group.registerOn(parses);
    }

    return ConfigurableLexer._(flags: flags, parses: parses, name: name);
  }
}
