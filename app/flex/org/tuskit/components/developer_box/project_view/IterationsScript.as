
import org.tuskit.components.developer_box.DeveloperState;
import mx.core.Container;
import org.tuskit.model.Project;
import org.tuskit.model.Iteration;
import org.tuskit.model.TuskitModelLocator;

[Bindable]
public var project:Project; 


[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

public function getLocation(newSelectedIteration:Iteration):Container {
	if (newSelectedIteration != null && newSelectedIteration.id != Iteration.NONE.id) {
		_model.setStories(newSelectedIteration);
		return iterationView;
	} 
	return iterationsCollection;
}