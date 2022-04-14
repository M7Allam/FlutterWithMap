import 'package:flutter/material.dart';
import 'package:flutter_maps/data/models/place_directions_model.dart';
import 'package:flutter_maps/others/values/colors.dart';

class DistanceAndTime extends StatelessWidget {
  final PlaceDirections? directions;
  final bool isDistanceAndTimeVisible;

  const DistanceAndTime(
      {Key? key, this.directions, required this.isDistanceAndTimeVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isDistanceAndTimeVisible,
      child: Positioned(
        top: 0,
        bottom: 460,
        left: 0,
        right: 0,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                      Icons.access_time_filled,
                    color: MyColors.blue,
                    size: 30,
                  ),
                  title: Text(
                      '${directions?.totalDuration}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Flexible(
              flex: 1,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.directions_car_filled,
                    color: MyColors.blue,
                    size: 30,
                  ),
                  title: Text(
                    '${directions?.totalDistance}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
