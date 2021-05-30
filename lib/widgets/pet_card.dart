import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoo_home/helpers/pet_visual_helper.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetCard extends StatelessWidget {
  final GestureTapCallback onTap;
  final Pet pet;
  final String avatarUrl;
  const PetCard({
    Key key,
    @required this.onTap,
    @required this.pet,
    @required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
        child: SizedBox(
          height: 100,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: PetVisualHelper.petStatusToColor(pet.status),
                    width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Hero(
                      tag: '${pet.id}-pet',
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        child: avatarUrl == null
                            ? Image.asset(
                                pet.kind == PetKind.CAT
                                    ? 'assets/images/cat_placeholder.jpg'
                                    : pet.kind == PetKind.DOG
                                        ? 'assets/images/dog_placeholder.jpg'
                                        : 'assets/images/other_placeholder.jpg',
                              )
                            : CachedNetworkImage(
                                imageUrl: avatarUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  pet.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 2.0)),
                                Text(
                                  pet.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  PetVisualHelper.petKindToString(pet.kind),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: CircleAvatar(
                                        backgroundColor:
                                            PetVisualHelper.petStatusToColor(
                                                pet.status),
                                        radius: 4.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        PetVisualHelper.petStatusToString(
                                            pet.status),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(pet.date.toString())),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 20,
                      child: Align(
                        child: Icon(Icons.pets),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
