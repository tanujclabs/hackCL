using UnityEngine;
using System.Collections;

public class SoundController : MonoBehaviour {
	public static SoundController instance;
	public AudioSource drillPlayerEngine,drillPlayerBlade,drillParticlePlayer,drillParticleEnemy,drillEnemyEngine,drillEnemyBlade;
	public AudioSource ButtonSoundSource,RightTapSource,WrongTapSource;
	//public AudioClip engineCountDown, engineIdle, engineStop;
	public AudioClip[] engineSoundLevels;
	public AudioClip drillStart,drillIdle,drillStop;
	//public static bool isMusic;
	// Use this for initialization
	void Awake () 
	{
		instance = this;
	}
	
	void OnDestroy()
	{
		instance = null;
	}

	public void StartEngine(bool _loop)
	{
		upTempo (0, false);
	}

	public void StartEngineEnemy(bool _loop)
	{
		upTempoEnemy (0, false);
	}

	public void StartDrill()
	{
		drillPlayerBlade.clip = drillStart;
		drillPlayerBlade.loop = false;
		drillPlayerBlade.Play ();
		StartCoroutine (LookForIdle (drillPlayerBlade,drillIdle));
	}

	public void StartDrillEnemy()
	{
		drillEnemyBlade.clip = drillStart;
		drillEnemyBlade.loop = false;
		drillEnemyBlade.Play ();
		StartCoroutine (LookForIdle (drillEnemyBlade,drillIdle));
	}

	public void StopDrill()
	{
		drillPlayerBlade.clip = drillStop;
		drillPlayerBlade.loop = false;
		drillPlayerBlade.Play ();
	}

	public void StopDrillEnemy()
	{
		drillEnemyBlade.clip = drillStop;
		drillEnemyBlade.loop = false;
		drillEnemyBlade.Play ();
	}

	public void EngineIdle(bool _loop)
	{
//		drillPlayerEngine.clip = engineIdle;
//		drillPlayerEngine.loop = _loop;
//		drillPlayerEngine.Play ();
	}

	public void StopEngine()
	{
		upTempo (5,false);
	}

	public void StopEngineEnemy()
	{
		upTempoEnemy (5,false);
	}

	public void upTempo(int id,bool _loop)
	{

		drillPlayerEngine.loop = _loop;
		drillPlayerEngine.clip = engineSoundLevels [id];
		drillPlayerEngine.Play ();
		if (id == 5 || id == 0)
		StartCoroutine (LookForIdle (drillPlayerEngine,engineSoundLevels[1]));

	}

	public void upTempoEnemy(int id,bool _loop)
	{
		
		drillEnemyEngine.loop = _loop;
		drillEnemyEngine.clip = engineSoundLevels [id];
		drillEnemyEngine.Play ();
		if (id == 5 || id == 0)
			StartCoroutine (LookForIdle (drillEnemyEngine,engineSoundLevels[1]));
		
	}

	IEnumerator LookForIdle(AudioSource source,AudioClip _clip)
	{
		while (source!=null&&source.isPlaying)
		{
			yield return 0;
		}
		if(source!=null)
		{
		source.clip = _clip;
		source.loop = true;
		source.Play ();

		}
	}

	public void SetMusicEnable(bool isMusic)
	{
		AudioSource[] sources = GameObject.FindObjectsOfType<AudioSource>() as AudioSource[];
		for(int i=0;i<sources.Length;i++)
		{
			sources[i].mute = !isMusic;
		}
	}




}
