package jam.fx.frontends;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;

/**
 * Functions for playing sound(s) and music.
 *
 * play(...) - Plays a sound, or an Array of sounds. 
 * If optional `target` and `player` are specified, volume and pan are calculated according to their proximity.
 * If `sound` is a CSV string (`"s1, s2, s3"`) it will be split into an Array to either play one sound at random, 
 * or all sounds in succession, depending on the `random` value. Default is `random = true`.
 * 
 * @author Dean Andreason
 */
class SoundFE
{
	/** The maximum distance from the target that sound will be heard when calculating sound proximity. Default is the distance from screens opposite corners. */
	public var range:Float = 0;

	/** If the sound played since this value (in milliseconds) we will skip it preventing sounds from playing twice ~ the same time. */
	static inline var SOUND_PREVENT_DELAY:Int = 30;

	/** Size we let the soundMap grow before clearing sounds older than `SOUND_PREVENT_DELAY`. Set to 0 to never clear it. */
	static inline var SOUNDMAP_CLEAR_SIZE:Int = 20;

	/** Keep track of sounds and time they played so we can avoid the same sound playing at ~ the same time. */
	var soundMap:Map<String, Float> = new Map<String, Float>();

	/**
	* Functions for playing sounds and music.
	* @param range   The furthest distance from target to player that sound will be heard. Default is the distance from screens opposite corners.
	*/
	public function new(?range:Float)
	{
		if (range != null)
		{
			this.range = range;
		}
		else
		{
		//	this.range = FlxPoint.get(0, 0).distanceTo(FlxPoint.get(FlxG.width, FlxG.height));
			var p1 = FlxPoint.get(0, 0);
			var p2 = FlxPoint.get(FlxG.width, FlxG.height);
			this.range = p1.distanceTo(p2);
			p1.put();
			p2.put();
		}
	}

	/**
	 * Plays a sound, or an Array of sounds. If `sound` is a CSV string (`"s1, s2, s3"`) it will be split into an Array and will either be played in succession, or if `random = true`, one random sound from the array is played. If optional `target` and `player` are specified the volume and pan are calculated according to their proximity.
	 * @param sound         The sound(s) to play. If sound is specified as CSV `"sound1, sound2, sound3"`, it will be turned into an Array and, depending on the `random` argument, will either play all sounds in succession, or play one random sound from the array.
	 * @param volume        The volume of the sound (before proximity calculation, if proximity is used).
	 * @param target        Optional target `FlxObject` that sound comes from. If `null`, proximity is ignored.
	 * @param player        Optional player `FlxObject` that sound is heard by. If `null`, proximity is ignored.
	 * @param random        If `sound` is a CSV and `random == true`, a random sound is played. If `false`, all sounds are played in succession. Default is `true` (random).
	 * @param looped        Whether to loop the sound. Default is `false`.
	 * @param group         Optional soundGroup to add the sounds to. Default is `FlxG.sound.defaultSoundGroup`.
	 * @param autoDestroy   Whether to destroy the sound when finished playing. Default is `true`.
	 * @param onComplete    Optional function to call when the sound completes.
	 * @return The FlxSound object, or `null` if the sound is not played when out of range when using proximity.
	 */
	public function play(sound:String, volume:Float = 1, ?target:FlxObject, ?player:FlxObject, random:Bool = true, looped:Bool = false, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void->Void):FlxSound
	{
		// If the sound is a CSV string, turn it into an Array.
		if (sound.indexOf(",") > 0)
		{
			// Create the sounds Array.
			var sounds = sound.split(",");

			// Trim the sounds ends in case there are spaces.
			for (i in 0...sounds.length)
			{
				sounds[i] = StringTools.trim(sounds[i]);
			}

			if (random)
			{
				// If random == true, play and return a random sound from the sounds Array.
				return play(sounds[FlxG.random.int(0, sounds.length - 1)], volume, target, player, false, looped, group, autoDestroy, onComplete);
			}
			else
			{
				// If random == false, play all sounds in succession.
				playSounds(sounds, volume, target, player, group, autoDestroy, onComplete);
				return null;
			}
		}

		// Check if sound was just played at ~ this same time and skip it if it was.
		if (justPlayed(sound))
		{
			return null;
		}

		// If either target or player are null there is no proximity, so just play the sound.
		if (target == null || player == null)
		{
			return FlxG.sound.play(sound, volume, looped, group, autoDestroy, onComplete);
		}

		// If we get this far we create two points used for proximity calculations.
		var targetPoint = target.getMidpoint(FlxPoint.get());
		var playerPoint = player.getMidpoint(FlxPoint.get());

		// Get the distance from player to target.
		var distance = playerPoint.distanceTo(targetPoint);

		// If out of range we don't play the sound, so put() the points back and return.
		if (distance > range)
		{
			targetPoint.put();
			playerPoint.put();

			return null;
		}

		// Calculate the proximity volume and pan.
		var vol = FlxMath.bound(1 - (distance / range), 0, 1) * volume;
		var pan = FlxMath.bound(distance / range, 0, 1);

		// Set pan to left or right.
		if (playerPoint.x > targetPoint.x) pan = -pan;

		// Put the points back into the pool.
		targetPoint.put();
		playerPoint.put();

		// Load the sound.
		var soundObj = FlxG.sound.load(sound, vol, looped, group, autoDestroy, false, null, onComplete);

		// Set the pan and play the sound.
		soundObj.pan = pan;
		soundObj.play(true);

		// Return the sound instance.
		return soundObj;
	}

