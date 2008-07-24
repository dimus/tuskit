package org.tuskit.components.developer_box {
	import com.adobe.cairngorm.model.ModelLocator;
	import org.tuskit.model.User;
	import org.tuskit.model.Project;
	import mx.collections.ArrayCollection;
	import org.tuskit.model.Iteration;
	
	[Bindable]
	public class DeveloperState implements ModelLocator {
		public const PROJECT_INFO:int = 0;
		public const PROJECT_MEMBERS:int = 1;
		public const PROJECT_ITERATIONS:int = 2;
		public const PROJECT_TRACKER:int = 3;
		public const PROJECT_EXTERNAL_TASKS:int = 4;
		
		
		//used to find correct location for newly created projectView tab	
		public var currentProject:Project;
		public var currentProjectLocation:int = PROJECT_INFO;
		public var currentIteration:Iteration = Iteration.NONE;
		
		// we use this variable instead of event to trigger
		//creation of a new projet tab in the parent (DeveloperBox) 
		//it is toggled between 0 and 1
		public var triggerNewProjectTab:int = 0;
        
        //
        //Singleton stuff
        //
        private static var _developerState:DeveloperState;

        public static function getInstance():DeveloperState {
            if (_developerState == null) {
                _developerState = new DeveloperState();
            }
            return _developerState;
        }
        
        //The constructor should be private, but this is not possible in
        //ActionScript 3.0.  So, throwing an Error if a second
        //TuskitModelLocator is created is the best we can do to implement
        //the Singleton pattern.
        public function DeveloperState() {
            if (_developerState != null) {
                throw new Error(
                  "Only one TuskitModelLocator instance may be instantiated.");
            }
        }
	}
}
