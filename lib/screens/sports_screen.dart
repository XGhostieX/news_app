import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:news_app/models/cubit.dart';
import 'package:news_app/models/states.dart';
import 'package:news_app/widgets/article_item.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      builder: (context, state) => ConditionalBuilder(
        condition: state is! NewsGetSportsLoadingState,
        builder: (context) => ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => ArticleItem(
            article: NewsCubit.get(context).sports[index],
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: NewsCubit.get(context).sports.length,
        ),
        fallback: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      listener: (context, state) {},
    );
  }
}
