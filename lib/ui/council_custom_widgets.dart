import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/text_style.dart';

class CouncilCustomWidgets {
  final BuiltCouncilPost councilData;
  final BuildContext context;
  CouncilCustomWidgets({
    @required this.context,
    @required this.councilData,
  });

  final space = SizedBox(height: 8.0);
  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);

  Widget getPanel(
      {@required ScrollController scrollController,
      @required BorderRadiusGeometry radius}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      padding: EdgeInsets.only(top: 20.0),
      child: ListView(
        controller: scrollController,
        children: <Widget>[
          space,
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          councilData == null
                              ? ''
                              : councilData.name.contains('Sport')
                                  ? 'Teams'
                                  : 'Clubs',
                          style: Style.headingStyle
                              .copyWith(color: ColorConstants.textColor),
                          textAlign: TextAlign.left),
                      divide,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _getClubs(),
        ],
      ),
    );
  }

  Widget _getClubs() {
    return councilData == null
        ? Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: LoadingCircle,
            ),
          )
        : Container(
            child: ListView.builder(
              reverse: councilData.name.contains(
                  'Sports'), // So that the teams are displayed in alphabetical order
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: councilData.clubs.length,
              itemBuilder: (context, index) {
                return ClubCouncilAndEntityWidgets.getTitleCard(
                  context: context,
                  title: councilData.clubs[index].name,
                  subtitle: councilData.name,
                  id: councilData.clubs[index].id,
                  imageUrl: councilData.clubs[index].small_image_url,
                  isClub: true,
                  club: councilData.clubs[index],
                  horizontal: true,
                );
              },
            ),
          );
  }
}