	/**
	 * Play an array of sounds, one after another.
	 * @param sounds        Array of sounds to be played in succession.
	 * @param volume        Volume of the sounds.
	 * @param target        Optional target object that the sound is coming from. If null, proximity will be ignored.
	 * @param player        Optional player object that sound is heard by. If null, proximity will be ignored.
	 * @param group         Optional soundGroup to add the sounds to. Default is the default soundGroup.
	 * @param autoDestroy   Whether to destroy the sound when finished playing. Default is false.
	 * @param onComplete    Optional function to call after the last sound completes.
	 * @param index         Gets incremented in this recursive function to play the next sound in the array.
	 */
	public function playSounds(sounds:Array<String>, volume:Float = 1.0, ?target:FlxObject, ?player:FlxObject, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void->Void, index:Int = 0):Void
	{
		// Check if all sounds have played.
		if (index < sounds.length)
		{
			// Play the next sound with play(), passing the onColmplete function to call this function for the next sound.
			play(sounds[index], volume, target, player, false, false, group, autoDestroy, function() { playSounds(sounds, volume, target, player, group, autoDestroy, onComplete, index + 1);});
		}
		else if (onComplete != null)
		{
			// Call onComplete after all sounds have played.
			onComplete();
		}
	}

	/**
	 * Play music. Same as `FlxG.sound.playMusic(music, volume, looped, group)`. (wrapped here for convenience)
	 * @param sound    The sound file you want to loop in the background.
	 * @param volume   How loud the sound should be, from 0 to 1. Default is `1`.
	 * @param looped   Whether to loop this music. Default is `true`.
	 * @param group    Optional group to add this sound to. Default is `FlxG.sound.defaultMusicGroup`.
	 */
	public function playMusic(music:String, volume:Float = 1, looped:Bool = true, ?group:FlxSoundGroup):Void
	{
		FlxG.sound.playMusic(music, volume, looped, group);
	}

	/**
	 * Check if a sound has just played within the SOUND_PREVENT_DELAY to prevent playing twice ~ same time.
	 * @param sound   The sound to check if it just played.
	 * @return Whether this sound just played, `true` or `false`.
	 */
	private function justPlayed(sound:String):Bool
	{
		#if (flash || js)
		var now:Float = Date.now().getTime();
		#else
		var now:Float = Sys.time() * 1000;
		#end

		if (SOUNDMAP_CLEAR_SIZE > 0 && Lambda.count(soundMap) >= SOUNDMAP_CLEAR_SIZE)
		{
			clearSoundMap();
		}

		if (soundMap[sound] >= now - SOUND_PREVENT_DELAY)
		{
			return true;
		}

		soundMap[sound] = now;

		return false;
	}

	/**
	 * Called when soundMap reaches `SOUNDMAP_CLEAR_SIZE` and removes sounds older than `SOUND_PREVENT_DELAY` to keep the size down.
	 */
	public function clearSoundMap():Void
	{
		// Get the time.
		#if (flash || js)
		var now:Float = Date.now().getTime();
		#else
		var now:Float = Sys.time() * 1000;
		#end

		// Remove sounds older than `SOUND_PREVENT_DELAY`.
		for (key in soundMap.keys())
		{
			if (soundMap[key] < now - SOUND_PREVENT_DELAY)
			{
				soundMap.remove(key);
			}
		}
	}
}
