package jam.fx.text;

import flixel.effects.particles.FlxParticle.IFlxParticle;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.helpers.FlxRange;

/**
 * Text particle to use with TxtEmitter.
 */
class TextParticle extends FlxText implements IFlxParticle
{
	public function new(?text:String, size:Int = 8, embeddedFont:Bool = true)
	{
		super(0, 0, 0, text, size, embeddedFont);

		velocityRange = new FlxRange<FlxPoint>(FlxPoint.get(), FlxPoint.get());
		angularVelocityRange = new FlxRange<Float>(0);
		scaleRange = new FlxRange<FlxPoint>(FlxPoint.get(1, 1), FlxPoint.get(1, 1));
		alphaRange = new FlxRange<Float>(1, 1);
		colorRange = new FlxRange<FlxColor>(FlxColor.WHITE);
		dragRange = new FlxRange<FlxPoint>(FlxPoint.get(), FlxPoint.get());
		accelerationRange = new FlxRange<FlxPoint>(FlxPoint.get(), FlxPoint.get());
		elasticityRange = new FlxRange<Float>(0);

		wordWrap = false;
		exists = false;
	}

	// interface IFlxParticle
	public var lifespan:Float;
	public var age(default, null):Float;
	public var percent(default, null):Float;
	public var autoUpdateHitbox:Bool;
	public var velocityRange:FlxRange<FlxPoint>;
	public var angularVelocityRange:FlxRange<Float>;
	public var scaleRange:FlxRange<FlxPoint>;
	public var alphaRange:FlxRange<Float>;
	public var colorRange:FlxRange<FlxColor>;
	public var dragRange:FlxRange<FlxPoint>;
	public var accelerationRange:FlxRange<FlxPoint>;
	public var elasticityRange:FlxRange<Float>;
	public function onEmit():Void {}

	var delta:Float = 0;

	/**
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		if (velocityRange != null)
		{
			velocityRange.start = FlxDestroyUtil.put(velocityRange.start);
			velocityRange.end = FlxDestroyUtil.put(velocityRange.end);
			velocityRange = null;
		}
		if (scaleRange != null)
		{
			scaleRange.start = FlxDestroyUtil.put(scaleRange.start);
			scaleRange.end = FlxDestroyUtil.put(scaleRange.end);
			scaleRange = null;
		}
		if (dragRange != null)
		{
			dragRange.start = FlxDestroyUtil.put(dragRange.start);
			dragRange.end = FlxDestroyUtil.put(dragRange.end);
			dragRange = null;
		}
		if (accelerationRange != null)
		{
			accelerationRange.start = FlxDestroyUtil.put(accelerationRange.start);
			accelerationRange.end = FlxDestroyUtil.put(accelerationRange.end);
			angularVelocityRange = null;
		}

		alphaRange = null;
		colorRange = null;
		accelerationRange = null;
		elasticityRange = null;

		super.destroy();
	}

	/**
	 * The particle's main update logic. Basically updates properties if alive, based on ranged properties.
	 */
	override public function update(elapsed:Float):Void
	{
		if (age < lifespan)
		{
			age += elapsed;
		}

		if (age >= lifespan && lifespan != 0)
		{
			kill();
		}
		else
		{
			delta = elapsed / lifespan;
			percent = age / lifespan;

			if (velocityRange.active)
			{
				velocity.x += (velocityRange.end.x - velocityRange.start.x) * delta;
				velocity.y += (velocityRange.end.y - velocityRange.start.y) * delta;
			}
			var pos = getPosition();
			pos.x += velocity.x * delta;
			pos.y += velocity.y * delta;
			setPosition(pos.x, pos.y);

			if (angularVelocityRange.active)
			{
				angularVelocity += (angularVelocityRange.end - angularVelocityRange.start) * delta;
			}

			if (scaleRange.active)
			{
				scale.x += (scaleRange.end.x - scaleRange.start.x) * delta;
				scale.y += (scaleRange.end.y - scaleRange.start.y) * delta;
				if (autoUpdateHitbox) updateHitbox();
			}

			if (alphaRange.active)
			{
				alpha += (alphaRange.end - alphaRange.start) * delta;
			}

			if (colorRange.active)
			{
				color = FlxColor.interpolate(colorRange.start, colorRange.end, percent);
			}

			if (dragRange.active)
			{
				drag.x += (dragRange.end.x - dragRange.start.x) * delta;
				drag.y += (dragRange.end.y - dragRange.start.y) * delta;
			}

			if (accelerationRange.active)
			{
				acceleration.x += (accelerationRange.end.x - accelerationRange.start.x) * delta;
				acceleration.y += (accelerationRange.end.y - accelerationRange.start.y) * delta;
			}

			if (elasticityRange.active)
			{
				elasticity += (elasticityRange.end - elasticityRange.start) * delta;
			}
		}

		super.update(elapsed);
	}

	override public function reset(x:Float, y:Float):Void
	{
		super.reset(x, y);

		age = 0;
		visible = true;
	}
}
