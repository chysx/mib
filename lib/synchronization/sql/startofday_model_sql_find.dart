/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 18:25

class StartOfDayModelSqlFind {
  static const String DSD_T_DayTimeTracking_Sql_Find =
  ''' 

		SELECT Id,
		   WorkDate,
		   UserCode,
		   TruckId,
		   TrackingTime,
		   TrackingType,
		   Longitude,
		   Latitude,
		   Odometer,
		   CreateTime
		FROM   	DSD_T_DayTimeTracking
		WHERE  	id UPLOAD_UNIQUE_ID_VALUES_MARK
				AND dirty != '1' AND dirty != '2'
				
  ''';

  static const String DSD_T_TruckCheckResult_Sql_Find =
  ''' 


		SELECT DayTrackingId,
		   DetailNo,
		   CheckItemId,
		   CheckResult,
		   CreateTime
		FROM   	DSD_T_TruckCheckResult
		WHERE  	dirty != '1' AND dirty != '2'
				
  ''';

}