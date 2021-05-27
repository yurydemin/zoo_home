import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoo_home/helpers/pet_visual_helper.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetCard extends StatelessWidget {
  final GestureTapCallback onTap;
  final Pet pet;
  const PetCard({
    Key key,
    @required this.onTap,
    @required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 0.5),
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
                      child: pet.images.length > 0
                          ? Image.network(pet.images.first)
                          : Image.asset(
                              pet.kind == PetKind.CAT
                                  ? 'assets/images/cat_placeholder.jpg'
                                  : pet.kind == PetKind.DOG
                                      ? 'assets/images/dog_placeholder.jpg'
                                      : 'assets/images/other_placeholder.jpg',
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
