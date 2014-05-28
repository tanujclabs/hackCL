using UnityEngine;
using System.Collections;

public class MeshFixer : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Mesh mesh = transform.GetComponent<MeshFilter>().mesh;
		Vector2[] uvs = new Vector2[4];
		uvs[0] = new Vector2(0.0f,0.0f);
		uvs[1] = new Vector2(1.0f,1.0f);
		uvs[2] = new Vector2(1.0f,0.0f);
		uvs[3] = new Vector2(0.0f,1.0f);
		mesh.uv = uvs;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
