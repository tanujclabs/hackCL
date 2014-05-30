using UnityEngine;
using System.Collections;

public class RotateSample : MonoBehaviour
{	
	void Start(){

	}

	void Update()
	{
		this.gameObject.transform.Rotate (new Vector3 (0, 0, 5 * Time.deltaTime));
	}
}

