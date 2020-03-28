import 'package:flutter/material.dart';
import 'package:wanandroidflutter/data/data_utils.dart';
import 'package:wanandroidflutter/data/model/article_data_entity.dart';
import 'package:wanandroidflutter/page/item/article_item.dart';
import 'package:wanandroidflutter/util/log_util.dart';
import 'package:wanandroidflutter/widget/refresh/refresh_page.dart';

import 'knowledge_page_data.dart';

///2020年03月26日22:53:21
///知识体系  作者的文章列表
///xfhy

class KnowledgePage extends StatefulWidget {
  static const int AUTHOR_ID = -1;

  @override
  State createState() {
    return _KnowledgePageState();
  }
}

class _KnowledgePageState extends State<KnowledgePage> with AutomaticKeepAliveClientMixin {
  int id;
  String author;

  @override
  bool get wantKeepAlive => true;

  ///构建文章item
  Widget buildArticleItem(int index, ArticleData itemData) {
    return ArticleItem(
      itemData,
      isHomeShow: false,
      isClickUser: false,
    );
  }

  Future<Map> getArticleData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 0;
    //组装一个json 方便刷新页page 那边取数据
    Map<String, dynamic> result = {"list": [], 'total': 0, 'pageIndex': pageIndex};
    if (KnowledgePage.AUTHOR_ID == id) {
      //当前是展示作者的文章
      await dataUtils.getAuthorArticleData(author, pageIndex).then(
          (ArticleDataEntity articleDataEntity) {
        if (articleDataEntity != null && articleDataEntity.datas != null) {
          //页数+1
          pageIndex++;
          result = {
            "list": articleDataEntity.datas,
            'total': articleDataEntity.total,
            'pageIndex': pageIndex,
          };
        }
      }, onError: (e) {
        LogUtil.d("发送错误 ${e.toString()}");
      });
    } else {}
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    //接收传递过来的参数
    KnowledgePageData pageData = ModalRoute.of(context).settings.arguments as KnowledgePageData;
    id = pageData.id;
    author = pageData.author;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          author,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshPage(
              requestApi: getArticleData,
              renderItem: buildArticleItem,
            ),
          ),
        ],
      ),
    );
  }
}