import 'package:flutter/material.dart';
import 'package:graphql_demo/graphql_config.dart';
import 'package:graphql_demo/graphql_constant.dart';
import 'package:graphql_demo/models/characters_response.dart';
import 'package:graphql_demo/query_mutation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLConfig graphQLConfig = GraphQLConfig();

void main() {
  runApp(
    GraphQLProvider(
      client: graphQLConfig.client,
      child: const CacheProvider(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QueryMutation queryMutation = QueryMutation();
  late final Future<CharactersResponse?> getData;
  CharactersResponse? responseData;

  @override
  void initState() {
    getData = getGraphQLData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphQL Query"),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<CharactersResponse?>(
            future: getData,
            builder: (BuildContext context, AsyncSnapshot<CharactersResponse?> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              } else if(snapshot.hasData && snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                return listWidget(snapshot.data);
              } else if(snapshot.hasError || snapshot.data == null) {
                return const Text("Something went wrong");
              } else {
                return const CircularProgressIndicator();
              }
            }
          )
        ),
        ),
    );
  }

  Future<CharactersResponse?> getGraphQLData() async {

    GraphQLClient client = graphQLConfig.clientQuery(GraphQLConstant.graphQLLink);
    QueryOptions options = QueryOptions(document: gql(queryMutation.getQuery()));
    QueryResult result = await client.query(options);


    if(!result.hasException) {
      print(result.toString()); //Avoid `print` calls in production code.
      CharactersResponse response = CharactersResponse.fromJson(result.data!);
      return response;
    }
    else {
      print("error : ${result.toString()}");//Avoid `print` calls in production code.
      return null;
    }
  }

  Widget statusWidget(String status) {

    Color? statusColor;

    switch(status) {
      case "Alive" : {
        statusColor = Colors.green;
      }
      break;
      case "Dead" : {
        statusColor = Colors.black;
      }
      break;
      case "unknown" : {
        statusColor = Colors.deepPurple;
      }
      break;
    }
    return Tooltip(
      message: status,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: statusColor,
        child:const Icon(Icons.adjust, color: Colors.white,),
      ),
    );
  }

  Widget genderWidget(String gender) {
    IconData? genderIcon;
    Color? genderColor;

    switch(gender) {
      case "Male" : {
        genderIcon = Icons.male;
        genderColor = Colors.blue;
      }
      break;
      case "Female" : {
        genderIcon = Icons.female;
        genderColor = Colors.pink;
      }
      break;
      case "unknown" : {
        genderIcon = Icons.question_mark;
        genderColor = Colors.black;
      }
      break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(genderIcon, color: genderColor,),
        Text(gender),
      ],
    );
  }

  Widget listWidget(CharactersResponse? data) {
    return ListView.builder(
        itemCount: data!.characters!.results!.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image(
                image: NetworkImage(
                  data.characters!.results![index].image!,
                ),
              ),
              title: Text(data.characters!.results![index].name!),
              subtitle: genderWidget(data.characters!.results![index].gender!),
              trailing: statusWidget(data.characters!.results![index].status!),
            ),
          );
        } );
  }
}
