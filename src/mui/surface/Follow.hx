package mui.surface;

import mui.surface.SurfaceDecl;

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
		Follow `decl`, handing each fresh snapshot to `publish` as JSON.

		A thin adapter over `nui.Follow`, which owns the mechanism because what
		is followed is a tree of `nui.Node` and what comes out is a `Snapshot`.
		What this layer adds is the surface model's own two things: pulling the
		content thunk out of a `SurfaceDecl`, and turning a `mui.View` into a
		`nui.Node` through the register each backend signs.

		Returns `null` for a declaration that carries no tree — a command set
		has no picture to keep current.
	**/
	public static function surface(decl:SurfaceDecl, publish:String->Void, publishFirst:Bool = true):Null<Follower> {
		var content = switch (decl) {
			case Tree(_, _, c): c;
			case _: null;
		}
		if (content == null) return null;

		return new Follower(nui.Follow.tree(
			() -> {
				var describe = Describe.impl;
				if (describe == null) {
					// The backend signs this register in its `mui.App`
					// constructor, so a null here means the surface is being
					// followed before the application exists. An empty group
					// rather than a crash inside the effect: the far side draws
					// nothing, which is degradation, and the word above says why.
					trace("mui.surface.Follow: no describer installed; the surface cannot be sampled");
					return new nui.Node("VStack");
				}
				return describe(content());
			},
			snap -> publish(haxe.Json.stringify(snap)),
			publishFirst
		));
	}
}

/**
	A followed surface, seen by a backend.

	Thin on purpose: it holds a `nui.Follow.Follower` and differs from it in
	one respect, which is the reason it exists rather than being a typedef.
	`nui` deals in `SnapshotNode`, because a snapshot is what its projection
	produces and `nui` has no opinion about where it goes. A **surface**
	crosses a boundary — a process, a container, a wire — and what crosses is
	JSON. So the picture is a `String` at this level, both on the way out
	through `publish` and here on demand, and no backend writes that
	conversion twice.
**/
class Follower {
	final inner:nui.Follow.Follower;

	public function new(inner:nui.Follow.Follower) {
		this.inner = inner;
	}

	/** The picture right now, without waiting for a write. For a host that
		pulls — Android's widget asks rather than being handed. **/
	public function sampleNow():String {
		return haxe.Json.stringify(inner.sampleNow());
	}

	/** Run what a tap names, against the table this follower filled. **/
	public function invoke(id:Int, ?arg:String):Void {
		inner.invoke(id, arg);
	}

	/** Stop following, and release what the effect held. **/
	public function dispose():Void {
		inner.dispose();
	}
}
