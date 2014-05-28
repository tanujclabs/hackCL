using UnityEngine;
using System.Collections;

public class AudioMessenger : MonoBehaviour {
	 
	public AudioClip[] Tracks;
	public int TrackNo = 0;
	static bool ObjectCreated = false;
	public static int ZombieCount = 0;
	public static float Distance = 0;

	void Start()
	{
		if( !ObjectCreated )
		{
			DontDestroyOnLoad( this.gameObject );
			ObjectCreated = true;
		}
		else
			Destroy( this.gameObject );
	}

	void SetTrackNo(  GameObject sender )
	{
		string TrackName = sender.GetComponentInChildren<UILabel>().text;
		for( int i = 0; i < Tracks.Length; i++ )
		{
			if( Tracks[i].name == TrackName )
			{
				TrackNo = i;
				break;
			}
		}
		Application.LoadLevel( "GamePlay" );
	}

}
