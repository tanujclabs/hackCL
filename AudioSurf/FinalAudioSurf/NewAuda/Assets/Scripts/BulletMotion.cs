using UnityEngine;
using System.Collections;

public class BulletMotion : MonoBehaviour {

	public float Speed;
	private GameObject Player;
	private SpectrumWindow Window;
	Vector3 Scale;
	public GameObject Explosion;

	void Awake()
	{
		Window = GameObject.Find( "AudioManager" ).GetComponent<SpectrumWindow>();

		Player = GameObject.Find( "Vehicle" );
		if( this.transform.name != "Exaust" )
		{
			Destroy ( this.gameObject, 2.0f);
			rigidbody.rotation = Player.transform.rotation;
		}
		Scale = transform.localScale;
	}
	void FixedUpdate()
	{
		if( this.transform.name != "Exaust" )
			rigidbody.velocity =   Speed * Player.transform.right;/*new Vector3( Speed, 0, 0)*/;
	}

	void OnCollisionEnter( Collision other )
	{
		if( this.transform.name != "Exaust" )
		{
			if( other.transform.tag == "Obstacle" )
				Instantiate( Explosion, transform.position, Quaternion.identity );
			Destroy( this.gameObject );
		}
	}

	void Update()
	{
		if( this.transform.name != "Exaust" )
			transform.localScale = new Vector3( transform.localScale.x + Window.AverageFrequencyValue * 50, Scale.y + Window.AverageFrequencyValue * 50 , transform.localScale.z );
		else
		{

			transform.localScale = new Vector3( Scale.x + Window.AverageFrequencyValue * 50, Scale.y + Window.AverageFrequencyValue * 50 , transform.localScale.z );
		}
	}
}
