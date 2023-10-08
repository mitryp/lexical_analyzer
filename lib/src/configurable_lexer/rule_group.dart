import 'package:lex/base/token.dart';

import 'parse_rule.dart';

class RuleGroup {
  final String name;
  final List<ParseRule> rules;

  const RuleGroup(this.name, this.rules);

  void registerOn(Map<String, List<Parse>> parses) =>
      parses[name] = rules.map((e) => e.toParse()).toList(growable: false);
}
