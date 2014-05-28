using UnityEngine;
using System.Collections;

public class BulletFiring : MonoBehaviour {
		
	public GameObject Prefab;
	public GameObject Gun;
	private GameObject RotateLeft, RotateRight;

	void Awake()
	{
		RotateLeft = GameObject.Find( "RotateLeft" );
		RotateRight = GameObject.Find( "RotateRight" );
	}
	void Update()
	{

		if( Input.GetMouseButtonDown( 0 ) && ( !RotateLeft.GetComponent<HandleTaps>().IsHittingButton && !RotateRight.GetComponent<HandleTaps>().IsHittingButton))
		{
			GameObject g = Instantiate( Prefab, Gun.transform.position, new Quaternion( 0,0,-90, 1) ) as GameObject;
		}
	}
}
