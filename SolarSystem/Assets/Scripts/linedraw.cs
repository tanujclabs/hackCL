using UnityEngine;
using System.Collections;

public class linedraw : MonoBehaviour {

	// Use this for initialization
	public Transform vector3;
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

		Debug.DrawLine(this.gameObject.transform.position, vector3.position, Color.green);
	
	}
}
