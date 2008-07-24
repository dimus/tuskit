package org.tuskit.model
{
	import mx.collections.ArrayCollection;
	import lib.TuskitLib;
	import org.tuskit.model.TuskitModelLocator;
	import mx.controls.Alert;
		
	public class Project
	{
		public static const UNSAVED_ID:Number = -1; 
		public static const NONE_ID:Number = 0;
		
		public static const NONE:Project = 
			new Project (0 ,null,'','','',null,null,14,false,0.0,NONE_ID);
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var parent:Project;
		
		[Bindable]
		public var parent_id:int;
		
		[Bindable]
		public var tracker:Tracker;
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var description:String;
		
		[Bindable]
		public var trackerProject:String;
		
		[Bindable]
		public var startDate:Date;
		
		[Bindable]
		public var endDate:Date;
		
		[Bindable]
		public var iterationLength:int;
		
		[Bindable]
		public var progressReports:Boolean;
		
		[Bindable]
		public var workUnitsReal:Number;
		
		[Bindable]
		public var children:ArrayCollection;
		
		[Bindable]
		public var iterations:ArrayCollection;
		
		[Bindable]
		public var selectedIteration:Iteration;
		
		[Bindable]
		public var projectMembers:ArrayCollection;
				
		public function Project(
			parent_id:int = 0,
			tracker:Tracker = null,
			name:String = '',
			description:String = '',
			trackerProject:String = '',
			startDate:Date = null,
			endDate:Date = null,
			iterationLength:int = 14,
			progressReports:Boolean = false,
			workUnitsReal:Number=0.0,
			id:Number = UNSAVED_ID
			):void {
			
			this.parent_id = parent_id;
			
			if (tracker == null) tracker = Tracker.NONE;
			tracker.addProject(this);
		
			this.name = name;
			this.description = description;
			this.startDate = startDate;
			this.endDate = endDate;
			this.iterationLength = iterationLength;
			this.progressReports = progressReports;
			this.workUnitsReal = workUnitsReal;
			this.id = id;
			this.children = new ArrayCollection([]);
			this.iterations = new ArrayCollection([]);	
			this.projectMembers = new ArrayCollection([]);
		}
		
		public function addChild(project:Project):void {
			project.parent = this;
			if (!this.children.contains(project)) {
            	this.children.addItem(project);
   			}
		}
		
		public function removeChild(project:Project):void {
            if (project.parent == this) {
	            for (var i:int = 0; i < this.children.length; i++) {
	                if (this.children[i].id == project.id) {
	                    this.children.removeItemAt(i);
	                    project.parent = Project.NONE;
	                    break;	
					}
				}
         	}
  		}
  		
  		public function addIteration(iteration:Iteration):void {
  			iteration.project = this;
  			for each (var i:Iteration in iterations.source) {
  				if (i.id == iteration.id) return;
  			}
  			this.iterations.addItem(iteration);
  		}
  		
  		public function removeIteration(iteration:Iteration):void {
  			if (iteration.project == this) {
  				for (var i:int = 0; i< this.iterations.length; i++) {
  					if (this.iterations[i].id == iteration.id) {
  						this.iterations.removeItemAt(i);
  						iteration.project = Project.NONE;
  						break;
  					}
  				}
  			}
  		}
		
		public function getProjectMember(projectMemberId:int):ProjectMember {
			for each (var pm:ProjectMember in projectMembers.source) {
				if (pm.id == projectMemberId) return pm;
			}
			return null
		}
		  		
  		public function addProjectMember(projectMember:ProjectMember):void {
  			if (getProjectMember(projectMember.id) == null) {
  				projectMember.project = this;
  				this.projectMembers.addItem(projectMember);
  			}
  		}
  		
  		public function removeProjectMember(projectMember:ProjectMember):void {
  			if (projectMember.project == this) {
  				for (var i:int = 0; i < this.projectMembers.length; i++) {
  					if (this.projectMembers[i].id == projectMember.id) {
  						this.projectMembers.removeItemAt(i);
  						projectMember.project = Project.NONE;
						break;
  					}
  				}
  			}
  		}
  		
  		
  		/**
		 * Uglyish method to update Tracker in rails.
		 * We cannot use xml with _method=PUT, so we have to assemble 
		 * something similar to rails form
		 */
		public function	toUpdateObject():Object {
			var obj:Object = new Object();
			obj["project[parent_id]"] = TuskitLib.idToXml(parent.id);
			obj["project[tracker_id]"] = TuskitLib.idToXml(tracker.id);
			obj["project[name]"] = name;
			obj["project[description]"] = description;
			obj["project[tracker_project]"] = trackerProject;
			obj["project[start_date]"] = startDate;
			obj["project[end_date]"] = endDate;
			obj["project[iteration_length]"] = iterationLength;
			obj["project[progress_reports]"] = progressReports;
			obj["project[id]"] = id;
			return obj	
		}
			
			
		public function toXML():XML {
			var parent_id_xml:String = TuskitLib.idToXml(parent_id);
			var tracker_id_xml:String;
			tracker_id_xml = (tracker == null) ? '':  TuskitLib.idToXml(tracker.id); 
			var retval:XML = 
				<project>
					<parent_id>{parent_id_xml}</parent_id>
					<tracker_id>{tracker_id_xml}</tracker_id>
					<name>{name}</name>
					<description>{description}</description>
					<tracker_project>{trackerProject}</tracker_project>
					<start_date>{startDate}</start_date>
					<end_date>{endDate}</end_date>
					<iteration_length>{iterationLength}</iteration_length>
					<progress_reports>{progressReports}</progress_reports>
					<id>{id}</id>
				</project>;
			return retval;
		}

		public static function fromXML(project:XML):Project {
			var model:TuskitModelLocator = TuskitModelLocator.getInstance();
			var retval:Project = null;
			var parent_id:int = int(project.parent_id);
			var tracker_id:int = int(project.tracker_id);
			var startDate:Date = TuskitLib.fromXmlDate(project.start_date);
			var endDate:Date = TuskitLib.fromXmlDate(project.end_date);
			var progressReports:Boolean = TuskitLib.fromXmlBoolean(project.progress_reports);
			retval = model.getProject(project.id);
			if (retval == null) {
				retval = new Project(
					parent_id,
					project.tracker = model.getTracker(tracker_id),
					project.name,
					project.description,
					project.tracker_project,
					startDate,
					endDate,
					project.iteration_length,
					progressReports,
					project.work_units_real,
					project.id
				);
			}
			return retval;
		}
	}
}