using UnityEngine;
using System.Collections;

public class AlphaFill : MonoBehaviour {
	public Mesh mesh;
	Transform _transform;
	Vector2[] uvs;
	// Use this for initialization
	void Start () {
		_transform = transform.parent;
		mesh = transform.GetComponent<MeshFilter> ().mesh;
		_transform.localScale = new Vector3 (0, 1, 1);

		uvs = mesh.uv;
		uvs[1] = new Vector2 (0.0f, uvs[1].y);
		uvs[2] = new Vector2 (0.0f, uvs[2].y);
		mesh.uv = uvs;

	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void changeUv(float alpha)
	{
		_transform.localScale = new Vector3 (alpha, 1, 1);
		uvs[1] = new Vector2 (alpha, uvs[1].y);
		uvs[2] = new Vector2 (alpha, uvs[2].y);
		mesh.uv = uvs;
	}
}
