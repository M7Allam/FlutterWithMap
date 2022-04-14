import 'package:flutter/material.dart';
import 'package:flutter_maps/data/models/place_suggestions_model.dart';
import 'package:flutter_maps/others/values/colors.dart';

class PlaceSuggestionsItem extends StatelessWidget {
  final PlaceSuggestion suggestion;

  const PlaceSuggestionsItem({Key? key, required this.suggestion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subTitle = suggestion.description
        .replaceAll(suggestion.description.split(',')[0], '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.lightBlue,
              ),
              child: const Icon(
                Icons.place,
                color: MyColors.blue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${suggestion.description.split(',')[0]}\n',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: subTitle.substring(2),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
