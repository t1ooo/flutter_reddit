import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/snackbar.dart';
import '../widget/awards.dart';
import '../widget/custom_future_builder.dart';
import '../widget/save_button.dart';
import '../widget/sized_placeholder.dart';
import '../widget/vote_button.dart';
import 'style.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.comment,
    this.depth = 0,
    this.showNested = true,
  }) : super(key: key);

  final Comment comment;
  final int depth;
  final bool showNested;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // commentSaveNotifierProvider(comment),
        // commentVoteNotifierProvider(comment),
        // collapseNotifierProvider(),
        commentProvider(comment),
      ],
      child: Builder(
        builder: (context) {
          if (depth == 0) {
            return withCard(context);
          }
          return body(context);
        },
      ),
    );

    // if (depth == 0) {
    //   return withCard(context);
    // }
    // return body(context);
  }

  Widget withCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: cardPadding,
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    final collapseNotifier = context.watch<CommentNotifier>();

    return Padding(
      padding: commentPadding(depth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          InkWell(
            onTap: collapseNotifier.expanded ? null : () {
              collapseNotifier.expand();
            },
            child: Row(
              children: [
                // SizedPlaceholder(width: 20, height: 20),
                // SizedBox(
                //   width: iconSize / 2,
                //   height: iconSize / 2,
                //   child: CustomFutureBuilder(
                //     future:
                //         context.read<RedditNotifier>().userIcon(comment.author),
                //     onData: (BuildContext context, String icon) {
                //       return Image.network(icon);
                //     },
                //     onLoading: (_) => Container(decoration: BoxDecoration()),
                //     onError: (_, __) => Container(),
                //     // onError: voidError,
                //   ),
                // ),
                // SizedBox(width: 10),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfileScreen(name: comment.author),
                      ),
                    );
                  },
                  child: Text(comment.author),
                ),
                Text(' • '),
                Text(formatDateTime(comment.created)),
                Awards(
                  awardIcons: comment.awardIcons,
                  totalAwardsReceived: comment.totalAwardsReceived,
                ),

                // IconButton(onPressed: () {}, icon: Icon(Icons.expand_less)),
              ],
            ),
          ),
          if (collapseNotifier.expanded) ...[
            Text(comment.body),
            Row(
              // alignment: WrapAlignment.end,
              // crossAxisAlignment: WrapCrossAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                // CommentSaveButton(comment: comment),
                // Icon(Icons.more_vert),
                /* Menu(
                items: [
                  // PopupMenuItem(child: CommentSaveButton(comment: comment)),
                  PopupMenuItem(
                    child: Builder(
                      builder: (_) {
                        final notifier = context.watch<CommentSaveNotifier>();
                        print('rebuild ${notifier.saved}');
                        final error = notifier.error;
                        if (error != null) {
                          // TODO: handle error
                        }
                        return GestureDetector(
                          onTap: () {
                            notifier.saved
                                ? notifier.unsave(comment.id)
                                : notifier.save(comment.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                notifier.saved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                              ),
                              Text(notifier.saved ? 'Unsave' : 'Save'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
               */
                /* StatefulBuilder(
                builder: (context, setState) {
                  return  */
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  // onSelected: (v) {
                  //   print(123123);
                  //   setState(()=>{});
                  // },
                  // child: Text('123'),
                  // initialValue: 2,
                  itemBuilder: (_) => [
                    // CustomPopupMenuItem(child: Text('457')),
                    // PopupMenuItem(child: CommentSaveButton(comment: comment)),
                    // PopupMenuItem(child: _commentSaveButton(context)),
                    _savePopupMenuItem(context),
                    _sharePopupMenuItem(context, comment),
                    _copyTextPopupMenuItem(context, comment),
                    _collapsePopupMenuItem(context),
                    // PopupMenuItem(onTap: () {/* TODO */}, child: Text('Save')),
                    // PopupMenuItem(onTap: () {/* TODO */}, child: Text('Share')),
                    // PopupMenuItem(onTap: () {/* TODO */}, child: Text('Copy text')),
                    // PopupMenuItem(onTap: () {/* TODO */}, child: Text('Collapse thread')),
                    PopupMenuItem(
                        onTap: () {/* TODO */}, child: Text('Report')),
                    PopupMenuItem(
                        onTap: () {/* TODO */}, child: Text('Block user')),
                  ],
                ),
                /* }
              ), */
                SizedBox(width: 20),
                Icon(Icons.star_outline),
                SizedBox(width: 20),
                Icon(Icons.reply),
                Text('Reply'),
                SizedBox(width: 20),
                // Icon(Icons.thumb_up),

                // Icon(Icons.expand_less),
                // Text(comment.ups.toString()),
                // Icon(Icons.expand_more),
                // CommentVoteButton(comment: comment),
                CommentVoteButton(),
              ],
            ),
            if (showNested)
              for (var reply in comment.replies)
                CommentWidget(
                  comment: reply,
                  showNested: showNested,
                  depth: depth + 1,
                )
          ],
        ],
      ),
    );
  }

  PopupMenuItem _savePopupMenuItem(BuildContext context) {
    // var update;
    return PopupMenuItem(
      // padding: EdgeInsets.zero,
      onTap: () async {
        // setState(()=>{});
        // update(()=>{});
        final notifier = context.read<CommentNotifier>();
        /* await (notifier.saved
            ? notifier.unsave(comment.id)
            : notifier.save(comment.id));

        final error = notifier.error;
        if (error != null) {
          showErrorSnackBar(context, error);
        }
        final result = notifier.result;
        if (result != null) {
          showSnackBar(context, result);
        } */

        /* try {
          final result = await (notifier.saved
              ? notifier.unsave(comment.id)
              : notifier.save(comment.id));
          if (result != null) {
            showSnackBar(context, result);
          }
        } on UIException catch (e) {
          showErrorSnackBar(context, e.toString());
        } */

        // (await (notifier.saved
        //     ? notifier.unsave(comment.id)
        //     : notifier.save(comment.id)))
        //   ..onError((error) {
        //     showErrorSnackBar(context, error);
        //   })
        //   ..onValue((value) {
        //     showSnackBar(context, value);
        //   });

          final result = await (notifier.comment.saved
              ? notifier.unsave()
              : notifier.save());
          if (result != null) {
            showSnackBar(context, result);
          }

        // final error = result.error;
        // if (error != null) {
        //   showErrorSnackBar(context, error);
        // }
        // final value = result.value;
        // if (value != null) {
        //   showSnackBar(context, value);
        // }
      },
      child: Builder(
        builder: (_) {
          // update = u;
          final notifier = context.watch<CommentNotifier>();

          // final error = notifier.error;
          // if (error != null) {
          //   showErrorSnackBar(context, error.toString());
          // }

          // final result = notifier.result;
          // if (result != null) {
          //   showSnackBar(context, 'Ok');
          // }

          return ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: Icon(
              notifier.comment.saved ? Icons.bookmark : Icons.bookmark_border,
            ),
            title: Text(notifier.comment.saved ? 'Unsave' : 'Save'),
          );
          // return Row(
          //   children: [
          //     Icon(
          //       notifier.saved ? Icons.bookmark : Icons.bookmark_border,
          //     ),
          //     SizedBox(width:5),
          //     Text(notifier.saved ? 'Unsave' : 'Save'),
          //   ],
          // );
        },
      ),
    );
  }

  PopupMenuItem _sharePopupMenuItem(
      BuildContext context, Comment comment) {
    return PopupMenuItem(
      onTap: () async {
        Share.share('${comment.linkTitle} ${comment.shortLink}');
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.share),
        title: Text('Share'),
      ),
    );
  }

  PopupMenuItem _copyTextPopupMenuItem(BuildContext context, Comment comment) {
    return PopupMenuItem(
      onTap: () {
        Clipboard.setData(ClipboardData(text: comment.body));
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.content_copy),
        title: Text('Copy text'),
      ),
    );
  }

  PopupMenuItem _collapsePopupMenuItem(BuildContext context) {
    return PopupMenuItem(
      onTap: ()  {
          context.read<CommentNotifier>().collapse();
        // Clipboard.setData(ClipboardData(text: comment.body));
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.expand_less),
        title: Text('Collapse thread'),
      ),
    );
  }

  // Widget _commentSaveButton(BuildContext context) {
  //   return StatefulBuilder(
  //     builder: (_, StateSetter setState) {
  //       final notifier = context.watch<CommentSaveNotifier>();

  //       print('rebuild ${notifier.saved}');
  //       final error = notifier.error;
  //       if (error != null) {
  //         // TODO: handle error
  //       }

  //       return TextButton.icon(
  //         style: ElevatedButton.styleFrom(
  //           minimumSize: Size.fromHeight(
  //               40), // fromHeight use double.infinity as width and 40 is the height
  //         ),
  //         onPressed: () {
  //           setState(() => {});
  //           notifier.saved
  //               ? notifier.unsave(comment.id)
  //               : notifier.save(comment.id);
  //         },
  //         icon: Icon(
  //           notifier.saved ? Icons.bookmark : Icons.bookmark_border,
  //         ),
  //         label: Text(notifier.saved ? 'Unsave' : 'Save'),
  //       );

  //       return GestureDetector(
  //         onTap: () {
  //           setState(() => {});
  //           notifier.saved
  //               ? notifier.unsave(comment.id)
  //               : notifier.save(comment.id);
  //         },
  //         child: SizedBox(
  //           width: double.infinity,
  //           child: Row(
  //             children: [
  //               Icon(
  //                 notifier.saved ? Icons.bookmark : Icons.bookmark_border,
  //               ),
  //               Text(notifier.saved ? 'Unsave' : 'Save'),
  //               // Spacer(),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

