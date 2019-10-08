package jam.fx.frontends;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.tweens.FlxTween;

/**
 * FX frontend for playing sound(s) with `FX.sound.play(...)`. 
 * Can optionally play an array of sounds, in succession or one at random.
 * You can optionally specify the target and player to automatically calculate sound proximity for quick, one time sounds.
 * Sounds are prevented from playing the same sound at or near the same time according to `soundThreshold` time.
 */
class SoundFE
{
	/**
	 * The maximum distance from the target that sound will be heard when calculating
	 * sound proximity. Defaults to 75% of the distance from the screens opposite corners.
	 */
	public var range:Float = 0;

	/**
	 * Maximum size the soundMap will grow to before clearing sounds older than `soundThreshold`.
	 * Set to 0 to never clear it.
	 */
	public var maxSoundMapSize = 0;

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
	 * Master volume of all sounds and music that gets tweened to 0 or 1 with `fade()`.
	 */
	var fadeVolume:Float = 1;

	/**
	 * Functions for playing sounds and music.
	 * @param range Optional furthest distance from target to player that sound will be heard when 
	 *              calculating sound proximity if target and player are specified.
	 *              Defaults to 75% the distance from the screens opposite corners if left `null`.
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
			this.range = p1.distanceTo(p2) * 0.75;
			p1.put();
			p2.put();
		}
	}

	/**
	 * Plays a sound with optional sound proximity.
	 * If optional `target` and `player` are specified the volume and pan are calculated according to their proximity. 
	 * WARNING - WILL RETURN `null` IF OUT OF RANGE!
	 * @param sound       The sound id to play.
	 * @param volume      The volume of the sound (before proximity calculation, if proximity is used).
	 * @param target      Optional target `FlxObject` that sound comes from. If `null`, proximity is ignored.
	 * @param player      Optional player `FlxObject` that sound is heard by. If `null`, proximity is ignored.
	 * @param looped      Whether to loop the sound. Default is `false`.
	 * @param group       Optional soundGroup to add the sounds to. Default is `FlxG.sound.defaultSoundGroup`.
	 * @param autoDestroy Whether to destroy the sound when finished playing. Default is `true`.
	 * @param onComplete  Optional function to call when the sound completes.
	 * @return The FlxSound object, or `null` if the sound is not played if out of range when using proximity.
	 */
	public function play(sound:FlxSoundAsset, volume:Float = 1, ?target:FlxObject, ?player:FlxObject, looped:Bool = false, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void->Void):FlxSound
	{
		if (!looped && justPlayed(sound) && onComplete == null)
		{
			return null;
		}

		volume *= fadeVolume;

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

			if (onComplete != null)
				return FlxG.sound.play(sound, 0, looped, group, autoDestroy, onComplete);
			else
				return null;
		}

		var vol = FlxMath.bound(1 - (distance / range), 0, 1) * volume;
		var pan = FlxMath.bound(distance / range, 0, 1);

		if (playerPoint.x > targetPoint.x) pan = -pan;

		targetPoint.put();
		playerPoint.put();

		var soundObj = FlxG.sound.load(sound, vol, looped, group, autoDestroy, false, null, onComplete);

		soundObj.pan = pan;

		return soundObj.play(true);
	}

	/**
	 * Play an array of sounds in succession.
	 * @param sounds      Array of sounds to be played in succession.
	 * @param volume      Volume of the sounds.
	 * @param target      Optional target that the sound is coming from. If null, proximity is ignored.
	 * @param player      Optional player that sound is heard by. If null, proximity is ignored.
	 * @param group       Optional soundGroup to add the sounds to. Default is the default soundGroup.
	 * @param autoDestroy Whether to destroy the sound when finished playing. Default is false.
	 * @param onComplete  Optional function to call after the last sound completes.
	 * @param index       Gets incremented in this recursive function to play the next sound in the array.
	 */
	public function playSounds(sounds:Array<FlxSoundAsset>, volume:Float = 1.0, ?target:FlxObject, ?player:FlxObject, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void->Void, index:Int = 0):Void
	{
		volume *= fadeVolume;

		if (index < sounds.length)
		{
			play(sounds[index], volume, target, player, false, group, autoDestroy, function()
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
	 * Play music. Same as `FlxG.sound.playMusic(music, volume, looped, group)` but returns the music id.
	 * @param sound  The sound file you want to loop in the background.
	 * @param volume How loud the sound should be, from 0 to 1. Default is `1`.
	 * @param looped Whether to loop this music. Default is `true`.
	 * @param group  Optional group to add this sound to. Default is `FlxG.sound.defaultMusicGroup`.
	 * @return Music id String.
	 */
	public function playMusic(music:String, volume:Float = 1, looped:Bool = true, ?group:FlxSoundGroup):String
	{
		volume *= fadeVolume;
		FlxG.sound.playMusic(music, volume, looped, group);
		return music;
	}

	/**
	 * Fade all sounds and music in or out. This fades the sound/music groups 
	 * and any new sounds or music started during the fade.
	 * @param fadeIn     Whether to fade in or out. Default is `false` (fade out).
	 * @param duration   Fade duration in seconds . Default is `1`.
	 * @param soundGroup Optional sound group to fade. Defaults to `FlxG.sound.defaultSoundGroup`.
	 * @param musicGroup Optional music group to fade. Defaults to `FlxG.sound.defaultMusicGroup`.
	 */
	public function fade(fadeIn:Bool = false, duration:Float = 1, ?soundGroup:FlxSoundGroup, ?musicGroup:FlxSoundGroup):Void
	{
		var sGroup = (soundGroup == null) ? FlxG.sound.defaultSoundGroup : soundGroup;
		var mGroup = (musicGroup == null) ? FlxG.sound.defaultMusicGroup : musicGroup;
		var toVolume = (fadeIn) ? 1 : 0;

		FlxTween.tween(this, { fadeVolume: toVolume }, duration);

		FlxTween.tween(sGroup, { volume: toVolume }, duration);
		FlxTween.tween(mGroup, { volume: toVolume }, duration);
	}

	/**
	 * Check if a sound has just played within the `soundThreshold` to prevent playing twice ~ same time.
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
