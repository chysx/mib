import 'package:dio/dio.dart';
import 'package:mib/log/log_util.dart';
import 'package:mib/synchronization/base/abstract_parser.dart';
import 'package:mib/synchronization/base/i_parse_policy.dart';
import 'package:mib/synchronization/bean/sync_response_bean.dart';
import 'package:mib/synchronization/sync/sync_response_status.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/7/29 16:08

class UploadParser extends AbstractParser<Response<Map<String, dynamic>>> {
  UploadParser(IParsePolicy parsePolicy) : super(parsePolicy);

  @override
  Future<bool> parse(Response<Map<String, dynamic>> response) async {
    SyncResponseBean syncDataBean = SyncResponseBean.fromJson(response.data);
    Log().logger.i('*************upload response***************\n ${syncDataBean.toJson()}');
    return syncDataBean.status == SyncResponseStatus.SUCCESS;
  }
}
