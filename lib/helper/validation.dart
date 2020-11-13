

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'base_url.dart';
import 'custom_widget.dart';

bool validateSignInCredentials(
    {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required String email,
      @required String password}) {
  if (email.isEmpty) {
    customSnackBar(scaffoldKey, 'Please enter valid Phone');
    return false;
  }

  if (password.isEmpty || password.length < 4) {
    customSnackBar(
        scaffoldKey, 'Password length should be a minimum of 6 digits');
    return false;
  }

  return true;
}
/*
Widget CircleImage(
    {double width,
      double height,
      String path,
      File file,
      Color color,
      Color dColor,
      bool isOnline = false,
      Function() onTap}) {
  if (file != null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image.file(
        file,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  } else if (path.contains("http")) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: path,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: color != null ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Visibility(
                visible: isOnline,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        width: width > 100 ? 30 : 20,
                        height: height > 100 ? 30 : 20,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              //                   <--- border color
                              width: 3.0,
                            )))),
              )
            ],
          ),
        ),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          child: SvgPicture.asset(StringRes.ASSET_DEFAULT_AVATAR),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          child: SvgPicture.asset(StringRes.ASSET_DEFAULT_AVATAR),
        ),
      ),
    );
  } else {
    return Container(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: color != null ? color : Colors.transparent,
          child: path.contains(".svg")
              ? SvgPicture.asset(
            path,
            width: width,
            color: dColor,
            height: height,
          )
              : Image.asset(
            path,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}*/

String currency(BuildContext context, dynamic amount) {
  return NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(amount);
}
