import org.tuskit.components.developer_box.DeveloperState;
import mx.core.Container;
import org.tuskit.components.DeveloperBox;
import org.tuskit.components.MainBox;
import mx.controls.Alert;
import org.tuskit.model.Project;
import org.tuskit.model.Iteration;

[Bindable]
public var project:Project;

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();

