package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.ProjectMember;
    import org.tuskit.model.Project;

    public class ProjectMemberDelegate {
        private var _responder : IResponder;
        
        public function ProjectMemberDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createProjectMember(projectMember:ProjectMember) : void {
			ServiceUtils.send(
				"/project_members.xml",
				_responder,
				"POST",
				projectMember.toXML(),
				true);
		}
		
		public function updateProjectMember(projectMember:ProjectMember) : void {
			ServiceUtils.send(
				"/project_members/" + projectMember.id + ".xml",
                _responder,
                "PUT",
                projectMember.toUpdateObject(),
                false);
		}

		
        public function deleteProjectMember(projectMember:ProjectMember) : void {
            ServiceUtils.send(
                "/project_members/" + projectMember.id + ".xml",
                _responder,
                "DELETE");
        }
        
        public function listProjectMembers(project:Project) : void {
            ServiceUtils.send(
                "/projects/" + project.id + "/project_members.xml",
                _responder,
                "GET");
        }
    }
}