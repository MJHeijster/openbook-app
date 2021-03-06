import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post_header/widgets/community_post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_header/widgets/user_post_header.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post post;
  final OnPostDeleted onPostDeleted;

  const OBPostHeader({Key key, this.onPostDeleted, this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return post.isCommunityPost()
        ? OBCommunityPostHeader(
            post,
            onPostDeleted: onPostDeleted,
          )
        : OBUserPostHeader(
            post,
            onPostDeleted: onPostDeleted,
          );
  }
}
