import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/pages/card/view_and_edit_card_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/widgets/search_button_widget.dart';
import 'package:allpass/provider/card_list.dart';

/// 卡片页面
class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    return _CardPageState();
  }
}

class _CardPageState extends State<CardPage> with AutomaticKeepAliveClientMixin {
  CardDao cardDao = CardDao();

  CardList _cardList; // 所有的PasswordBean
  List<Widget> _cardWidgetList = List(); // 列表

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;


  // 查询
  Future<Null> _query() async {
    await Provider.of<CardList>(context).init();
    _getCardWidgetList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "卡片",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          // 搜索框 按钮
          SearchButtonWidget(_searchPress),
          // 卡片列表
          FutureBuilder(
            future: _getCardWidgetList(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _query,
                      child: ListView.builder(
                        itemBuilder: (context, index) => _cardWidgetList[index],
                        itemCount: _cardWidgetList.length,
                      ),
                    ),
                  );
                default:
                  return Center(
                    child: Text("未知状态，请联系开发者：sys6511@126.com"),
                  );
              }
            },
          )
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          var newData = CardBean(ownerName: "", cardId: "", folder: "默认");
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewAndEditCardPage(newData, "添加卡片", false)))
              .then((resData) {
            if (resData != null) {
              Provider.of<CardList>(context).insertCard(resData);
            }
          });
        },
      ),
    );
  }

  Future<Null> _getCardWidgetList() async {
    _cardWidgetList.clear();
    for (var item in Provider.of<CardList>(context).cardList) {
      _cardWidgetList.add(_getCardWidget(item));
    }
    if (_cardWidgetList.length == 0) {
      _cardWidgetList.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("什么也没有，赶快添加吧"),
          )
        ],
      ));
    }
  }

  Widget _getCardWidget(CardBean cardBean) {
    return SizedBox(
        height: 100,
        //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
        child: GestureDetector(
          onTap: () {
            // 显示模态BottomSheet
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _createBottomSheet(context, cardBean);
                });
          },
          onLongPress: () async {
            Clipboard.setData(ClipboardData(text: cardBean.cardId));
            Fluttertoast.showToast(msg: "已复制卡号");
          },
          child: Card(
            elevation: 2,
            color: getRandomColor(cardBean.uniqueKey),
            margin: AllpassEdgeInsets.forCardInset,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: ListTile(
              title: Text(
                cardBean.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "ID: ${cardBean.cardId}",
                style:
                TextStyle(color: Colors.white, letterSpacing: 1, height: 1.7),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              contentPadding: EdgeInsets.only(left: 30, right: 30, top: 4),
            ),
          ),
        )
    );
  }

  // 点击卡片弹出模态菜单
  Widget _createBottomSheet(BuildContext context, CardBean cardBean) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text("查看"),
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewAndEditCardPage(cardBean, "查看卡片", true)))
                  .then((resData) {
                if (resData != null) Provider.of<CardList>(context).updateCard(resData);
              });
            }),
        ListTile(
            leading: Icon(Icons.edit),
            title: Text("编辑"),
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewAndEditCardPage(cardBean, "编辑卡片", false)))
                  .then((resData) {
                if (resData != null) Provider.of<CardList>(context).updateCard(resData);
              });
            }),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: cardBean.ownerName));
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制卡号"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: cardBean.cardId));
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("删除卡片"),
          onTap: () => Provider.of<CardList>(context).deleteCard(cardBean),
        )
      ],
    );
  }
  _searchPress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(AllpassType.CARD)))
        .then((value) => setState(() {
      _query();
    }));
  }
}
