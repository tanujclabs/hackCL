using UnityEngine;
using System.Collections;

public class MotionNew : MonoBehaviour {

	public Vector3 ForceTemp, Force, TrigFunction, Max, Min;
	public Transform Car, FrontWheel, BackWheel;
	public int Power;
	private RaycastHit hit = new RaycastHit();
	Quaternion Rot;
	public bool IsGrounded = true;
	public SpectrumWindow window;
	private bool GameOver = false;
	private float mTime = 0;


	void Start()
	{	
//		rigidbody.constraints = RigidbodyConstraints.FreezeRotation;

	}

	void Update()
	{

	}

	void FixedUpdate()
	{
		if( !GameOver )
		{
		TrigFunction = Car.TransformDirection(Vector3.right * window.AverageFrequencyValue * 400);
		ForceTemp.Set( TrigFunction.x, TrigFunction.y, TrigFunction.z ); 
		Force =ForceTemp;//Vector3.Lerp( Force, ForceTemp, Time.deltaTime * 10);
		if( IsGrounded)
		{
//			Debug.Log( "Applying Force" + (Force * Power) );
			rigidbody.AddForce(Force*Power);
		}

		if( rigidbody.velocity.x > Max.x* window.AverageFrequencyValue * 400 && IsGrounded )
			rigidbody.velocity = new Vector3( Max.x* window.AverageFrequencyValue * 400, rigidbody.velocity.y, rigidbody.velocity.z );

		if( rigidbody.velocity.y > Max.y* window.AverageFrequencyValue * 400 && IsGrounded )
			rigidbody.velocity = new Vector3( rigidbody.velocity.x, Max.y* window.AverageFrequencyValue * 400, rigidbody.velocity.z );

		if( rigidbody.velocity.x < Min.x && IsGrounded )
			rigidbody.velocity = new Vector3( Min.x, rigidbody.velocity.y, rigidbody.velocity.z );
		
		if( rigidbody.velocity.y < Min.y && IsGrounded )
			rigidbody.velocity = new Vector3( rigidbody.velocity.x, Min.y, rigidbody.velocity.z );

//		if( Physics.Raycast (transform.position, -Vector3.up, out hit)) 
//		{
//			//			Debug.Log( hit.normal );
//			Rot = Quaternion.FromToRotation(Vector3.up, hit.normal);
//			if( IsGrounded )
//			transform.rotation = Quaternion.Slerp( transform.rotation, Rot, Time.deltaTime * 10);
//		}	
		}
		else
		{
			mTime += Time.deltaTime;
			if( mTime > 2.0f )
			{
				Time.timeScale = 0;
				GameObject.Find( "UI Root" ).SendMessage( "OnGameOver", SendMessageOptions.DontRequireReceiver );
			}
		}
		if( transform.localEulerAngles.z > 180 && transform.localEulerAngles.z < 270 && IsGrounded )
		{
			GameOver = true;


		}

	}

	void OnCollisionExit( Collision Other )
	{
		IsGrounded = false;
	}
	
	void OnCollisionStay( Collision other )
	{
		IsGrounded = true;
	}
	void OnCollisionEnter( Collision Col )
	{
////		Debug.Log( Col.transform.name);
//		rigidbody.constraints = RigidbodyConstraints.FreezeAll;
//		rigidbody.constraints = RigidbodyConstraints.FreezeRotationX;
//		rigidbody.constraints = RigidbodyConstraints.FreezeRotationY;
		if( Col.transform.tag == "Obstacle" )
		{
//			Debug.Log( "Back Force" );
			rigidbody.AddForce( - Force*Power * 5);
		}
	}

	void OnGUI1()
	{
		if( GUI.Button ( new Rect(0,0,100,100), "R") )
		{
			Application.LoadLevel( Application.loadedLevelName );
		}
	}
}
