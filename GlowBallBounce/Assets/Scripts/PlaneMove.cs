using UnityEngine;
using System.Collections;

public class PlaneMove : MonoBehaviour {
	float calDistance;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () 
	{
		if (StaticScript.LetsStart) 
		{
			#if UNITY_ANDROID
			if (Input.GetKey (KeyCode.LeftArrow))
			transform.Translate ((Time.deltaTime * 5), 0f, 0f);
			else if (Input.GetKey (KeyCode.RightArrow))
				transform.Translate (-0.2f, 0f, 0f);
			if (Input.acceleration.x >= 0)
				transform.Translate (-(Input.acceleration.x / 5), 0, 0);
//		else 
//		{
//			calDistance=StaticScript.GetBack-(Input.acceleration.x/5);
//			if(calDistance>0)
//				transform.Translate (-calDistance, 0, 0);
//		}
			#endif 
			if (this.transform.position.x <= -19) 
			{
				this.transform.position = new Vector3 (19f, this.transform.position.y, this.transform.position.z);		
			}
		}

	}
}
