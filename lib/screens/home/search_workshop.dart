import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';

class SearchBarWidget {
  TextEditingController searchController = TextEditingController();
  var searchPost;
  final ValueNotifier<bool> isSearching;

  SearchBarWidget(this.isSearching);

  Widget getSearchTextField(context) {
    return StatefulBuilder(
      builder: (context, setState) => TextFormField(
        onTap: () => print('===================='),
        controller: searchController,
        decoration: InputDecoration(
            hintText: 'Search Workshops ...',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: isSearching.value ? Icon(Icons.clear) : Container(),
              onPressed: () {
                setState(() {
                  searchController.clear();
                  isSearching.value = false;
                });
                // FocusScope.of(context).unfocus();
              },
            )),
        onFieldSubmitted: (value) {
          if (value.isEmpty) return;

          setState(() {
            isSearching.value = true;

            searchPost = BuiltWorkshopSearchByStringPost((b) => b
              ..search_by = 'title'
              ..search_string = searchController.text);
          });
        },
      ),
    );
  }
}
