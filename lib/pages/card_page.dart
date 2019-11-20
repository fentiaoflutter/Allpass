import 'package:flutter/material.dart';

import 'package:allpass/bean/card_bean.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/test_data.dart';

/// 卡片页面
class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _CardPage();
}

class _CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    CardTestData();   // 初始化测试数据
    return _CardPageState();
  }
}

class _CardPageState extends State<_CardPage> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("卡片", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarOpacity: 1,
      ),
      body: Column(
        children: <Widget>[
          // 搜索框
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 40),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: null,
                      borderRadius: new BorderRadius.circular(25.0)),
                  child: TextFormField(
                    decoration: InputDecoration.collapsed(hintText: '搜索', hintStyle: AllpassTextUI.hintTextStyle),
                    controller: searchController,
                    style: AllpassTextUI.secondTitleStyleBlack,
                    onFieldSubmitted: (text) {
                      print("点击了搜索按钮：$text");
                    },
                  ),
                ),
              )
          ),
          // 密码列表
          Expanded(
            child: ListView(
                children: getCardWidgetList()
            ),
          ),
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("点击了卡片页面的增加按钮");
        },
      ),
    );
  }
}

List<Widget> getCardWidgetList() {

  return CardTestData.cardList.map((card) => CardWidget(card)).toList();
}

class CardWidget extends StatelessWidget {

  final CardBean cardBean;

  CardWidget(this.cardBean);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 70,
      //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cardBean.hashCode%2==1?Colors.blue:Colors.amberAccent,
          child: Text(
            cardBean.name.substring(0,1),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(cardBean.name),
        subtitle: Text(cardBean.ownerName),
        onTap: () {
          print("点击了卡片：" + cardBean.name);
          // 显示模态BottomSheet
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _createBottomSheet(context);
              });
        },
      ),
    );
  }

  // 点击账号弹出模态菜单
  Widget _createBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.remove_red_eye),
          title: Text("查看"),
          onTap: () {
            print("点击了卡片：" + cardBean.name + "的查看按钮");
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            print("点击了卡片：" + cardBean.name + "的编辑按钮");
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            print("复制用户名：" + cardBean.ownerName);
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制卡号"),
          onTap: () {
            print("复制卡号：" + cardBean.cardId);
          },
        )
      ],
    );
  }
}
