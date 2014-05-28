using UnityEngine;
using System.Collections;

public class LocalPositionHandler : MonoBehaviour {
	public bool scale;
	// Use this for initialization
	void Start () 
	{
		Camera cam = transform.GetComponent<Camera> ();
		if (cam != null)
						cam.orthographicSize = Screen.height / 2.0f;
		transform.localPosition = new Vector3 (transform.localPosition.x * Screen.width / 1280.0f, transform.localPosition.y * Screen.height / 720.0f, transform.localPosition.z); 
	    if (scale)
		transform.localScale = new Vector3 (transform.localScale.x * Screen.width / 1280.0f, transform.localScale.y, transform.localScale.z);
	   
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
