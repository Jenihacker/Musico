import 'dart:convert';

Suggestion suggestionFromJson(String str) => Suggestion.fromJson(json.decode(str));

String suggestionToJson(Suggestion data) => json.encode(data.toJson());

class Suggestion {
    List<String> suggestions;

    Suggestion({
        required this.suggestions,
    });

    factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        suggestions: List<String>.from(json["suggestions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "suggestions": List<dynamic>.from(suggestions.map((x) => x)),
    };
}
