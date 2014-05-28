using UnityEngine;
using System.Collections;

public class HandleTaps : MonoBehaviour {

	public float RotationSpeed = 10.0f;
	public Camera NGUICam;
	public GameObject Player, Axiz;
	private float Temp;
	public bool IsHittingButton = false;


	void Update()
	{
		if( Input.GetMouseButtonDown(0))
			Temp = Player.rigidbody.rotation.z;
		if( Input.GetMouseButton(0))
		{
			Ray r = NGUICam.ScreenPointToRay( Input.mousePosition );
			RaycastHit Hit = new RaycastHit();
			if( Physics.Raycast( r, out Hit, Mathf.Infinity ) && !Player.GetComponent<MotionNew>().IsGrounded )
			{
				if( Hit.collider.name == "RotateLeft" )
				{
					//Player.transform.RotateAround( Player.transform.position, Axiz.transform.forward , -Time.deltaTime * RotationSpeed );
//					Player.rigidbody.MoveRotation( new Quaternion( 0,0,Temp , 0 ));
					Temp += Time.deltaTime * RotationSpeed;
					Player.rigidbody.rotation = new Quaternion( Player.rigidbody.rotation.x,Player.rigidbody.rotation.y,Temp , Player.rigidbody.rotation.w );
					IsHittingButton = true;
				}
				else if( Hit.collider.name == "RotateRight" )
				{
					Temp -= Time.deltaTime * RotationSpeed;
					Player.rigidbody.rotation = new Quaternion( Player.rigidbody.rotation.x,Player.rigidbody.rotation.y,Temp , Player.rigidbody.rotation.w );
					IsHittingButton = true;
					//Player.transform.RotateAround( Player.transform.position, Axiz.transform.forward , Time.deltaTime * RotationSpeed );
				}

			}
			else
				IsHittingButton = false;
		}

		if( Input.GetKeyDown( KeyCode.A ) || Input.GetKeyDown( KeyCode.D))
			Temp = Player.rigidbody.rotation.z;

		if( Input.GetKey( KeyCode.A ) )
		{
			Temp += Time.deltaTime * RotationSpeed;
			Player.rigidbody.rotation = new Quaternion( Player.rigidbody.rotation.x,Player.rigidbody.rotation.y,Temp , Player.rigidbody.rotation.w );
			IsHittingButton = true;
		}

		if( Input.GetKey( KeyCode.D ) )
		{
			Temp -= Time.deltaTime * RotationSpeed;
			Player.rigidbody.rotation = new Quaternion( Player.rigidbody.rotation.x,Player.rigidbody.rotation.y,Temp , Player.rigidbody.rotation.w );
			IsHittingButton = true;
		}
	}


}
