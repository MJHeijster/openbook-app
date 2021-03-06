import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/letter_avatar.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/libs/pretty_count.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:tinycolor/tinycolor.dart';

class OBCommunityTile extends StatelessWidget {
  static const COVER_PLACEHOLDER = 'assets/images/fallbacks/cover-fallback.jpg';

  static const double smallSizeHeight = 60;
  static const double normalSizeHeight = 80;

  final Community community;
  final ValueChanged<Community> onCommunityTilePressed;
  final OBCommunityTileSize size;

  const OBCommunityTile(this.community,
      {this.onCommunityTilePressed,
      Key key,
      this.size = OBCommunityTileSize.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String communityHexColor = community.color;
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    Color communityColor =
        themeValueParserService.parseColor(communityHexColor);
    Color textColor;

    BoxDecoration containerDecoration;
    BorderRadius containerBorderRadius = BorderRadius.circular(10);
    bool isCommunityColorDark =
        themeValueParserService.isDarkColor(communityColor);
    bool communityHasCover = community.hasCover();

    if (communityHasCover) {
      textColor = Colors.white;
      containerDecoration = BoxDecoration(
          borderRadius: containerBorderRadius,
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.60), BlendMode.darken),
              image: AdvancedNetworkImage(community.cover,
                  useDiskCache: true, fallbackAssetImage: COVER_PLACEHOLDER, retryLimit: 0)));
    } else {
      textColor = isCommunityColorDark ? Colors.white : Colors.black;
      bool communityColorIsNearWhite = communityColor.computeLuminance() > 0.9;

      containerDecoration = BoxDecoration(
        color: communityColorIsNearWhite
            ? TinyColor(communityColor).darken(5).color
            : TinyColor(communityColor).lighten(10).color,
        borderRadius: containerBorderRadius,
      );
    }

    bool isNormalSize = size == OBCommunityTileSize.normal;

    Widget communityAvatar;
    if (community.hasAvatar()) {
      communityAvatar = OBAvatar(
        avatarUrl: community.avatar,
        size: isNormalSize ? OBAvatarSize.medium : OBAvatarSize.small,
      );
    } else {
      Color avatarColor = communityHasCover
          ? communityColor
          : (isCommunityColorDark
              ? TinyColor(communityColor).lighten(5).color
              : communityColor);
      communityAvatar = OBLetterAvatar(
        letter: community.name[0],
        color: avatarColor,
        labelColor: textColor,
        size: isNormalSize ? OBAvatarSize.medium : OBAvatarSize.small,
      );
    }

    String userAdjective = community.userAdjective ?? 'Member';
    String usersAdjective = community.usersAdjective ?? 'Members';
    String membersPrettyCount = getPrettyCount(community.membersCount);
    String finalAdjective =
        community.membersCount == 1 ? userAdjective : usersAdjective;

    Widget communityTile = Container(
      height: isNormalSize ? normalSizeHeight : smallSizeHeight,
      decoration: containerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: communityAvatar,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('c/' + community.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis),
                Text(
                  community.title,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                isNormalSize
                    ? Text(
                        '$membersPrettyCount $finalAdjective',
                        style: TextStyle(color: textColor, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox()
              ],
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );

    if (onCommunityTilePressed != null)
      communityTile = GestureDetector(
        onTap: () {
          onCommunityTilePressed(community);
        },
        child: communityTile,
      );

    return communityTile;
  }
}

enum OBCommunityTileSize { normal, small }
