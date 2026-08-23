package mui.surface;

import mui.surface.SurfaceDecl;
import nui.Snapshot;
import nui.Snapshot.ActionTable;
import rui.Signal.Effect;

/**
	A snapshot surface following its own state.

	## Why this is a property of the model and not of a backend

	A snapshot surface has **no host reactivity**. A widget is drawn by another
	process on its own schedule; there is no SwiftUI and no Compose on our side
	of that boundary to hand a value to. Nobody over there will notice that a
	cell changed, so noticing is ours to do — which makes a snapshot surface
	structurally the same as a live one: it can only be an effect.

	That is true of *every* snapshot surface, on every backend, which is why
	the mechanism belongs here rather than three times over. Before this it was
	written once in `cafos` for Companion — a **transport** library owning a
	property of the surface model — and again in `sui` and once more in `aui`
	for their `Glance`. Two of those backends host both roles, so each carried
	two ways of doing one thing.

	The cost of that was not theoretical. "Should the first run publish?" is a
	real question with a real answer, and it was asked in exactly one of the
	three; the other two escape it by structure rather than by design. And
	`aui` failed to re-bind when an Activity recreation brought a new
	application instance — its widget silently stopped following — a question
	`cafos` had never had to face and `sui` faces differently.

	## What a backend still owns

	One thing: **what to do with the picture**. Everything else — the effect,
	the sampling, the action table, the lifecycle, the first-run question — is
	decided here, once.

	```haxe
	follower = Follow.surface(decl, json -> publishSomehow(json));
	```

	The differences that remain are real ones, and they stay in the callback:
	`aui` throws the JSON away and nudges its host to pull for itself,
	`cafos` wraps it in a generation and sends it over a wire, `sui` writes it
	into an App Group container.

	## What this deliberately does not cover

	A surface hosted **live** — `qui` mounts the Sailfish cover and reconciles
	it, and installs an empty resampler on purpose. That is not an exception
	waiting to be tidied away: it is the other half of the model, where the
	effect both decides *and* draws. Nothing here applies to it, and flattening
	the two would lose the distinction the whole surface model rests on.
**/
class Follow {
	/**
		Follow `decl`, handing each fresh snapshot to `publish`.

		The effect evaluates the declaration's thunk; `rui` records every cell
		that thunk read; a write to any of them re-runs it. Dependencies are
		recaptured on each run, so a declaration whose branches read different
		cells is followed correctly with nothing special.

		`publishFirst` decides whether the run that starts it all also
		publishes. **An application seeding a widget at launch says yes; a
		process that woke up to service a tap says no** — what it would publish
		is its own state from before the tap, which on a two-process host
		overwrites the picture the application put there. That question is
		asked here so that it is asked once.
	**/
	public static function surface(decl:SurfaceDecl, publish:String->Void, publishFirst:Bool = true):Null<Follower> {
		var content = switch (decl) {
			case Tree(_, _, c): c;
			case _: null;
		}
		if (content == null) return null;
		return new Follower(content, publish, publishFirst);
	}
}

/**
	One followed surface: its effect, its action table, and its lifetime.

	Held by whoever started it, and disposed when that owner goes — an effect
	still watching an application that left the screen is the shape of every
	rotation bug this ecosystem has had.
**/
class Follower {
	/**
		The table is kept across samples and **never cleared between them**.

		`Snapshot.project` keys ids by PLACE, so the button in the same slot
		keeps its id from one generation to the next, and a tap that raced the
		state beat invokes the CURRENT closure rather than a hole. Clearing
		here is exactly how the first interactive Companion turned every Enter
		into a stale remote tap. Only controls that left the tree retire, which
		`project` does itself through `beginGeneration`/`sweep`.
	**/
	final table:ActionTable = new ActionTable();

	final content:() -> mui.View;
	final publish:String->Void;

	var effect:Null<Effect>;
	var seeding:Bool;

	public function new(content:() -> mui.View, publish:String->Void, publishFirst:Bool) {
		this.content = content;
		this.publish = publish;
		this.seeding = !publishFirst;
		this.effect = new Effect(run);
	}

	function run():Void {
		var describe = Describe.impl;
		if (describe == null) {
			// The backend signs this register in its `mui.App` constructor, so
			// a null here means the surface is being followed before the
			// application exists. Said, not swallowed.
			trace("mui.surface.Follow: no describer installed; the surface cannot be sampled");
			return;
		}
		var json = haxe.Json.stringify(Snapshot.project(describe(content()), table));
		if (seeding) {
			seeding = false;
			return;
		}
		publish(json);
	}

	/**
		Take a sample without waiting for a change.

		For a host that **pulls**: Android asks for the picture when it decides
		to draw, and what it gets must be current. Reading it here rather than
		re-running the effect keeps the effect's dependency set alone — a pull
		is not a change.
	**/
	public function sampleNow():Null<String> {
		var describe = Describe.impl;
		if (describe == null) return null;
		return haxe.Json.stringify(Snapshot.project(describe(content()), table));
	}

	/**
		Run what a tap names.

		An id the table has retired is answered with a word rather than a
		crash: it may legitimately name a control that left the tree between
		the picture the host kept and the user's finger.
	**/
	public function invoke(id:Int, ?arg:String):Void {
		table.invoke(id, arg);
	}

	/** Stop following. Idempotent. **/
	public function dispose():Void {
		var e = effect;
		effect = null;
		if (e != null) e.dispose();
	}
}
