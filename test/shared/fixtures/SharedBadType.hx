import mui.App;
import mui.View;
import mui.ui.Text;

/** A shared cell holding a list: refused, the four kinds only. **/
class SharedBadType extends App {
	@:state(shared(Phone)) var items:rui.structures.ImmutableList<String> = new rui.structures.ImmutableList();
	override function body():View return new Text('${items.length}');
	static function main() {}
}
