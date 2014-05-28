using UnityEngine;
using System.Collections;

public class UIGameplayHandlee : MonoBehaviour {

	public GameObject LeftButton, RightButton, PauseButton, PausePanel, GameOverPanel, GameComplete;
	public UILabel ZobmC, DistTrav, ZobmCC, DistTravC;

	private Vector3 InitPos;

	private AudioSource AudioMess;
	private float ClipLength = 0.0f;
	
	void Start()
	{	
		//		rigidbody.constraints = RigidbodyConstraints.FreezeRotation;
		AudioMess = GameObject.Find( "AudioManager" ).GetComponent<AudioSource>();
		ClipLength = AudioMess.clip.length;
	}
	void Update()
	{
//		Debug.Log( AudioMess.time + " " + ClipLength);
		if( AudioMess.time >= ClipLength && !GameComplete.activeInHierarchy)
		{
			OnGameComplete();
		}
	}

	void Awake()
	{
		int TNO = GameObject.Find( "AudioMessenger" ).GetComponent<AudioMessenger>().TrackNo;
		GameObject.Find( "AudioManager" ).audio.clip = GameObject.Find( "AudioMessenger" ).GetComponent<AudioMessenger>().Tracks[TNO];
		GameObject.Find( "AudioManager" ).audio.Play();
		AudioMessenger.ZombieCount = 0;
		InitPos = GameObject.Find( "Vehicle" ).transform.position;
	}

	void OnResumePressed()
	{
		LeftButton.SetActive( true );
		RightButton.SetActive( true );
		PauseButton.SetActive( true );
		PausePanel.SetActive( false );
		Time.timeScale = 1;
		GameObject.Find( "Main Camera" ).GetComponent<BlurEffect>().enabled = false;
		GameObject.Find( "AudioManager" ).audio.Play();
	}

	void OnRestartPressed()
	{
		Time.timeScale = 1;
		Application.LoadLevel( Application.loadedLevelName );
	}

	void OnMainMenuPressed()
	{
		Time.timeScale = 1;
		Application.LoadLevel( "UI" );
	}

	void OnPauseButtonPressed()
	{
		Time.timeScale = 0;
		LeftButton.SetActive( false );
		RightButton.SetActive( false );
		PauseButton.SetActive( false );
		GameObject.Find( "Main Camera" ).GetComponent<BlurEffect>().enabled = true;
		PausePanel.SetActive( true );
		GameObject.Find( "AudioManager" ).audio.Pause();
	}

	void OnGameOver()
	{
		ZobmC.text = AudioMessenger.ZombieCount.ToString();
		DistTrav.text = ((int)( GameObject.Find( "Vehicle" ).transform.position.x - InitPos.x  )).ToString() + " m";
		LeftButton.SetActive( false );
		RightButton.SetActive( false );
		PauseButton.SetActive( false );
		GameObject.Find( "Main Camera" ).GetComponent<BlurEffect>().enabled = true;

		GameOverPanel.SetActive( true );
	}

	void OnGameComplete()
	{
		ZobmCC.text = AudioMessenger.ZombieCount.ToString();
		DistTravC.text = ((int)( GameObject.Find( "Vehicle" ).transform.position.x - InitPos.x  )).ToString() + " m";
		LeftButton.SetActive( false );
		RightButton.SetActive( false );
		PauseButton.SetActive( false );
		GameObject.Find( "Main Camera" ).GetComponent<BlurEffect>().enabled = true;
		
		GameComplete.SetActive( true );
	}


}
