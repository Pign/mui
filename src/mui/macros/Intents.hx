package mui.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ExprTools;
#end

/**
	`@:intent(Party)`: a method that runs on one party, whoever calls it.

	```haxe
	@:intent(Watch) function resetSteps():Void
		steps = 0;
	```

	On the watch, `resetSteps()` runs here, unserialised. On the phone the
	call is carried to the watch as `{t:"call", n:"resetSteps", o:"Watch",
	a:[]}` and runs there; if the watch cannot be reached it fails now, with
	a word, through `rui.state.Shared.onRefused`. Same signature, one
	implementation — the body is written once and the macro decides where.

	## What the macro does

	The method keeps its body under a private name, and its public name
	becomes the dispatch: `rui.state.Shared.current.call(name, owner, args,
	local)`. The class also gains `declaredIntents()`, the table
	`dui.state.Share.join` hands the registry so a call arriving by name can
	run — the same shape as `declaredSurfaces()` for `@:surface`.

	## What it refuses

	A return type other than `Void`: a call that may travel a network has no
	value to hand back synchronously, and pretending otherwise is how a
	caller waits forever. A static method: an intent runs against the
	application's state. Arguments are carried as JSON, so they are the
	four kinds a shared cell may hold — the check is the wire's, at runtime,
	and the macro says so in the generated doc rather than guess at a type.
**/
class Intents {
	#if macro
	public static function build():Array<Field> {
		var fields = Context.getBuildFields();
		var out:Array<Field> = [];
		var decls:Array<Expr> = [];

		for (f in fields) {
			var entries = [for (m in f.meta) if (m.name == ":intent") m];
			if (entries.length == 0) {
				out.push(f);
				continue;
			}
			if (entries.length > 1) {
				Context.error("One @:intent per method — a method runs on one party.", f.pos);
				out.push(f);
				continue;
			}
			var owner = partyOf(entries[0], f.pos);
			if (owner == null) {
				out.push(f);
				continue;
			}
			var fn = switch (f.kind) {
				case FFun(fn): fn;
				case _:
					Context.error("@:intent goes on a method — the method's body is what runs on the owner.", f.pos);
					out.push(f);
					continue;
			}
			if (f.access != null && f.access.contains(AStatic)) {
				Context.error('@:intent method "${f.name}" cannot be static: an intent runs against the application\'s state.', f.pos);
				out.push(f);
				continue;
			}
			if (!returnsVoid(fn)) {
				Context.error('@:intent method "${f.name}" must return Void: a call that may travel to another device has '
					+ "nothing to hand back synchronously. Write the result into a shared cell the caller reads.", f.pos);
				out.push(f);
				continue;
			}

			var name = f.name;
			var local = name + "__here";
			var pos = f.pos;

			// The body, under a private name.
			out.push({
				name: local,
				access: [APrivate],
				kind: FFun({args: fn.args, ret: fn.ret, expr: fn.expr, params: fn.params}),
				pos: pos,
				meta: [{name: ":noCompletion", params: [], pos: pos}],
				doc: 'The body of `$name()`, run where $owner is.',
			});

			// The public name: dispatch.
			var argIdents:Array<Expr> = [for (a in fn.args) macro $i{a.name}];
			var argsArray:Expr = {expr: EArrayDecl([for (a in fn.args) macro ($i{a.name} : Dynamic)]), pos: pos};
			var localCall:Expr = {expr: ECall(macro this.$local, argIdents), pos: pos};
			out.push({
				name: name,
				access: f.access == null || f.access.length == 0 ? [APublic] : f.access,
				kind: FFun({
					args: fn.args,
					ret: macro :Void,
					expr: macro rui.state.Shared.current.call($v{name}, $v{owner}, $argsArray, () -> $localCall),
					params: fn.params,
				}),
				pos: pos,
				meta: [for (m in f.meta) if (m.name != ":intent") m],
				doc: (f.doc == null ? "" : f.doc + "\n\n") + 'Runs on $owner, whoever calls it: here when this party is $owner, '
					+ "carried there otherwise. Arguments cross as JSON.",
			});

			// The table entry: a call arriving by name runs the body.
			var unpacked:Array<Expr> = [];
			for (i in 0...fn.args.length) {
				var t = fn.args[i].type;
				var e:Expr = macro a[$v{i}];
				unpacked.push(t == null ? e : {expr: ECheckType(macro cast a[$v{i}], t), pos: pos});
			}
			var run:Expr = {expr: ECall(macro this.$local, unpacked), pos: pos};
			decls.push(macro {name: $v{name}, owner: $v{owner}, run: (a:Array<Dynamic>) -> $run});
		}

		if (decls.length == 0)
			return fields;

		var list:Expr = {expr: EArrayDecl(decls), pos: Context.currentPos()};
		out.push({
			name: "declaredIntents",
			access: [APublic, AOverride],
			pos: Context.currentPos(),
			doc: "Collected from this class's @:intent methods by mui.macros.Intents.",
			kind: FFun({
				args: [],
				ret: macro :Array<rui.state.Shared.IntentDecl>,
				expr: macro return super.declaredIntents().concat($e{list}),
			}),
		});
		return out;
	}

	static function partyOf(m:MetadataEntry, pos:Position):Null<String> {
		if (m.params == null || m.params.length != 1) {
			Context.error("@:intent(Party) names ONE party — the one the method runs on.", pos);
			return null;
		}
		return switch (m.params[0].expr) {
			case EConst(CIdent(p)): p;
			case _:
				Context.error("@:intent(Party) takes an identifier, like `Watch`.", m.params[0].pos);
				null;
		}
	}

	static function returnsVoid(fn:Function):Bool {
		return switch (fn.ret) {
			case null: true; // inferred; the body is a statement or the compiler will say
			case TPath({name: "Void", pack: []}): true;
			case _: false;
		}
	}
	#end
}
