import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_with_myysql/app/resources/asset_path.dart';
import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? image;
  final BoxFit fit;
  final String placeholder;
  final ImageType imageType;
  const CustomImage({
    this.image,
    this.fit = BoxFit.contain,
    this.imageType = ImageType.TYPE_ASSET,
    this.placeholder = AssetPath.imageCamera,
  });

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context);
    return LayoutBuilder(
      builder: (con, cons) {
        var size=cons.biggest;
        print("image size: $size");
        var plac=Center(
            child: Container(
              width: 0.4 * size.width,
              child: Image.asset(placeholder),
            ));
        return Container(
          child: imageType == ImageType.TYPE_NETWORK
              ?
          CachedNetworkImage(
            imageUrl: image ?? "",
            // width: width,height: height,
            memCacheHeight: (size.height*media.devicePixelRatio).round(),
            memCacheWidth: (size.width*media.devicePixelRatio).round(),
            //maxWidthDiskCache:width.toInt(),
            //  maxHeightDiskCache: height.toInt(),
            fit: fit,
            placeholder: (con, img) {
              return plac;
            },
            errorWidget: (con, _, __) {
              return plac;
            },
          )
              : imageType == ImageType.TYPE_FILE
              ? Image.file(
            File(image ?? ""),
            fit: fit,
            errorBuilder: (_, __, ___) {
              return plac;
            },
          )
              : imageType == ImageType.TYPE_ASSET
              ? Image.asset(
            image ?? "",
            fit: fit,
          )
              : Container(),
        );
      },
    );
  }
}


class ShadowContainer extends StatelessWidget {
  final double elevation;
  final Widget child;
  final double radius;
  final bool enabledPadding;
  const ShadowContainer({
    Key? key,
    this.elevation = 5,
    required this.child,
    this.enabledPadding = false,
    this.radius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(enabledPadding ? elevation : 0),
      child: Material(
        elevation: elevation,
        shadowColor: AppColor.colorShadowGrey,
        color: AppColor.colorTransparent,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

enum ImageType{
  TYPE_ASSET,TYPE_FILE,TYPE_NETWORK
}

enum PickType{
  TYPE_FILE,TYPE_IMAGE
}