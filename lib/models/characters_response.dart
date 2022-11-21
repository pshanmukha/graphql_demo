// To parse this JSON data, do
//
//     final charactersResponse = charactersResponseFromJson(jsonString);

import 'dart:convert';

CharactersResponse charactersResponseFromJson(String str) => CharactersResponse.fromJson(json.decode(str));

String charactersResponseToJson(CharactersResponse data) => json.encode(data.toJson());

class CharactersResponse {
  CharactersResponse({
    this.characters,
  });

  Characters? characters;

  factory CharactersResponse.fromJson(Map<String, dynamic> json) => CharactersResponse(
    characters: json["characters"] == null ? null : Characters.fromJson(json["characters"]),
  );

  Map<String, dynamic> toJson() => {
    "characters": characters == null ? null : characters!.toJson(),
  };
}

class Characters {
  Characters({
    this.results,
  });

  List<Result>? results;

  factory Characters.fromJson(Map<String, dynamic> json) => Characters(
    results: json["results"] == null ? null : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.name,
    this.image,
    this.status,
    this.gender,
  });

  String? name;
  String? image;
  String? status;
  String? gender;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"] == null ? null : json["status"],
    gender: json["gender"] == null ? null : json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "status": status == null ? null : status,
    "gender": gender == null ? null : gender,
  };
}
