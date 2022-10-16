import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:quote_app/colors.dart';
import 'package:quote_app/services/shared_service.dart';
import 'package:uuid/uuid.dart';

import '../model/authors_quote.dart';
import '../model/quote_model.dart';
import '../services/api_services.dart';

class AuthorsScreen extends StatefulWidget {
  // final _myBox = Hive.box('myBox');

  AuthorsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  late Future<Quotes> future;
  late TextEditingController seachController;

  SharedServices _sharedServices = SharedServices();

  List<Result> searchResult = [];
  List<Results> favList = [];

  bool isSearching = false;

  @override
  void initState() {
    future = getQuote();
    seachController = TextEditingController();
    getFavourites();
    super.initState();
  }

  void getFavourites() async {
    var res = await _sharedServices.getFavourites();
    setState(() {
      favList = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: primaryDarkColorDark,
        title: const Text(
          'Author Quotes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                future = getQuote();
              });
            },
            icon: Icon(Icons.restore),
          ),
        ],
      ),
      backgroundColor: primaryDarkColorDark,
      body: FutureBuilder<Quotes>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final quotes = snapshot.data?.results;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: seachController,
                      onChanged: (value) async {
                        if (value.isEmpty) {
                          setState(() {
                            isSearching = false;
                          });
                          return;
                        } else {
                          var res = await quoteSearch(value);
                          setState(() {
                            isSearching = true;
                            searchResult = res.results!;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search for Author',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  isSearching
                      ? Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: searchResult.length,
                              itemBuilder: (_, index) {
                                return ListTile(
                                  onTap: () {
                                    seachController.clear();
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      isSearching = false;
                                      future = getQuote(
                                          isNormal: false,
                                          authorName:
                                              searchResult[index].name!);
                                    });
                                  },
                                  title: Text(searchResult[index].name!),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        NetworkImage(searchResult[index].link!),
                                  ),
                                );
                              }),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                  CarouselSlider.builder(
                    itemCount: quotes?.length,
                    options: CarouselOptions(
                        viewportFraction: 0.6,
                        enlargeCenterPage: quotes!.length != 1,
                        aspectRatio: 1.3),
                    itemBuilder: (context, index, realindex) {
                      return Card(
                        color: primaryDarkColorDark,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: mainGradientDark,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    quotes[index].content!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '-- ${quotes[index].author!}',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      var quote = Results(
                                          author: quotes[index].author,
                                          content: quotes[index].content,
                                          id: Uuid().v4());
                                      await _sharedServices
                                          .addToFavourites(quote);

                                      favList =
                                          await _sharedServices.getFavourites();
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.favorite_border),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Favorite Quotes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  favList.isEmpty
                      ? SizedBox.shrink()
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              favList.length,
                              (index) {
                                final quote = favList[index];
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 20, top: 20, right: 10),
                                  height: 200,
                                  width: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: mainGradientDark,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          quote.content!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '-- ${quote.author!}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await _sharedServices
                                                .deleteFavourites(quote.id!);
                                            favList = await _sharedServices
                                                .getFavourites();
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            throw snapshot.error.toString();
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
