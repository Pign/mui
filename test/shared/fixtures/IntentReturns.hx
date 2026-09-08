import mui.App;
import mui.View;
import mui.ui.Text;

/** An intent that hands a value back: refused, a call may cross a network. **/
class IntentReturns extends App {
	@:state(shared(Watch)) var steps:Int = 0;
	@:intent(Watch) function count():Int return steps;
	override function body():View return new Text('$steps');
	static function main() {}
}
