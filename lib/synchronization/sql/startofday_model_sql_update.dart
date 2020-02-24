/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 18:26

class StartOfDayModelSqlUpdate {
  static const String DSD_T_DayTimeTracking_Sql_Update =
  ''' 

		UPDATE 	DSD_T_DayTimeTracking SET dirty = ?
		WHERE  	id UPLOAD_UNIQUE_ID_VALUES_MARK
				AND dirty != '1' AND dirty != '2'
				
  ''';

  static const String DSD_T_TruckCheckResult_Sql_Update =
  ''' 

		UPDATE 	DSD_T_TruckCheckResult SET dirty = ?
		WHERE  	dirty != '1' AND dirty != '2'
				
  ''';


}