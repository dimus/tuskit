package org.tuskit.model {
    import com.adobe.cairngorm.model.ModelLocator;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ListCollectionView;
    import mx.collections.XMLListCollection;
    import mx.controls.Alert;
    
    import org.tuskit.control.EventNames;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.validators.ServerErrors;
    import mx.containers.Canvas;
    
    import mx.utils.UIDUtil;

    [Bindable]
    public class TuskitModelLocator implements ModelLocator {
    	
    	//Popup canvas
    	public static var popupWorld:Canvas; 
        
        //LocatorState
        public static const LOCATOR_INIT:int = 0;
        public static const LOCATOR_LOGIN:int = 1;       
        public static const LOCATOR_MAIN:int = 2;
 
		//User Groups IDs (real ids from database)
		public static const ADMIN :int = 1;
		public static const DEVELOPER :int = 2;
		public static const CUSTOMER :int = 3;
		public var currentGroupId:int = 3;
		
		//External Tasks States
		public const EXT_TASKS_ICON_EMPTY:int = 0;
		public const EXT_TASKS_ICON_FULL:int = 1;
		public const EXT_TASKS_ICON_NEW:int = 2;
		public var currentExternalTasksIcon:int = EXT_TASKS_ICON_EMPTY;
		
        //
        //Public properties
        //
        public var currentUser:User; //logged on user
        public var selectedUserId:int = -1; //id of the currently selected user
        public var currentUserGroups:ArrayCollection = new ArrayCollection([]);
        public var users:ListCollectionView = new ArrayCollection([]);
        public var groups:ListCollectionView;
        public var memberships:ListCollectionView;
        public var usersAndNone:ListCollectionView;
        public var groupsAndNone:ListCollectionView;
        public var userIDMap:Object;
        public var groupIDMap:Object;
        
        //Project related
        public var trackers:ListCollectionView;
        public var trackerIDMap:Object;
        
        public var projectIDMap:Object; 
        public var projects:ListCollectionView;
        public var projectsTree:Project = new Project(-1, null, 'All projects', 
        	'Root of the project tree','',null,null,0,false,0.0,0);
        
        //Iteration Releated
        public var currentIterations:ListCollectionView;
        
        //We dont reset iterationIDMap so it will accumulate
        //deleted members. It might become a problem at some point        
        public var iterationIDMap:Object = {};
        
        //Meeting Related
        
        //We dont reset meetingIDMap so it will accumulate
        //deleted members. It might become a problem at some point
        public var meetingIDMap:Object = {};
        public var meetingsReady:Boolean = false;
        
        
        //for server-based validation
        public var userErrors:ServerErrors;
        public var projectErrors:ServerErrors;
        public var iterationErrors:ServerErrors;
        public var meetingErrors:ServerErrors;

        public var currentLocation:int = LOCATOR_LOGIN;
        
        public var isInTransitionState:Boolean = false;
        public var hasPopupWindow:Boolean = false;
        
        //CommandCollections
        
        public var commandsArray:Array = new Array();
        
        
        public function executeCommandsArray():void {
        	var commandObject:Object;
        	for each (commandObject in commandsArray) {
        		commandObject.command.execute(commandObject.event);
        	}
        }
        
        public function commandsArrayDelete(command:Object):void {
        	var i:int = 0;
        	for (i; i< commandsArray.length; i++) {
        		if (commandsArray[i]['command'] == command)
        		commandsArray.splice(i,1);
        		break
        	}
        }
                
        // Project related functions
        
        public function getTrackersProjects():void {
        	isInTransitionState=true;
        	CairngormUtils.dispatchEvent(EventNames.LIST_TRACKERS, {toCommandsArray: true});
        	executeCommandsArray();
        }
        
        public function getProject(projectId:int):Project {
        	if (projectIDMap == null) return null;
        	return projectIDMap[projectId];
        }
        
		public function setProjects(list:XMLList):void {
			var projectsArray:Array = [];
			var item:XML;
			
			projectIDMap = {};
			projectIDMap[0] = Project.NONE;			
			for each (item in list) {
				var project:Project = Project.fromXML(item);
				projectsArray.push(project);
				projectIDMap[project.id] = project;
			}
			projects = new ArrayCollection(projectsArray);
		}

        public function setProjectsTree():void {
        	populateTree(projectsTree);
        	sortTree(projectsTree);
        }
        
        private function populateTree(aProject:Project):void {
        	var children:Array = [];
        	var project:Project;
        	aProject.children.source = [];
        	for each(project in projects) {
        		if (project.parent_id == aProject.id) children.push(project); 
        	}
        	if (children.length == 0) return;
        	for each(project in children) {
        		aProject.addChild(project);
        		populateTree(project);
        	}
        }
        
        private function sortTree(aProject:Project):void {
        	var child:Project;
        	if (aProject.children.length == 0) return;
        	aProject.children.source.sortOn('name');
        	for each (child in aProject.children.source) {
        		sortTree(child);
        	}
        }
		
        public function getTracker(trackerID:int):Tracker {
            if (trackerIDMap == null) return null;
            return trackerIDMap[trackerID];
        }
		
		public function setTrackers(list:XMLList):void {
			var trackersArray:Array = [];
			var item:XML;
			
			trackerIDMap = {};
			trackerIDMap[0] = Tracker.NONE;			
			for each (item in list) {
				var tracker:Tracker = Tracker.fromXML(item);
				trackersArray.push(tracker);
				trackerIDMap[tracker.id] = tracker;
			}
			trackers = new ArrayCollection(trackersArray);
		}
		


		// End Project related Functions
		
		
		// Project Members related functions
		public function getProjectMembers(project:Project):void {
			isInTransitionState=true;
			CairngormUtils.dispatchEvent(EventNames.LIST_PROJECT_MEMBERS, project);
		}
		
		public function setProjectMembers(list:XMLList):void{
            var item:XML;
            for each (item in list) {
                ProjectMember.fromXML(item);
            }
		}
		
		// Meetings related functions
		public function getMeetings(iteration:Iteration):void{
			meetingsReady = false;
			CairngormUtils.dispatchEvent(EventNames.LIST_MEETINGS, {iteration:iteration, toCommandArray:false});
		} 
		
		public function setMeetings(list:XMLList):void {
			var item:XML;
        	meetingIDMap[0] = Meeting.NONE;
			for each(item in list) {
				var meeting:Meeting = Meeting.fromXML(item);
				meetingIDMap[meeting.id] = meeting;
			}
		}
		
       public function getMeeting(meetingID:int):Meeting {
            if (meetingIDMap == null) return null;
            return meetingIDMap[meetingID];
        }

		// Meeting Participants related functions
		public function getMeetingParticipants(meeting:Meeting):void {
			isInTransitionState=true;
			CairngormUtils.dispatchEvent(EventNames.LIST_MEETING_PARTICIPANTS, meeting);
		}
		
		public function setMeetingParticipants(list:XMLList):void{
            var item:XML;
            for each (item in list) {
                MeetingParticipant.fromXML(item);
            }
		}
	
		
		
		// Iteration related functions
        public function setCurrentIterations(list:XMLList):void {
        	currentIterations = new ArrayCollection(setIterations(list));
        }
        
        public function setProjectIterations(project:Project):void {
        	CairngormUtils.dispatchEvent(EventNames.LIST_PROJECT_ITERATIONS, {project:project, toCommandsArray: false});
        }
        
        public function setIterations(list:XMLList):Array {
        	var iterationsArray:Array=[];
        	var item:XML;
        	//iterationIDMap = {};
        	iterationIDMap[0] = Iteration.NONE;
        	for each (item in list) {
        		var iteration:Iteration = Iteration.fromXML(item);
        		iterationsArray.push(iteration);
        		iterationIDMap[iteration.id] = iteration;
        	}
        	return iterationsArray;
        }

       public function getIteration(iterationID:int):Iteration {
            if (iterationIDMap == null) return null;
            return iterationIDMap[iterationID];
        }
        
        
        public function setStories(iteration:Iteration):void {
        	
        }
		// End Iteration related functions        

		
		public function getUsersGroupsMemberships():void {
        	isInTransitionState=true;
            CairngormUtils.dispatchEvent(EventNames.LIST_USERS, {toCommandsArray: true});
	        CairngormUtils.dispatchEvent(EventNames.LIST_GROUPS, {toCommandsArray: true});
            executeCommandsArray();
		}

		public function setMemberships(list:XMLList):void {
            var membershipsArray:Array = [];
            var item:XML;
            for each (item in list) {
                var membership:Membership = Membership.fromXML(item);
                membershipsArray.push(membership);
            }
            memberships = new ArrayCollection(membershipsArray);
		}
		
	   	public function updateMembership(membership:Membership):void {
            for (var i:int = 0; i < memberships.length; i++) {
                var ithMembership:Membership = Membership(memberships.getItemAt(i));
                if (ithMembership.id == membership.id) {
                    memberships.setItemAt(memberships, i);
                    break;
                }
            }
       	}
       
       public function removeMembership(membership:Membership):void {
            for (var i:int = 0; i < memberships.length; i++) {
                var ithMembership:Membership = Membership(memberships.getItemAt(i));
                if (ithMembership.id == membership.id) {
                    ithMembership.user.removeMembership(ithMembership);
                    ithMembership.group.removeMembership(ithMembership);
                    memberships.removeItemAt(i);
                    break;
                }
            }
        }

			
        public function setUsers(list:XMLList):void {
            userIDMap = {};
            userIDMap[0] = User.NONE;
            var usersArray:Array = [];
            var item:XML;
            for each (item in list) {
                var user:User = User.fromXML(item);
                usersArray.push(user);
                userIDMap[user.id] = user;
            }
            users = new ArrayCollection(usersArray);
            
            //get full copy of array and prepend it with empty user
            var usersAndNoneArray:Array = usersArray.slice(0);
            usersAndNoneArray.splice(0, 0, User.NONE);
            
            usersAndNone = new ArrayCollection(usersAndNoneArray);
        }
        
        public function setGroups(list:XMLList):void {
            groupIDMap = {};
            groupIDMap[0] = Group.NONE;
            var groupsArray:Array = [];
            var item:XML;
            for each (item in list) {
                var group:Group = Group.fromXML(item);
                groupsArray.push(group);
                groupIDMap[group.id] = group;
            }
            groups = new ArrayCollection(groupsArray);
            var groupsAndNoneArray:Array = groupsArray.slice(0);
            groupsAndNoneArray.splice(0, 0, Group.NONE);
            groupsAndNone = new ArrayCollection(groupsAndNoneArray);
        }
        
        public function getUser(userID:int):User {
            if (userIDMap == null) return null;
            return userIDMap[userID];
        }
    
        public function getGroup(groupID:int):Group {
            if (groupIDMap == null) return null;
            return groupIDMap[groupID];
        }

        //
        //Singleton stuff
        //
        private static var modelLocator:TuskitModelLocator;

        public static function getInstance():TuskitModelLocator {
            if (modelLocator == null) {
                modelLocator = new TuskitModelLocator();
            }
            return modelLocator;
        }
        
        //The constructor should be private, but this is not possible in
        //ActionScript 3.0.  So, throwing an Error if a second
        //TuskitModelLocator is created is the best we can do to implement
        //the Singleton pattern.
        public function TuskitModelLocator() {
            if (modelLocator != null) {
                throw new Error(
                  "Only one TuskitModelLocator instance may be instantiated.");
            }
        } 
    }
}