

package lib {
	import mx.formatters.DateFormatter;
	public class TuskitLib {
		public static const MSEC_PER_MINUTE:int = 1000 * 60;
		public static const MSEC_PER_HOUR:int = 1000 * 60 * 60;
		public static const MSEC_PER_DAY:int = 1000 * 60 * 60 * 24;
		
		
		/**
		 * Changes id with 0 value to null value
		 **/
		public static function nullifyId(id:int):Object {
			return (id == 0 || id is null) ? null : id;
		}
		
		/**
		 *  Prepares object id for insertion into XML
		 **/
		 public static function idToXml(id:int):String {
		 	return (id == 0 || id is null) ? '' : id as String;
		 }
		
		/**
		 * Converts xml date string to Date
		 **/
		public static function fromXmlDate(xmlDate:String):Date {
			var retval:Date;
			if (xmlDate == '') return null;
			xmlDate = xmlDate.replace(RegExp(/T.*$/), '');
			var d:Array = xmlDate.split("-");
			retval = new Date(d[0],d[1] -1,d[2]);
			return retval;
		}
		
		/**
		 * Returns number of days, hours or minutes between two dates.
		 **/
		public static function subtractDates(type:String, date1:Date, date2:Date):int {
			var types:Object = {'minutes':MSEC_PER_MINUTE, 'hours':MSEC_PER_HOUR, 'days':MSEC_PER_DAY}
			var diff:Number = date1.valueOf() - date2.valueOf();
			return int(diff/types[type]);
		}
		
		
		/**
		 * Converts xml string to Boolean
		 **/
		public static function fromXmlBoolean(xmlBoolean:XMLList):Boolean {
			if (xmlBoolean.toString() == 'true') return true;
			return false;
		}
		
		/**
		 * Sorts a 'numeric' string that starts with a number:  345 days, 54 weeks, etc
		 * Valid to pass to SetCompareFunction
		 * @return Values expected for SetCompareFunction.
		 */
		public static function sortNumericString(str1:String, str2:String):int {	
			var re:RegExp = new RegExp("^\\s*\\d+\\s");
			var value1:Number = (str1 == '' || str1 == null || !re.test(str1)) ? 0 : new Number(re.exec(str1).toString());
			var value2:Number = (str2 == '' || str2 == null || !re.test(str2)) ? 0 : new Number(re.exec(str2).toString());
			if (value1 < value2) {
				return -1;
			} else if (value1 > value2) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function dateToString(aDate:Date):String {
			if (aDate == null) return '';
			var df:DateFormatter = new DateFormatter;
			df.formatString="MM/DD/YYYY";
			return df.format(aDate);
		}
		
	}
}