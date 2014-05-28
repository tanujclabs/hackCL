using UnityEngine;
using System.Collections;

public class GamePlayScript : MonoBehaviour {
	GameObject g;
	GameObject Ball;
	float fx;
	// Use this for initialization
	void Start () 
	{
		fx = -5.2f;
		g = Resources.Load ("GamePiller") as GameObject;
		for (int i=0; i<6; i++) 
		{
			Instantiate(g);
			g.transform.position=new Vector3(fx,Random.Range(-2f,-6f),-4f);
			fx+=3.5f;
		}
		Ball = GameObject.Find ("GlowBall(Clone)")as GameObject;
	
	}
	
	// Update is called once per frame
	void Update () {
	
		if (Input.touchCount > 0) 
		{
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

	void Pause()
	{
		Time.timeScale = 0.0f;
		StaticScript.LetsStart = false;
		g = Resources.Load ("ResumePanel")as GameObject;
		NGUITools.AddChild(GameObject.Find ("UI Root")as GameObject,g);
	}


}
