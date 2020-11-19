import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class SearchBarWidget {
  TextEditingController searchController = TextEditingController();
  var searchPost;
  final ValueNotifier<bool> isSearching;

  SearchBarWidget(this.isSearching);

  Widget getSearchTextField(context,
      {GlobalKey<FabCircularMenuState> fabKey, FocusNode searchFocusNode}) {
    return StatefulBuilder(
      builder: (context, setState) => TextFormField(
        focusNode: searchFocusNode,
        onTap: () {
          print('====================');
          if (fabKey.currentState.isOpen) {
            fabKey.currentState.close();
          }
        },
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
                  searchFocusNode.unfocus();
                });
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
