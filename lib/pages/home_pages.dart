import 'package:api/main.dart';
import 'package:api/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = List.empty();
  bool isLoading = false;

  Future<void> getPosts() async {
    setState(() {
      isLoading = true;
    });
    final baseURL = "http://jsonplaceholder.typicode.com";
    var url = Uri.parse(
      '$baseURL/posts',
    );
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      posts = json.map((e) => Post.fromJson(e)).toList();
      //print(posts);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Posts"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                        "Ainda não há posts disponíveis, lique no buttão para encontrar os mais recentes",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ListTile(
                          leading: Text(
                            posts[index].id.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          title: Text(
                            posts[index].title ?? "",
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              (posts[index].body.toString()),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          //subtitle: Text(posts[index].body ?? ""),
                        ),
                      ),
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: posts.isEmpty ? Colors.black12 : Colors.white,
        onPressed: () async {
          await getPosts();
          setState(() {});
        },
        child: posts.isEmpty
            ? Icon(
                Icons.download,
                semanticLabel: "Get Posts",
                color: Colors.white,
              )
            : Icon(
                Icons.refresh,
                semanticLabel: "Get Posts",
                color: Colors.black,
              ),
      ),
    );
  }
}
