class QueryMutation {
  String getQuery() {
    return """
    query {
    characters {
    results {
    name,
    image,
    status,
    gender,
    }
    }
    }
    """;
  }
}