// class Menu<T> extends StatelessWidget {
//   Menu({Key? key, required this.items}) : super(key: key);

//   final List<PopupMenuEntry<T>> items;

//   @override
//   Widget build(BuildContext context) {
//     final offset = Offset.zero;
//     final RelativeRect position = RelativeRect.fromLTRB(0, 0, 0, 0);
//     return TextButton(
//         onPressed: () {
//           showMenu(
//             context: context,
//             // elevation: widget.elevation ?? popupMenuTheme.elevation,
//             items: items,
//             // [
//             //   PopupMenuItem(child: CommentSaveButton(comment: comment)),
//             // ],
//             // initialValue: widget.initialValue,
//             position: position,
//             // shape: widget.shape ?? popupMenuTheme.shape,
//             // color: widget.color ?? popupMenuTheme.color,
//           );
//         },
//         child: Text('menu'));
//   }
// }

// class CustomPopupMenuItem extends PopupMenuEntry {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement height
//   double get height => throw UnimplementedError();

//   @override
//   bool represents(value) {
//     // TODO: implement represents
//     throw UnimplementedError();
//   }
// }

// class CustomPopupMenuItem extends PopupMenuEntry {
//   CustomPopupMenuItem({Key? key}) : super(key: key);

//   @override
//   State<CustomPopupMenuItem> createState() => _CustomPopupMenuItemState();

//   @override
//   double get height => kMinInteractiveDimension;

//   @override
//   bool represents(value) => false;
// }

// class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Text('123');
//   }
// }

// class CustomPopupMenuItem extends PopupMenuItem {
//   CustomPopupMenuItem({Key? key, required Widget? child})
//       : super(key: key, child: child);

//   Widget build(BuildContext context) {
//     return Text('123');
//   }

//   // @override
//   // CustomPopupMenuItemState createState() => CustomPopupMenuItemState();
// }

// class CustomPopupMenuItemState extends PopupMenuItemState {
//   @override
//   void handleTap() {}

//   @override
//   Widget build(BuildContext context) {
//     return Text('123');
//   }
// }
