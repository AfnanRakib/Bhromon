import 'package:flutter/material.dart';
class chatItem extends StatefulWidget {
  late final String text;
  late final bool isMe;
  chatItem({
    super.key,
    required this.text,
    required this.isMe
  });

  @override
  State<chatItem> createState() => _chatItemState();
}

class _chatItemState extends State<chatItem> {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
      child: Row(
        mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!widget.isMe) ProfileContainer(widget: widget),
          if(!widget.isMe) const SizedBox(width: 15,),
          Container(
            padding: EdgeInsets.all(15),
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width*.60,maxWidth:MediaQuery.of(context).size.width*.60 ),
            decoration: BoxDecoration(
              color: widget.isMe ? Theme.of(context).colorScheme.secondary : Colors.grey.shade800,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(widget.isMe ? 15 : 0),
                bottomRight: Radius.circular(widget.isMe ? 0 : 15),
              )
            ),
            child: Text(widget.text,style: TextStyle(
              color:  Theme.of(context).colorScheme.onSecondary,          ),),
          ),
          if(widget.isMe) SizedBox(width: 10,),
          if(widget.isMe) ProfileContainer(widget: widget)
        ],
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {

  const ProfileContainer({
    super.key,
    required this.widget,
  });

  final chatItem widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: widget.isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight:const Radius.circular(10),
          bottomLeft: Radius.circular(widget.isMe ? 0 : 15),
          bottomRight: Radius.circular(widget.isMe ? 15 : 0),
        )
      ),
      child: Icon(
          widget.isMe
              ? Icons.person
              : Icons.computer,
        //color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
