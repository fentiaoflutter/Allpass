import 'package:flutter/material.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/params/changed.dart';
import 'package:allpass/utils/allpass_ui.dart';

/// 查看或编辑密码页面
class ViewAndEditPasswordPage extends StatefulWidget {
  final PasswordBean data;
  final String pageTitle;

  ViewAndEditPasswordPage(this.data, this.pageTitle);

  @override
  _ViewPasswordPage createState() {
    return _ViewPasswordPage(data, pageTitle);
  }
}

class _ViewPasswordPage extends State<ViewAndEditPasswordPage> {
  final String pageName;

  PasswordBean tempData;
  PasswordBean oldData;

  var nameController;
  var usernameController;
  var passwordController;
  var notesController;
  var urlController;

  bool _passwordVisible = false;

  _ViewPasswordPage(PasswordBean data, this.pageName) {
    this.oldData = data;
    tempData = PasswordBean(oldData.username, oldData.password, oldData.url,
        key: oldData.uniqueKey,
        name: oldData.name,
        folder: oldData.folder,
        label: List()..addAll(oldData.label),
        notes: oldData.notes,
        fav: oldData.fav,
        isNew: false);

    nameController = TextEditingController(text: tempData.name);
    usernameController = TextEditingController(text: tempData.username);
    passwordController = TextEditingController(text: tempData.password);
    notesController = TextEditingController(text: tempData.notes);
    urlController = TextEditingController(text: tempData.url);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("取消修改: " + oldData.toString());
        Navigator.pop<PasswordBean>(context, this.oldData);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            pageName,
            style: AllpassTextUI.firstTitleStyleBlack,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () {
                print("保存: " + tempData.toString());
                Navigator.pop<PasswordBean>(context, tempData);
              },
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "名称",
                    style: AllpassTextUI.firstTitleStyleBlue,
                  ),
                  TextField(
                    controller: nameController,
                    onChanged: (text) {
                      tempData.name = text;
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "URL",
                    style: AllpassTextUI.firstTitleStyleBlue,
                  ),
                  TextField(
                    controller: urlController,
                    onChanged: (text) {
                      tempData.url = text;
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "用户名",
                    style: AllpassTextUI.firstTitleStyleBlue,
                  ),
                  TextField(
                    controller: usernameController,
                    onChanged: (text) {
                      tempData.username = text;
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "密码",
                    style: AllpassTextUI.firstTitleStyleBlue,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          onChanged: (text) {
                            tempData.password = text;
                          },
                        ),
                      ),
                      IconButton(
                        icon: _passwordVisible == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            if (_passwordVisible == false)
                              _passwordVisible = true;
                            else
                              _passwordVisible = false;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "文件夹",
                    style: AllpassTextUI.firstTitleStyleBlue,
                  ),
                  DropdownButton(
                    onChanged: (newValue) {
                      setState(() {
                        tempData.folder = newValue;
                      });
                    },
                    items: FolderAndLabelList.folderList
                        .map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    style: AllpassTextUI.firstTitleStyleBlack,
                    elevation: 8,
                    iconSize: 30,
                    value: tempData.folder,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "标签",
                      style: AllpassTextUI.firstTitleStyleBlue,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: _getTag()),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "备注",
                    style: AllpassTextUI.firstTitleStyleBlue,
                  ),
                  TextField(
                    controller: notesController,
                    onChanged: (text) {
                      tempData.notes = text;
                    },
                  ),
                ],
              ),
            )
          ],
        )),
        backgroundColor: Colors.white,
      ),
    );
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = List();
    FolderAndLabelList.labelList.forEach((item) {
      labelChoices.add(ChoiceChip(
        label: Text(item),
        labelStyle: AllpassTextUI.secondTitleStyleBlack,
        selected: tempData.label.contains(item),
        onSelected: (selected) {
          setState(() {
            tempData.label.contains(item)
                ? tempData.label.remove(item)
                : tempData.label.add(item);
          });
        },
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    return labelChoices;
  }
}
