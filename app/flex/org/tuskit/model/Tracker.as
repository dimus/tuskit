 package org.tuskit.model {
	import mx.collections.ArrayCollection;
	
	
	public class Tracker {
		public static const UNSAVED_ID:int = -1; 
		public static const NONE_ID:int = 0;
		
		public static const NONE:Tracker = 
			new Tracker ('','','',NONE_ID);
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var application:String;
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var url:String;
		
		[Bindable]
		public var projects:ArrayCollection;
				
		public function Tracker (
			application:String = '',
			name:String = '',
			url:String = '',
			id:int = UNSAVED_ID):void {
				this.application = application;
				this.name = name;
				this.url = url;
				this.projects = new ArrayCollection([]);
			}
		
		public function addProject(project:Project):void {
			project.tracker = this;
			if (!this.projects.contains(project)) {
            	this.projects.addItem(project);
   			}
		}
		
		public function removeProject(project:Project):void {
            if (project.tracker == this) {
                for (var i:int = 0; i < this.projects.length; i++) {
                    if (this.projects[i].id == project.id) {
                        this.projects.removeItemAt(i);
                        project.tracker = null;
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
			obj["Tracker[application]"] = application;
			obj["Tracker[name]"] = name;
			obj["Tracker[url]"] = url;
			return obj
		}
			
			
		public function toXML():XML {
			var retval:XML = 
				<tracker>
					<application>{application}</application>
					<name>{name}</name>
					<url>{url}</url>
				</tracker>;
			return retval;
		}
		
		public static function fromXML(tracker:XML):Tracker {
			var retval:Tracker;
			var tracker_id:int;
			
			if (tracker.id == '') tracker_id = -1
			else tracker_id = tracker.id;
			
			retval = new Tracker(
				tracker.application,
				tracker.name,
				tracker.url,
				tracker_id
			);
			return retval
		}
					
	}
}