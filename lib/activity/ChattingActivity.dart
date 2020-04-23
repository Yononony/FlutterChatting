import 'dart:ui';
import 'package:flutter/material.dart';

class ChattingActivity extends StatefulWidget{
	@override
	State createState() => ChattingActivityState();
}

class ChattingActivityState extends State<ChattingActivity> with WidgetsBindingObserver {
	FocusNode _focusNode = new FocusNode();
	var smileyPadGone = true;
	bool needShowSmiley = false;
	bool needHideSmiley = false;
	bool keyboardShow = false;
	double keyboard = -1;
	static const double keyboard_height=300;

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_focusNode.addListener(_focusNodeListener);
	}

	@override
	void dispose(){
		WidgetsBinding.instance.removeObserver(this);
		_focusNode.removeListener(_focusNodeListener);
		super.dispose();
	}

	void _focusNodeListener() {
		/*if (_focusNode.hasFocus || _focusNode.consumeKeyboardToken()){
			setState(() {
				smileyPadGone = true;
			});
		}*/
	}

	@override
	void didChangeMetrics() {
		super.didChangeMetrics();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			keyboardShow = MediaQuery.of(context).viewInsets.bottom > 0;
		});

		if (needShowSmiley && window.viewInsets.bottom <= 0.1) {
			needShowSmiley = false;
			setState(() {
				smileyPadGone = false;
			});
		}
		if(needHideSmiley && window.viewInsets.bottom > 0.1) {
			needHideSmiley = false;
			setState(() {
				smileyPadGone = true;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		double h = MediaQuery.of(context).viewInsets.bottom;
		if(h > 0 && keyboard <= 0) {
			setState(() {
				keyboard = h;
			});
		}
		return MaterialApp(
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
								height: keyboard == -1 ? keyboard_height : keyboard,
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
		if(smileyPadGone && _focusNode.hasFocus && keyboardShow) {
			needShowSmiley = true;
			_focusNode.unfocus();
		} else {
			setState(() {
				smileyPadGone = !smileyPadGone;
			});
		}
	}

	_onTextFieldTap() {
		if(!smileyPadGone) {
			needHideSmiley = true;
		}
	}
}