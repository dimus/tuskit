import org.tuskit.util.CairngormUtils;
import org.tuskit.control.EventNames;
import org.tuskit.model.Project;
import org.tuskit.components.developer_box.ProjectView;
[Bindable]
public var project:Project = Project.NONE;

private function updateProject():void {
	project.name = projectInfoInput.projectName.text;
	project.description = projectInfoInput.projectDescription.text;
	project.startDate = projectInfoInput.projectStartDate.selectedDate;
	project.endDate = projectInfoInput.projectEndDate.selectedDate;
	project.progressReports = projectInfoInput.projectProgressReports.selected;
	CairngormUtils.dispatchEvent(EventNames.UPDATE_PROJECT, project);
}