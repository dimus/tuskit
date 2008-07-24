package org.tuskit.model
{
	import mx.collections.ArrayCollection;
	import lib.TuskitLib;
	import org.tuskit.model.TuskitModelLocator;
	import mx.controls.Alert;
	import org.tuskit.util.XMLUtils;
		
	public class Iteration
	{
		public static const UNSAVED_ID:Number = -1; 
		public static const NONE_ID:Number = 0;
		
		public static const NONE:Iteration = 
			new Iteration (null,'','',null,null,false,0.0,0.0,0.0,0,NONE_ID);
		
		public static var instCount:int = 0;
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var project:Project;
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var objectives:String;
				
		[Bindable]
		public var startDate:Date;
		
		[Bindable]
		public var endDate:Date;
				
		[Bindable]
		public var reportSent:Boolean;
		
		[Bindable]
		public var workUnits:Number;
		
		[Bindable]
		public var workUnitsReal:Number;
		
		[Bindable]
		public var dailyLoad:Number;
		
		[Bindable]
		public var tasksNumber:int;
		
		[Bindable]
		public var meetings:ArrayCollection;
		
		
		public function Iteration(
			project:Project = null,
			name:String = '',
			objectives:String = '',
			startDate:Date = null,
			endDate:Date = null,
			reportSent:Boolean = false,
			workUnits:Number=0.0,
			workUnitsReal:Number=0.0,
			dailyLoad:Number = 0.0,
			tasksNumber:int = 0,
			id:Number = UNSAVED_ID
			):void {
			
			if (project == null) project=Project.NONE;
			project.addIteration(this);		
			this.name = name;
			this.objectives = objectives;
			this.startDate = startDate;
			this.endDate = endDate;
			this.reportSent = reportSent;
			this.workUnits = workUnits;
			this.workUnitsReal = workUnitsReal;
			this.dailyLoad = dailyLoad
			this.tasksNumber = tasksNumber;
			this.id = id;
			this.meetings = new ArrayCollection([]);
		}

  		public function addMeeting(meeting:Meeting):void {
  			meeting.iteration = this;
  			for each (var m:Meeting in meetings.source) {
  				if (m.id == meeting.id) return;
  			}
  			this.meetings.addItem(meeting);
  		}
  		
  		public function removeMeeting(meeting:Meeting):void {
  			if (meeting.iteration == this) {
  				for (var i:int = 0; i< this.meetings.length; i++) {
  					if (this.meetings[i].id == meeting.id) {
  						this.meetings.removeItemAt(i);
  						meeting.iteration = Iteration.NONE;
  						break;
  					}
  				}
  			}
  		}
	
		
  		
  		/**
		 * Uglyish method to update Iteration in rails.
		 * We cannot use xml with _method=PUT, so we have to assemble 
		 * something similar to rails form
		 */
		public function	toUpdateObject():Object {
			var obj:Object = new Object();
			obj["iteration[project_id]"] = project.id;
			obj["iteration[name]"] = name;
			obj["iteration[objectives]"] = objectives;
			obj["iteration[start_date]"] = startDate;
			obj["iteration[end_date]"] = endDate;
			obj["iteration[report_sent]"] = reportSent;
			obj["iteration[work_units]"] = workUnits;
			//obj["iteration[work_units_real]"] = workUnitsReal;
			//obj["iteration[daily_load]"] = dailyLoad;
			obj["iteration[id]"] = id;
			return obj	
		}
			
			
		public function toXML():XML {
			var retval:XML = 
				<iteration>
					<project_id>{project.id}</project_id>
					<name>{name}</name>
					<objectives>{objectives}</objectives>
					<start_date>{TuskitLib.dateToString(startDate)}</start_date>
					<end_date>{TuskitLib.dateToString(endDate)}</end_date>
					<report_sent>{reportSent}</report_sent>
					<work_units>{workUnits}</work_units>
					<id>{id}</id>
				</iteration>;
			return retval;
		}

		public static function fromXML(iteration:XML):Iteration {
			var model:TuskitModelLocator = TuskitModelLocator.getInstance();
			var retval:Iteration = null;
			var projectId:int = int(iteration.project_id);
			var tasksNumber:int = int(iteration.agile_tasks_number);
			var startDate:Date = TuskitLib.fromXmlDate(iteration.start_date);
			var endDate:Date = TuskitLib.fromXmlDate(iteration.end_date);
			var reportSent:Boolean = TuskitLib.fromXmlBoolean(iteration.report_sent);
			retval = model.getIteration(iteration.id);
			if (retval == null) {
				retval = new Iteration(
					model.getProject(projectId),
					iteration.name,
					iteration.objectives,
					startDate,
					endDate,
					reportSent,
					iteration.work_units,
					iteration.work_units_real,
					iteration.daily_load,
					tasksNumber,
					iteration.id
				);
			}
			return retval;
		}
		
		[Bindable]
		public function get length():int {
			//return TuskitLib.subtractDates('days', endDate, startDate) + 1;
			return 0;
		}
		
		public function set length(length:int):void {}
		
		public function daysLeft():int {
			var today:Date = new Date();
			return TuskitLib.subtractDates('days', endDate, today);
		}
		
		public function percentComplete():Number {
			if (workUnitsReal < workUnits) {
				return workUnitsReal/workUnits * 100;
			}
			else return 100;
		}
	}
}