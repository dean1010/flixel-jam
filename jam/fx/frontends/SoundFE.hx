package jam.fx.frontends;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;

/**
 * FX frontend for playing sound(s) with `FX.sound.play(...)`. 
 * Can optionally play an array of sounds, in succession or one at random.
 * Can optionally specify target and player to automatically calculate sound proximity.
 * Sounds are prevented from playing the same sound at the same time.
 */
class SoundFE
{
	/**
	 * The maximum distance from the target that sound will be heard when calculating
	 * sound proximity. Defaults to the distance from the screens opposite corners.
	 */
	public var range:Float = 0;

	/**
	 * Maximum size the soundMap will grow to before clearing sounds older than `soundThreshold`.
	 * Set to 0 to never clear it.
	 */
	public var maxSoundMapSize = 20;

	/**
	 * If the sound played since this value (in milliseconds) it will be skipped, preventing
	 * the same sound from playing twice at ~ the same time.
	 */
	public var soundThreshold:Int = 30;

	/**
	 * Keep track of sounds and time they played to avoid the same sound playing ~ the same time.
	 */
	var soundMap:Map<String, Float> = new Map<String, Float>();

	/**
	 * Functions for playing sounds and music.
	 * @param range The furthest distance from target to player that sound will be heard 
	 *              when calculating sound proximity if target and player are specified.
	 *              Defaults to the distance from the screens opposite corners.
	 */
	public function new(?range:Float)
	{
		if (range != null)
		{
			this.range = range;
		}
		else
		{
			var p1 = FlxPoint.get(0, 0);
			var p2 = FlxPoint.get(FlxG.width, FlxG.height);
			this.range = p1.distanceTo(p2);
			p1.put();
			p2.put();
		}
	}

	/**
	 * Plays a sound, or an Array of sounds.
	 * If `sound` is a CSV string (`"s1, s2, s3"`) it will be split into an Array and will either be played
	 * in succession, or if `random = true`, one random sound from the array is played. If optional `target`
	 * and `player` are specified the volume and pan are calculated according to their proximity.
	 * @param sound       The sound(s) to play.
	 * @param volume      The volume of the sound (before proximity calculation, if proximity is used).
	 * @param target      Optional target `FlxObject` that sound comes from. If `null`, proximity is ignored.
	 * @param player      Optional player `FlxObject` that sound is heard by. If `null`, proximity is ignored.
	 * @param random      Ignored unless `sound` is a CSV. `false` plays all in succession. Default is `true`.
	 * @param looped      Whether to loop the sound. Default is `false`.
	 * @param group       Optional soundGroup to add the sounds to. Default is `FlxG.sound.defaultSoundGroup`.
	 * @param autoDestroy Whether to destroy the sound when finished playing. Default is `true`.
	 * @param onComplete  Optional function to call when the sound completes.
	 * @return The FlxSound object, or `null` if the sound is not played when out of range when using proximity.
	 */
	public function play(sound:String, volume:Float = 1, ?target:FlxObject, ?player:FlxObject, random:Bool = true, looped:Bool = false, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void->Void):FlxSound
	{
		if (sound.indexOf(",") > 0)
		{
			var sounds = sound.split(",");

			for (i in 0...sounds.length)
			{
				sounds[i] = StringTools.trim(sounds[i]);
			}

			if (random)
			{
				var i = FlxG.random.int(0, sounds.length - 1);
				return play(sounds[i], volume, target, player, false, looped, group, autoDestroy, onComplete);
			}
			else
			{
				playSounds(sounds, volume, target, player, group, autoDestroy, onComplete);
				return null;
			}
		}

		if (justPlayed(sound))
		{
			return null;
		}

		if (target == null || player == null)
		{
			return FlxG.sound.play(sound, volume, looped, group, autoDestroy, onComplete);
		}

		var targetPoint = target.getMidpoint(FlxPoint.get());
		var playerPoint = player.getMidpoint(FlxPoint.get());

		var distance = playerPoint.distanceTo(targetPoint);

		if (distance > range)
		{
			targetPoint.put();
			playerPoint.put();

			return null;
		}

		var vol = FlxMath.bound(1 - (distance / range), 0, 1) * volume;
		var pan = FlxMath.bound(distance / range, 0, 1);

		if (playerPoint.x > targetPoint.x) pan = -pan;

		targetPoint.put();
		playerPoint.put();

		var soundObj = FlxG.sound.load(sound, vol, looped, group, autoDestroy, false, null, onComplete);

		soundObj.pan = pan;
		soundObj.play(true);

		return soundObj;
	}

	/**
	 * Play an array of sounds in succession, or one at random.
	 * @param sounds      Array of sounds to be played in succession.
	 * @param volume      Volume of the sounds.
	 * @param target      Optional target object that the sound is coming from. If null, proximity is ignored.
	 * @param player      Optional player object that sound is heard by. If null, proximity is ignored.
	 * @param group       Optional soundGroup to add the sounds to. Default is the default soundGroup.
	 * @param autoDestroy Whether to destroy the sound when finished playing. Default is false.
	 * @param onComplete  Optional function to call after the last sound completes.
	 * @param index       Gets incremented in this recursive function to play the next sound in the array.
	 */
	public function playSounds(sounds:Array<String>, volume:Float = 1.0, ?target:FlxObject, ?player:FlxObject, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void->Void, index:Int = 0):Void
	{
		if (index < sounds.length)
		{
			play(sounds[index], volume, target, player, false, false, group, autoDestroy, function()
			{
				playSounds(sounds, volume, target, player, group, autoDestroy, onComplete, index + 1);
			});
		}
		else if (onComplete != null)
		{
			onComplete();
		}
	}

	/**
	 * Play music. Same as `FlxG.sound.playMusic(music, volume, looped, group)`.
	 * @param sound  The sound file you want to loop in the background.
	 * @param volume How loud the sound should be, from 0 to 1. Default is `1`.
	 * @param looped Whether to loop this music. Default is `true`.
	 * @param group  Optional group to add this sound to. Default is `FlxG.sound.defaultMusicGroup`.
	 */
	public function playMusic(music:String, volume:Float = 1, looped:Bool = true, ?group:FlxSoundGroup):Void
	{
		FlxG.sound.playMusic(music, volume, looped, group);
	}

	/**
	 * Check if a sound has just played within the soundThreshold to prevent playing twice ~ same time.
	 * @param sound The sound to check if it just played.
	 * @return Whether this sound just played, `true` or `false`.
	 */
	private function justPlayed(sound:String):Bool
	{
		#if (flash || js)
		var now:Float = Date.now().getTime();
		#else
		var now:Float = Sys.time() * 1000;
		#end

		if (maxSoundMapSize > 0 && Lambda.count(soundMap) >= maxSoundMapSize)
		{
			clearSoundMap();
		}

		if (soundMap[sound] >= now - soundThreshold)
		{
			return true;
		}

		soundMap[sound] = now;

		return false;
	}

	/**
	 * Clear the soundMap removing all sounds older than `soundThreshold` to keep the soundMap size down.
	 * It's automatically cleared when it reaches `maxSoundMapSize` (if it's > 0), but you can use this
	 * function to clear it manually.
	 */
	public function clearSoundMap():Void
	{
		#if (flash || js)
		var now:Float = Date.now().getTime();
		#else
		var now:Float = Sys.time() * 1000;
		#end

		for (key in soundMap.keys())
		{
			if (soundMap[key] < now - soundThreshold)
			{
				soundMap.remove(key);
			}
		}
	}
}
