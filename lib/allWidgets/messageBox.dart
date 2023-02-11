import 'package:flutter/material.dart';

import '../allConstants/color_constants.dart';
import '../functions/utilits.dart';

Row messageBox(Map<String, dynamic> data, bool itsMe) {
  return itsMe
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 8,
                  right: 8,
                  left: 50,
                ),
                child: Container(
                    // width: width / 1.5,
                    decoration: const BoxDecoration(
                        color: ColorConstants.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(0),
                        )),
                    // height: 10,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  data['msg'],
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 10,
                                  // softWrap: true,
                                  overflow: TextOverflow.fade,
                                  // tex
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    FunctionalityClass.timestampToTimeString(
                                        data['timestamp']),
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 10),
                                    maxLines: 10,
                                    // softWrap: true,
                                    overflow: TextOverflow.fade,
                                    // tex
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Positioned(
                        //   right: 0,
                        //   bottom: 0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //         bottom: 2, right: 2, left: 2),
                        //     child: Text(
                        //       FunctionalityClass.timestampToTimeString(
                        //           data['timestamp']),
                        //       style: const TextStyle(
                        //           color: Colors.white, fontSize: 8),
                        //       maxLines: 10,
                        //       // softWrap: true,
                        //       overflow: TextOverflow.fade,
                        //       // tex
                        //     ),
                        //   ),
                        // ),
                      ],
                    )),
              ),
            ),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 8,
                  right: 50,
                  left: 8,
                ),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    // width: width / 1.5,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(10),
                        )),
                    // height: 10,
                    child: Text(
                      data['msg'],
                      style: const TextStyle(color: Colors.black),
                      maxLines: 10,
                      // softWrap: true,
                      overflow: TextOverflow.fade,
                      // tex
                    )),
              ),
            ),
          ],
        );
}
