using UnityEngine;
using System.Collections;

public class Obstacle : MonoBehaviour {

	public enum ObstacleType
	{
		Zombie,
		Drum,
		Speaker
	}

	public ObstacleType _TYPE;
	private bool IsGrounded = false;
	void FixedUpdate()
	{
		if( !IsGrounded )
		{
			rigidbody.position -= new Vector3( 0, Time.deltaTime * 10, 0);
		}

	}

	void OnCollisionEnter( Collision Col )
	{

		IsGrounded = true;
		if( Col.transform.tag == "Player" || Col.transform.tag == "Fire" )
		{
			//Instantiate Particle Effect
			if( this.transform.name == "zombie_lowres(Clone)" )
				AudioMessenger.ZombieCount++;
			Destroy( this.gameObject );
		}
	}
}
