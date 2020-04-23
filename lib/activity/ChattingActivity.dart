import 'dart:ui';
import 'package:flutter/material.dart';

class ChattingActivity extends StatefulWidget{
	@override
	State createState() => ChattingActivityState();
}

class ChattingActivityState extends State<ChattingActivity> {
	FocusNode _focusNode = new FocusNode();
	var smileyPadGone = true;

	@override
	void initState() {
		super.initState();
		_focusNode.addListener(_focusNodeListener);
	}

	@override
	void dispose(){
		_focusNode.removeListener(_focusNodeListener);
		super.dispose();
	}

	void _focusNodeListener() {
		if (_focusNode.hasFocus || _focusNode.consumeKeyboardToken()){
			setState(() {
				smileyPadGone = true;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'FlutterChatting',
			theme: ThemeData(primaryColor: Colors.white),
			home: Scaffold(
				appBar: AppBar(),
				body: Column(
					children: <Widget>[
						Expanded(
							flex: 1,
							child: Container(
								color: Color(0xfff5f5f7),
								child: Stack(
									children: <Widget>[
										chattingList(),
										Text("会话"),
									],
								),
							),
						),
						Padding(
							padding: EdgeInsets.fromLTRB(12, 10, 0, 10),
							child: Row(
								children: <Widget>[
									Icon(Icons.record_voice_over),
									Expanded(child: TextField(
										focusNode: _focusNode,
										onTap: _onTextFieldTap,
									)),
									Container(
											margin: EdgeInsets.fromLTRB(5, 0, 3, 0),
											child:InkWell(
												onTap: _onSmileyTap,
												child: Icon(Icons.insert_emoticon, size: 30,),
											)
									),
								],
							),
						),
						Offstage(
							offstage: smileyPadGone,
							child: Container(
								height: 300,
								width: MediaQuery.of(context).size.width,
								child: Text("表情面板"),
							),
						),
					],
				),
			),
		);
	}

	chattingList() {
		return ListView.builder(
			itemBuilder: (context, index) => renderRow(context, index),
		);
	}

	renderRow(BuildContext context, int index) {

	}

	_onSmileyTap() {
		_focusNode.unfocus();
		setState(() {
			smileyPadGone = !smileyPadGone;
		});
	}

	_onTextFieldTap() {
		setState(() {
			smileyPadGone = true;
		});
	}
}