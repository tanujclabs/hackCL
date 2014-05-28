using UnityEngine;
using System.Collections;

public class BallTapControl : MonoBehaviour {
	public GameObject Ball;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void addForce()
	{
		Debug.Log (Ball.transform.position.y);
		if (StaticScript.HitBase) 
		{
			StaticScript.HitBase=false;
			if(Ball.transform.position.y<=-3f)
			{
				Ball.rigidbody.velocity = new Vector3 (0f, 0f, 0f);
				Ball.rigidbody.AddForce (new Vector3 (0, 370f, 0), ForceMode.Acceleration);
			}
			else if(Ball.transform.position.y<=-2.7f)
			{
				Ball.rigidbody.velocity = new Vector3 (0f, 0f, 0f);
				Ball.rigidbody.AddForce (new Vector3 (0, 550f, 0), ForceMode.Acceleration);
			}
			else if(Ball.transform.position.y<=-2.5f)
			{
				Ball.rigidbody.velocity = new Vector3 (0f, 0f, 0f);
				Ball.rigidbody.AddForce (new Vector3 (0, 520f, 0), ForceMode.Acceleration);
			}
			else if(Ball.transform.position.y<=-2.3f)
			{
				Ball.rigidbody.velocity = new Vector3 (0f, 0f, 0f);
				Ball.rigidbody.AddForce (new Vector3 (0, 450f, 0), ForceMode.Acceleration);
			}

		}

	}

}
