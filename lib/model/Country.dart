import 'dart:convert' show jsonDecode;

class Country {
  String name;

  String flagUri;

  String code;

  Country({this.name, this.code, this.flagUri});

  Country.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        code = json['e164_cc'],
        flagUri = json['iso2_cc'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'e164_cc': code,
        'iso2_cc': flagUri,
      };

  @override
  String toString() {
    return 'Country{name: $name, flagUri: $flagUri, code: $code}';
  }
}
