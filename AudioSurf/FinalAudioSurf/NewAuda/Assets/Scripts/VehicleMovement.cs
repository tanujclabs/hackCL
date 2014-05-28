using UnityEngine;
using System.Collections;

public class VehicleMovement : MonoBehaviour {

	private RaycastHit hit = new RaycastHit();
	public float Speed = 10.0f;
	Quaternion Rot;
	private Vector3 moveDirection = Vector3.zero;
	public float gravity = 20.0F;
	private float zVal = 0.0f;

	void Start()
	{
		zVal = transform.position.z;
	}

	void Update()
	{
	
		CharacterController controller = GetComponent<CharacterController>();
		controller.detectCollisions = true;
		moveDirection = new Vector3(Speed, 0 , 0);
		moveDirection = transform.TransformDirection(moveDirection);
		moveDirection *= Speed;
//		Debug.Log( controller.isGrounded );
		moveDirection.y -= gravity * Time.deltaTime;
		controller.Move(moveDirection * Time.deltaTime);

		if( Physics.Raycast (transform.position, -Vector3.up, out hit)) 
		{
//			Debug.Log( hit.normal );
			Rot = Quaternion.FromToRotation(Vector3.up, hit.normal);
			transform.rotation = Quaternion.Slerp( transform.rotation, Rot, Time.deltaTime * 10 );
		}
	}


	void FixedUpdate()
	{
		if( Physics.Raycast (transform.position, -Vector3.up, out hit)) 
					{
			//			Debug.Log( hit.normal );
						Rot = Quaternion.FromToRotation(Vector3.up, hit.normal);
						transform.rotation = Quaternion.Slerp( transform.rotation, Rot, Time.deltaTime * 10 );
					}
		//rigidbody.velocity = new Vector3( Speed, Physics.gravity.y,0 );
//		rigidbody.AddForce( new Vector3( Speed, Physics.gravity.y,0 ) );
	}



}
