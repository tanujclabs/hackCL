using UnityEngine;
using System.Collections;

public class cameraMove : MonoBehaviour {

	// Use this for initialization
	userinterface userinterfaceObj;
	RevolutionandRotation revnrotateObj;


	GameObject solarAxis;
	Transform bodyAxis;
	Transform planetCameraPositionObj;

	Vector2 touch2Position;
	Vector2 touch1Position;
	Vector2 CurrentDistance;
	Vector2 PreviousDistance;
	Vector3 camerastartposition;
	float TouchDelta;
	public Vector3 planetCameraPosition;
	public Vector3 lookAtPlanetPos;
	public float startTime;
	public float journeydistance;
	public float speed = 150.0f;
	public float rotationdamp = 10.0f;
	public float defaultfieldofView;
	smoothLookat smoothlookatscript;
	Transform planetcameralookattransform;

	void Start () {
		smoothlookatscript = this.gameObject.GetComponent<smoothLookat> () as smoothLookat;
		//startTime = Time.time;
		solarAxis = GameObject.Find ("SolarAxis");
		userinterfaceObj = solarAxis.transform.GetComponent<userinterface>() as userinterface;
		revnrotateObj = solarAxis.transform.GetComponent<RevolutionandRotation>() as RevolutionandRotation;

	}

	void moveandlook(Vector3 startposition,Vector3 endposition,Vector3 lookat)
	{

		this.gameObject.transform.LookAt (lookat);

		float distanceCovered = Vector3.Distance (this.gameObject.transform.position, endposition);
		float fracJourney = distanceCovered / (journeydistance * 0.50f);
		Debug.Log ("lookat vector: " + lookat +"Distance Covered: " + distanceCovered);
		//transform.position = Vector3.Lerp (startposition, endposition, speed * fracJourney * Time.smoothDeltaTime);
		if (userinterfaceObj.firstLookaT) 
		{
			//iTween.MoveTo (this.gameObject, planetCameraPosition, speed * Time.fixedDeltaTime);// + speed * Time.deltaTime));
			transform.position = endposition;
			Debug.Log("ITween Running");
				if (distanceCovered < 4) 
			{
				userinterfaceObj.firstLookaT = false;
				Debug.Log("ITween Stopped");
			}
		}
			//transform.position = Vector3.Lerp (startposition, endposition, 5 * Time.deltaTime);


	}

