using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TrackHandler : MonoBehaviour {

	public Track[] Tracks;
	public Vector3 StartPos;
	public float Gap;

	public GameObject Player;
	public Track CurrentTrack;

	private float CurrentTrackLength;
	private float TravelledDistance;
	private int CurrentTrackIndex = 0;

	private List<int> TracksIndexes = new List<int>();

	public List<Track> CurrentTrackIndexes = new List<Track>();

	void Start()
	{
		Tracks = GetComponentsInChildren<Track>() as Track[];
		int K = 0;
		foreach( Track T in Tracks )
		{
			T.gameObject.SetActive( false );
			TracksIndexes.Add( K );
			K++;
		}
		Tracks[0].gameObject.SetActive(true);
		Tracks[1].gameObject.SetActive( true );
		TracksIndexes.Remove( 0 );
		TracksIndexes.Remove( 1 );
		CurrentTrackIndexes.Add( Tracks[0] );
		CurrentTrackIndexes.Add( Tracks[1] );
	}

	void Update()
	{
//		TravelledDistance = Player.transform.position.x - CurrentTrackIndexes[1].transform.TransformPoint( CurrentTrackIndexes[1].transform.position ).x;
////		Debug.Log( TravelledDistance );
//		if( TravelledDistance > 0 )
//		{
//			//Debug.Log( "Updating Track Info" );
//			UpdateTrackInfo();
//		}
	}

	void UpdateTrackInfo()
	{
//		Debug.Log( "Updating Track" );
		int RN = Random.Range( 0, TracksIndexes.Count - 1 );
		if( Tracks[TracksIndexes[RN]] == CurrentTrackIndexes[1] )
		{
			RN = Random.Range( 0, TracksIndexes.Count - 1 );
		}
		//Debug.Log( TracksIndexes[RN] );
		Tracks[ TracksIndexes[RN] ].gameObject.SetActive( true );
		float Pos = CurrentTrackIndexes[1].transform.position.x + 
			(CurrentTrackIndexes[1].Length() / 2) + (Tracks[ TracksIndexes[RN] ].Length() / 2);

		Tracks[ TracksIndexes[RN] ].transform.position = new Vector3( Pos, Tracks[ TracksIndexes[RN] ].transform.position.y, Tracks[ TracksIndexes[RN] ].transform.position.z );

		CurrentTrackIndexes[0] = CurrentTrackIndexes[1];
		CurrentTrackIndexes[1] = Tracks[ TracksIndexes[RN] ];
		TracksIndexes.Remove( TracksIndexes[RN]);
		if( TracksIndexes.Count == 1 )
		{
			//Debug.Log( "Updating Trackindex list" );
			for( int i = 0; i < Tracks.Length - 1; i++ )
			{
				if( i != TracksIndexes[0] || i != TracksIndexes[1])
					TracksIndexes.Add( i );
			}
		}


	}


}
