using UnityEngine;
using System.Collections;

public class DrillMenu : MonoBehaviour {
	public Transform blade;
	public Vector3 finalPos;
	public Vector3 initialPos;
	float speed,maxSpeed;
	public AudioSource source;
	public AudioClip _clip;
	//float offsetSpeed;
	// Use this for initialization
	void Start () {
		maxSpeed = 4.0f;
		source.clip = _clip;
		source.loop = true;
		source.Play ();
	}
	
	// Update is called once per frame
	void Update () {
		transform.position = Vector3.Lerp (transform.position, finalPos, Time.deltaTime * 3.0f);
		if (speed < maxSpeed)
						speed += Time.deltaTime * 5.0f;
				else
			speed = maxSpeed;
		blade.Rotate (new Vector3 (0.0f, 0.0f, speed), Space.Self);
	}
}
