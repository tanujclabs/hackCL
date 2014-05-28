using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ObstacleHandler : MonoBehaviour {

	public List<GameObject> Obstacles;
	public float mTime = 0.0f;
	public float ObsInstTime = 1f;
	public float InstGap = 10;
	public float ZombieScaleFactor, DrumScaleFactor;

	void Update()
	{
		mTime += Time.deltaTime;
		if( mTime > ObsInstTime )
		{
			mTime = 0;
			InstObstacle();
		}
	}

	void InstObstacle()
	{
		int Rn = Random.Range( 0, Obstacles.Count );
		var g = Instantiate( Obstacles[Rn] ) as GameObject;
		float xPos = GameObject.Find( "Vehicle" ).transform.position.x + InstGap;
		g.transform.position = new Vector3( xPos,  25.10783f, 15.3141f);
		if( Obstacles[Rn].GetComponent<Obstacle>()._TYPE == Obstacle.ObstacleType.Drum )
		{
//			Debug.Log( "Scaling drum" );
			g.transform.localScale = new Vector3( DrumScaleFactor, DrumScaleFactor, DrumScaleFactor );
		}
		else
		{
//			Debug.Log( "Scaling zombie" );
			g.transform.localScale = new Vector3( ZombieScaleFactor, ZombieScaleFactor, ZombieScaleFactor );
			g.transform.localEulerAngles = new Vector3( 0, 270, 0);
		}

	}
}
