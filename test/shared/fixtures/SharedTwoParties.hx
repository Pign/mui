import mui.App;
import mui.View;
import mui.ui.Text;

/** `shared` names ONE owner. **/
class SharedTwoParties extends App {
	@:state(shared(Phone, Watch)) var goal:Int = 0;
	override function body():View return new Text('$goal');
	static function main() {}
}
