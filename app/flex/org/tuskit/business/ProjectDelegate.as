package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.Project;

    public class ProjectDelegate {
        private var _responder : IResponder;
        
        public function ProjectDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createProject(project:Project) : void {
			
			ServiceUtils.send(
				"/projects.xml",
				_responder,
				"POST",
				project.toXML(),
				true);
		}
		
		public function updateProject(project:Project) : void {
			ServiceUtils.send(
				"/projects/" + project.id + ".xml",
                _responder,
                "PUT",
                project.toUpdateObject(),
                false);
		}
		
        public function deleteProject(project:Project) : void {
            ServiceUtils.send(
                "/projects/" + project.id + ".xml",
                _responder,
                "DELETE");
        }

        
        public function listProjects() : void {
            ServiceUtils.send(
                "/projects.xml",
                _responder,
                "GET");
        }
        
        public function listProjectIterations(projectId:int) : void {
        	ServiceUtils.send(
        		"/projects/" + projectId.toString() + "/iterations.xml",
        		_responder,
        		"GET");
        }
    }
}