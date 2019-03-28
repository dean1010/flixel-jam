package jam.fx.particles;

import flixel.effects.particles.FlxParticle;

class Particle extends FlxParticle
{
	public var onKill:Void->Void;

	public function new(?onKill:Void->Void)
	{
		super();

		this.onKill = onKill;
	}

	override public function kill():Void
	{
		super.kill();

		if (onKill != null) onKill();
	}
}
