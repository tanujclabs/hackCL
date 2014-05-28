using UnityEngine;
using System.Collections;

public class ChangeOrthoCameraSize : MonoBehaviour {

	// Use this for initialization
	void Start () {
		gameObject.camera.orthographicSize = Screen.height/2;
		transform.position = new Vector3(-Screen.width/2,-Screen.height/2,0);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
