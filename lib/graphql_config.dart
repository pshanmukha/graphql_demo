import 'package:flutter/material.dart';
import 'package:graphql_demo/graphql_constant.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  HttpLink getHttpLink(String url) {
    HttpLink httpLink = HttpLink(url);
    return httpLink;
  }

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink(GraphQLConstant.graphQLLink),
  ));

  GraphQLClient clientQuery(String url) {
    return GraphQLClient(
        link: getHttpLink(url),
        cache: GraphQLCache(),
    );
  }
}
