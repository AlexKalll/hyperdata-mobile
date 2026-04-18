import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/image.dart';

enum EntityType { branch, vehicle }

class EntityChooserWidget extends StatelessWidget {
  final List<dynamic> entities;
  final Function(String) onSelect;
  final String selectedEntityId;
  final EntityType entityType;

  const EntityChooserWidget({
    super.key,
    required this.entities,
    required this.onSelect,
    required this.selectedEntityId,
    required this.entityType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var entity in entities)
                InkWell(
                  onTap: () {
                    onSelect(entity.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5, bottom: 5, right: 2),
                    child: Row(
                      children: [
                        entityWidget(entity, entityType , entity.id == selectedEntityId),
                        const SizedBox(width: 10),
                        Container(
                          height: 35,
                          width: 1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(thickness: 1,color: Colors.black,)
      ],
    );
  }
}


Widget entityWidget(dynamic entity, EntityType entityType, bool isChosen){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // border: Border.all(width: 0.5,color: isChosen?Colors.green:Colors.black),
        color: isChosen?Colors.black:AppColors.gray
    ),
    child:Row(
      children: [
        entityType == EntityType.branch?
        assetSvgImageWidget("branch.svg",color: isChosen?Colors.white:null,width: 20,height: 20):
        networkImageWidget(
            imageUrl: entity.image??"",
            width: 20,height: 20,
            borderRadius: 25,
            errorImageUrl:"${entityType.name}.svg",
            errorImageColor: isChosen?Colors.white:Colors.black
        ),
        const SizedBox(width: 10,),
        Text(entity.name,style: TextStyle(fontWeight: FontWeight.bold,color: isChosen?Colors.white:Colors.black))
      ],
    ),
  );
}
