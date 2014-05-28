using UnityEngine;
using System.Collections;

public class Track : MonoBehaviour {

	public Transform Start,End;

	public float Length()
	{
		return ( End.transform.position.x - Start.transform.position.x);
	}
}
