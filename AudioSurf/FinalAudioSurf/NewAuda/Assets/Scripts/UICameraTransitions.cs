using UnityEngine;
using System.Collections;

public class UICameraTransitions : MonoBehaviour {

	public bool IsTransitionF = false, IsTransitionB = false, FadingBlur = false, Motioning = false;
	public GameObject AxisObject;
	public float TransitionSpeed;
	public Vector3 CurrentPos;
	
	private float Angle = 0.0f;
	private float PrevAngle = 0.0f;

	void Awake()
	{
		AxisObject = GameObject.Find( "main" );
	}
	
	void Update()
	{
		if( IsTransitionF )		
			MakeForwardTransition();
		
		else if( IsTransitionB )
			MakeBackwardTransition();
		
		else if( FadingBlur )
			BlurFadeOut();
		
//		else if( Motioning )
//			ApplyMotion();
	}
	
	void MakeForwardTransition()
	{
//		Angle += Time.deltaTime * TransitionSpeed;
//		transform.RotateAround( AxisObject.transform.position, AxisObject.transform.up, Time.deltaTime * TransitionSpeed );
//		if( Angle >= 90 )
//		{
//			IsTransitionF = false;
//			Angle = 0;
//		}
		Angle = Mathf.Lerp ( Angle, 91, Time.deltaTime * TransitionSpeed );
		transform.RotateAround( AxisObject.transform.position, AxisObject.transform.up, Angle - PrevAngle );
		if( Angle >= 90 )
		{
			IsTransitionF = false;
			Angle = 0;
		}
		PrevAngle = Angle;
	}
	
	void MakeBackwardTransition()
	{
		//Angle += Time.deltaTime * TransitionSpeed;
		Angle = Mathf.Lerp ( Angle, -91, Time.deltaTime * TransitionSpeed );
		transform.RotateAround( AxisObject.transform.position, AxisObject.transform.up, Angle - PrevAngle );
		if( Angle <= -90 )
		{
			IsTransitionB = false;
			Angle = 0;
		}
		PrevAngle = Angle;
	}
	
	void BlurFadeOut()
	{
		Angle -= Time.deltaTime * 0.00001f;
		GetComponent<BlurEffect>().iterations = (int)Angle;
		if( Angle <= 0 )
		{
			Destroy( GetComponent<BlurEffect>() );
			Angle = 0;
			FadingBlur = false;
		}
	}
	
	void ApplyMotion()
	{
		transform.localPosition = Vector3.Lerp( transform.position, CurrentPos, Time.deltaTime * 0.001f );
		if( transform.localPosition.z >= CurrentPos.z )
			Motioning = false;
	}
}
