using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {

	public float _X_OFFSET = 0.0f, _Y_OFFSET = 0.0f;
	public GameObject Target;

	void LateUpdate()
	{
		transform.position = new Vector3( Target.transform.position.x + _X_OFFSET, Target.transform.position.y + _Y_OFFSET, transform.position.z );
	}
}
