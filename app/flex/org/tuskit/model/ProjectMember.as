package org.tuskit.model {
	import flash.display.InteractiveObject;
	import lib.TuskitLib;
	import mx.controls.Alert;
	
	public class ProjectMember {
		public static const UNSAVED_ID:int = -1;
				
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var project:Project;

		[Bindable]
		public var user:User;
		
		[Bindable]
		public var active:Boolean;
		
		[Bindable]
		public var sendIterationReport:Boolean;
				
		public function ProjectMember(
			project:Project = null,
			user:User = null,
			active:Boolean = false,
			sendIterationReport:Boolean = false,
			id:int = UNSAVED_ID
			):void {
			
			this.id = id;
			
			if (project == null) project = Project.NONE;
			project.addProjectMember(this);

			if (user == null) user = User.NONE;
			user.addProjectMember(this);
			
			this.active = active;
			this.sendIterationReport = sendIterationReport;
		}
		
		public function	toUpdateObject():Object {
			var obj:Object = new Object();
			obj["project_member[active]"] = active;
			obj["project_member[send_iteration_report]"] = sendIterationReport;
			obj["project[id]"] = id;
			return obj	
		}
			
		
		public function toXML():XML {
			var retval:XML = 
				<project_member>
					<project_id>{this.project.id}</project_id>
					<user_id>{this.user.id}</user_id>
					<active>{this.active.toString()}</active>
					<send_iteration_report>{this.sendIterationReport.toString()}</send_iteration_report>
				</project_member>;
			return retval;	
		}	
		
		public static function fromXML(projectMember:XML):ProjectMember {
			var model:TuskitModelLocator = TuskitModelLocator.getInstance();
			var retval:ProjectMember = null;
			var project:Project = model.getProject(projectMember.project_id);
			var user:User = model.getUser(projectMember.user_id);
			if (project != null) {
				retval = project.getProjectMember(projectMember.id);
			}
			if (retval == null) {
				retval = new ProjectMember (
					project,
					user,
					TuskitLib.fromXmlBoolean(projectMember.active),
					TuskitLib.fromXmlBoolean(projectMember.send_iteration_report),
					projectMember.id
				);
			}
			return retval; 
		}
	}
}