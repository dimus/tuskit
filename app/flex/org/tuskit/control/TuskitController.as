package org.tuskit.control {
    import com.adobe.cairngorm.control.FrontController;
    import org.tuskit.control.EventNames;
    import org.tuskit.command.*;

    public class TuskitController extends FrontController {
        public function TuskitController() {
            initializeCommands();
        }
        
        private function initializeCommands() : void {
        	addCommand(EventNames.CHECK_ADMIN_EXISTS,		CheckAdminExistsCommand);
            
            addCommand(EventNames.CREATE_ITERATION,			CreateIterationCommand);
            addCommand(EventNames.CREATE_MEETING,			CreateMeetingCommand);            
            addCommand(EventNames.CREATE_MEMBERSHIP,			CreateMembershipCommand);
            addCommand(EventNames.CREATE_PROJECT,			CreateProjectCommand);
            addCommand(EventNames.CREATE_PROJECT_MEMBER,		CreateProjectMemberCommand);
            addCommand(EventNames.CREATE_SESSION,			CreateSessionCommand);
            addCommand(EventNames.CREATE_USER, 				CreateUserCommand);
			
			//addCommand(EventNames.DELETE_MEETING,			DeleteMeetingCommand);
			addCommand(EventNames.DELETE_MEMBERSHIP,			DeleteMembershipCommand);
            addCommand(EventNames.DELETE_SESSION, 			DeleteSessionCommand);
            addCommand(EventNames.DELETE_USER, 				DeleteUserCommand);

			addCommand(EventNames.LIST_CURRENT_ITERATIONS,	ListCurrentIterationsCommand);
            addCommand(EventNames.LIST_GROUPS, 				ListGroupsCommand);
            addCommand(EventNames.LIST_MEETING_PARTICIPANTS, ListMeetingParticipantsCommand);
            addCommand(EventNames.LIST_MEETINGS, 			ListMeetingsCommand);
            addCommand(EventNames.LIST_MEMBERSHIPS, ListMembershipsCommand);
            addCommand(EventNames.LIST_PROJECTS,	ListProjectsCommand);
            addCommand(EventNames.LIST_PROJECT_ITERATIONS,	ListProjectIterationsCommand);
            addCommand(EventNames.LIST_PROJECT_MEMBERS,	ListProjectMembersCommand);
            addCommand(EventNames.LIST_TRACKERS,	ListTrackersCommand);
            addCommand(EventNames.LIST_USERS,	ListUsersCommand);
            
            //addCommand(EventNames.UPDATE_MEETING, 	UpdateMeetingCommand);
            addCommand(EventNames.UPDATE_ITERATION,	UpdateIterationCommand);
            addCommand(EventNames.UPDATE_PROJECT,	UpdateProjectCommand);
            addCommand(EventNames.UPDATE_PROJECT_MEMBER,	UpdateProjectMemberCommand);
            addCommand(EventNames.UPDATE_USER,	UpdateUserCommand);
        }
    }
}