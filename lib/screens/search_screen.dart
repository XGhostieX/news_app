import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:news_app/models/cubit.dart';
import 'package:news_app/models/states.dart';
import '../widgets/article_item.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: searchController,
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter a Search Value';
                  }
                  return null;
                },
                onChanged: (value) => NewsCubit.get(context).getSearch(value),
                decoration: const InputDecoration(
                  // label: Text('Search'),
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<NewsCubit, NewsStates>(
                builder: (context, state) => ConditionalBuilder(
                  condition: state is! NewsGetSearchLoadingState,
                  builder: (context) => ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => ArticleItem(
                      article: NewsCubit.get(context).search[index],
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: NewsCubit.get(context).search.length,
                  ),
                  fallback: (context) => Container(),
                ),
                listener: (context, state) {},
              ),
            ),
          ],
        ),
      ),
      listener: (context, state) {},
    );
  }
}