	void check()
	{
		if (userinterfaceObj.currentSelection == userinterface.Selection.none) 
		{
			
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.sun) 
		{
			bodyAxis = revnrotateObj.sunAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("SunCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.sunModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("SunCameraLookatPoint").transform.position;
			planetcameralookattransform = bodyAxis.gameObject.transform.FindChild("SunCameraLookatPoint").transform;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.sunAxis.transform;

//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.mercury) 
		{
			bodyAxis = revnrotateObj.mercuryAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("MercuryCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("MercuryCameraLookatPoint").transform.position;
			planetcameralookattransform = bodyAxis.gameObject.transform.FindChild("MercuryCameraLookatPoint").transform;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.mercuryAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);	
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.venus) 
		{
			bodyAxis = revnrotateObj.venusAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("VenusCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("VenusCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.venusAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.earth) 
		{
			bodyAxis = revnrotateObj.earthAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("EarthCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("EarthCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.earthAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.mars) 
		{
			bodyAxis = revnrotateObj.marsAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("MarsCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("MarsCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.marsAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.jupiter) 
		{
			bodyAxis = revnrotateObj.jupiterAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("JupiterCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.jupiterModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("JupiterCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.jupiterAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.saturn) 
		{
			bodyAxis = revnrotateObj.saturnAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("SaturnCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.saturnModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("SaturnCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.saturnAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		
		else if (userinterfaceObj.currentSelection == userinterface.Selection.uranus) 
		{
			bodyAxis = revnrotateObj.uranusAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("UranusCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.uranusModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("UranusCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.uranusAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}

		else if (userinterfaceObj.currentSelection == userinterface.Selection.neptune) 
		{
			bodyAxis = revnrotateObj.neptuneAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("NeptuneCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.neptuneModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("NeptuneCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.neptuneAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
		else if (userinterfaceObj.currentSelection == userinterface.Selection.pluto) 
		{
			bodyAxis = revnrotateObj.plutoAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("PlutoCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.plutoModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("PlutoCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.plutoAxis.transform;
//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}

		else if (userinterfaceObj.currentSelection == userinterface.Selection.moon) 
		{
			bodyAxis = revnrotateObj.moonAxis;
			planetCameraPositionObj = bodyAxis.gameObject.transform.FindChild("MoonCameraPoint");
			planetCameraPosition = planetCameraPositionObj.transform.position;
			//lookAtPlanetPos = revnrotateObj.moonModel.transform.position;
			lookAtPlanetPos = bodyAxis.gameObject.transform.FindChild("MoonCameraLookatPoint").transform.position;
			moveandlook(this.gameObject.transform.position,planetCameraPosition,lookAtPlanetPos);
			this.gameObject.transform.parent = revnrotateObj.moonAxis.transform;
			//			Debug.Log("Position of camera object: " + lookAtPlanetPos);
		}
	}

	// Update is called once per frame
	void Update () {
        if (!userinterfaceObj.freeMove)
        {
			if(Input.touchCount == 1)
			{
				if(Input.GetTouch(0).phase == TouchPhase.Moved)
				{
					Vector2  touchDeltaPosition = Input.GetTouch(0).deltaPosition;
				 transform.Rotate(new Vector3(-touchDeltaPosition.x  * Time.fixedDeltaTime, -touchDeltaPosition.y  * Time.fixedDeltaTime,0 ));
				}
			}

			if (Input.touchCount == 2)
			{
				defaultfieldofView =this.gameObject.GetComponent<Camera>().fieldOfView;
				if(Input.GetTouch(0).phase == TouchPhase.Moved && Input.GetTouch(1).phase == TouchPhase.Moved)
				{
					
					touch1Position =  Input.GetTouch(0).position;
					touch2Position =  Input.GetTouch(1).position;
					Vector2 touch1DeltaPosition = Input.GetTouch(0).deltaPosition;
					Vector2 touch2DeltaPosition = Input.GetTouch(1).deltaPosition;
					CurrentDistance = touch1Position - touch2Position; 
					PreviousDistance = ((touch1Position - touch1DeltaPosition) - (touch2Position - touch2DeltaPosition)); 
					TouchDelta= CurrentDistance.magnitude - PreviousDistance.magnitude ;


					if(TouchDelta >0)
					{
						Debug.Log("Zoom Out");
						this.gameObject.GetComponent<Camera>().fieldOfView += 0.5f;
					}

					else if(TouchDelta < 0)
					{
						Debug.Log("Zoom In");
						this.gameObject.GetComponent<Camera>().fieldOfView -= 0.5f;
					}
				}
			}


			defaultfieldofView =this.gameObject.GetComponent<Camera>().fieldOfView;
			if (Input.GetAxis ("Mouse ScrollWheel") > 0)
			{
				Debug.Log("Hello Hello");
				this.gameObject.GetComponent<Camera>().fieldOfView -= 0.5f;
			}
			
			else if (Input.GetAxis ("Mouse ScrollWheel") < 0)
			{
				this.gameObject.GetComponent<Camera>().fieldOfView += 0.5f;
			}
            check();
        }

        else
        {	
			defaultfieldofView =this.gameObject.GetComponent<Camera>().fieldOfView;
			if (Input.GetAxis ("Mouse ScrollWheel") > 0)
			{
				Debug.Log("Hello Hello");
				this.gameObject.GetComponent<Camera>().fieldOfView += 0.5f;
			}

			else if (Input.GetAxis ("Mouse ScrollWheel") < 0)
			{
				this.gameObject.GetComponent<Camera>().fieldOfView -= 0.5f;
			}
//            Debug.Log("in this");
//            if (Input.GetAxis("Vertical") > 0)
//            {
//                
//                transform.TransformDirection(Vector3.forward);
//            }
//            else if (Input.GetAxis("Vertical") < 0)
//            {
//                transform.TransformDirection(Vector3.back);
//            }
//
//            else if (Input.GetAxis("Horizontal") < 0)
//            {
//                transform.TransformDirection(Vector3.left);
//            }
//
//            else if (Input.GetAxis("Horizontal") > 0)
//            {
//                transform.TransformDirection(Vector3.right);
//            }
        }
	}
}
