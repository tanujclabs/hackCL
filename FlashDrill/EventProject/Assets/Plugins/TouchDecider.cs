using UnityEngine;
using System.Collections;
public enum TouchState
{
	NONE=0,
	TAP_ENDED,
	SWIPE_RIGHT,
	SWIPE_DOWN,
	SWIPE_LEFT,
	SWIPE_UP,
	TAP
};

public struct TouchInfo
{
	public TouchState touchState;
	public int touchHalf;
	public Vector2 touchDeltafromBegin;

};
public class TouchDecider : MonoBehaviour {
	TouchInfo leftTouch,rightTouch;
	MoveGUI mGui;
	Vector3 mousePrevPos;
	float _trailTimer;
	public Transform[] trail;
	public TrailRenderer[] renderers;
	int[] trailId;
	float thresholdMag;
	//int[] fingerIds;
	int leftFingerId = -1,rightFingerId = -1;
	Vector2 leftTouchBeginPos, rightTouchBeginPos;
	Vector2 leftTouchDelta,rightTouchDelta;
	//Camera trailCam;
	public float timer ;
	Vector3 worldPos;

	// Use this for initialization
	void Start () 
	{
		//StartCoroutine(DissolveSphere(trail[0].GetComponent<MeshRenderer>()));
		leftTouch = new TouchInfo ();
		rightTouch = new TouchInfo ();
		mGui = GameObject.FindObjectOfType (typeof(MoveGUI)) as MoveGUI;
		leftTouchBeginPos = Vector2.zero;
		rightTouchBeginPos = Vector2.zero;
		thresholdMag = Screen.height * 0.08f;
		trailId = new int[5];
		for (int i = 0; i < 5; i++) {
			trailId[i] = -1;
				}
		//trailCam = GameObject.Find ("Camera").GetComponent<Camera> ();
		//trailCam.orthographicSize = Screen.height / 2;
		//trailCam.transform.position = new Vector3 (-Screen.width / 2, Screen.height/2, 0.0f);
		//trail [0].localScale = new Vector3 (Screen.width / 2, Screen.width / 2, Screen.width / 2);
	}
	
	// Update is called once per frame
	void Update () {
	    
//		timer += Time.deltaTime;
//		if (timer > 2.0f) {
//						worldPos = new Vector3 (-Random.Range (0, 1200), - Random.Range (0, 800), 100);
//						worldPos = new Vector3 (worldPos.x, worldPos.y, 100.0f);
//			Debug.Log("worldPos = "+worldPos);
//			timer = 0.0f;
//				}
//		trail [0].localPosition = Vector3.Lerp (trail [0].localPosition, worldPos, 0.1f);
#if !UNITY_EDITOR
		if (Input.touchCount > 0)
		{
			int noOfTouches = Input.touchCount;

			for(int i = 0; i < noOfTouches; i++)
			{
				Touch currentTouch = Input.GetTouch(i);	
				TouchPhase currentPhase = currentTouch.phase;
				if(currentPhase == TouchPhase.Began)
				{
					if(currentTouch.position.y > 0.75f * Screen.height)
						continue;
					//trailId[i] = currentTouch.fingerId;
					renderers[currentTouch.fingerId].time = 0.0f;
					renderers[currentTouch.fingerId].enabled = false;
					MeshRenderer ren = trail[currentTouch.fingerId].GetComponent<MeshRenderer>();
					ren.enabled = false;
					//Vector3 touchPos = trailCam.ScreenToWorldPoint(currentTouch.position);
					trail[currentTouch.fingerId].localPosition = new Vector3(currentTouch.position.x - Screen.width,currentTouch.position.y - Screen.height,100.0f); 
					renderers[currentTouch.fingerId].enabled = true;
					Color col = new Color(1.0f,1.0f,1.0f,0.0f);
					ren.sharedMaterial.SetColor("_Color",col);
					ren.enabled = true;
					if(currentTouch.position.x <= Screen.width*0.5f)
					{

						if(leftFingerId == -1)
						{
						    leftTouch.touchHalf = -1;
						    leftFingerId = currentTouch.fingerId;
							leftTouchBeginPos = currentTouch.position;
							leftTouch.touchState = TouchState.TAP;
						}
						else
						{
							leftTouch.touchHalf = 0;
							leftFingerId = -1;
							mGui.SetLeftTouch(leftTouch);
						}
					}
					else
					{
						if(rightFingerId == -1)
						{
							rightTouch.touchHalf = 1;
							rightFingerId = currentTouch.fingerId;
							rightTouchBeginPos = currentTouch.position;
							rightTouch.touchState = TouchState.TAP;
						}
						else
						{
							rightTouch.touchHalf = 0;
							rightFingerId = -1;
							mGui.SetRightTouch(rightTouch);
						}
					}
				}
				else if(currentPhase == TouchPhase.Moved || currentPhase == TouchPhase.Stationary )
				{
					if(currentTouch.position.y > 0.8f * Screen.height)
						continue;
					//Vector3 touchPos = trailCam.ScreenToWorldPoint(currentTouch.position);
					renderers[currentTouch.fingerId].time = 0.6f;
					MeshRenderer ren = trail[currentTouch.fingerId].GetComponent<MeshRenderer>();
					Color col = new Color(1.0f,1.0f,1.0f,190.0f/255.0f);
					ren.sharedMaterial.SetColor("_Color",col);
					trail[currentTouch.fingerId].localPosition = new Vector3(currentTouch.position.x - Screen.width,currentTouch.position.y - Screen.height,100.0f);
					if(currentTouch.fingerId == leftFingerId)
					{
						Vector2 dif = (currentTouch.position - leftTouchBeginPos);
						if(!mGui.pinching)
						{
						leftTouch.touchDeltafromBegin = dif;
						mGui.SetLeftTouch(leftTouch);
						}
						leftTouchDelta = currentTouch.deltaPosition;              
					}
					else if(currentTouch.fingerId == rightFingerId)
					{
						Vector2 dif = (currentTouch.position - rightTouchBeginPos);
						if(!mGui.pinching)
						{
						rightTouch.touchDeltafromBegin = dif;
						mGui.SetRightTouch(rightTouch);
						}
						rightTouchDelta = currentTouch.deltaPosition;
					}

				}
				else if(currentPhase == TouchPhase.Ended || currentPhase == TouchPhase.Canceled)
				{
					StartCoroutine(DissolveSphere(trail[currentTouch.fingerId].GetComponent<MeshRenderer>()));
					//trailId[currentTouch.fingerId] = -1;
					//renderers[currentTouch.fingerId].time = 0.0f;
					if(mGui.pinching)
					{
						mGui.pinching = false;
						rightTouch.touchHalf = 0;
						rightTouch.touchState = TouchState.NONE;
						leftTouch.touchHalf = 0;
						leftTouch.touchState = TouchState.NONE;
						rightFingerId = -1;
						leftFingerId = -1;
						return;
					}

					if(currentTouch.fingerId == leftFingerId)
					{
						if(leftTouch.touchDeltafromBegin.magnitude < thresholdMag)
						{
							leftTouch.touchState = TouchState.TAP_ENDED;
						}
						mGui.SetLeftTouch(leftTouch);
						leftFingerId = -1;
						leftTouch.touchHalf = 0;
						leftTouch.touchState = TouchState.NONE;
					}
					else if(currentTouch.fingerId == rightFingerId)
					{
						if(rightTouch.touchDeltafromBegin.magnitude < thresholdMag)
						{
							rightTouch.touchState = TouchState.TAP_ENDED;
						}
						mGui.SetRightTouch(rightTouch);
						rightFingerId = -1;
						rightTouch.touchHalf = 0;
						rightTouch.touchState = TouchState.NONE;
					}


				}


			}
			if(mGui.getPinchInStatus())
			{
			if(noOfTouches == 2)
			{
				if((rightFingerId != -1) && (leftFingerId != -1))
				{
					float leftX = Mathf.Abs(leftTouchDelta.x);
					float rightX = Mathf.Abs(rightTouchDelta.x);
					if((rightX > thresholdMag*0.3f) && (leftX > thresholdMag*0.3f))
					{
						if((leftTouchDelta.x < 0.0f) && (rightTouchDelta.x > 0.0f))
						{
							mGui.MoveSlider(leftX + rightX);
						}
						else if((leftTouchDelta.x > 0.0f) && (rightTouchDelta.x < 0.0f))
						{
							mGui.MoveSlider(-(leftX + rightX));
						}
					}
				}
			}
			}
		}
#else
		if(Input.GetMouseButtonDown(0))
		{
			Vector3 touchPos = Input.mousePosition;
			if(touchPos.y > 0.75f * Screen.height)
				return;
			mousePrevPos = touchPos;
			renderers[0].time = 0.0f;
			renderers[0].enabled = false;
			MeshRenderer ren = trail[0].GetComponent<MeshRenderer>();
			ren.enabled = false;
			trail[0].localPosition = new Vector3(touchPos.x - Screen.width,touchPos.y - Screen.height,100.0f); 
			renderers[0].enabled = true;
			Color col = new Color(1.0f,1.0f,1.0f,0.0f);
			ren.sharedMaterial.SetColor("_Color",col);
			ren.enabled = true;

			if(touchPos.x < Screen.width*0.5f)
			{
				if(leftFingerId == -1)
				{
					leftTouch.touchHalf = -1;
					leftFingerId = 0;
					leftTouchBeginPos = new Vector2(touchPos.x,touchPos.y);
					leftTouch.touchState = TouchState.TAP;
				}
				else
				{
					leftTouch.touchHalf = 0;
					leftFingerId = -1;
					mGui.SetLeftTouch(leftTouch);
				}
			}
			else
			{
				if(rightFingerId == -1)
				{
					rightTouch.touchHalf = 1;
					rightFingerId = 0;
					rightTouchBeginPos = new Vector2(touchPos.x,touchPos.y);
					rightTouch.touchState = TouchState.TAP;
				}
				else
				{
					rightTouch.touchHalf = 0;
					rightFingerId = -1;
					mGui.SetRightTouch(rightTouch);
				}
			}
		}
		else if(Input.GetMouseButton(0))
		{
			Vector3 touchPos = Input.mousePosition;
			if(touchPos.y > 0.75f * Screen.height)
				return;
			renderers[0].time = 0.6f;
			MeshRenderer ren = trail[0].GetComponent<MeshRenderer>();
			Color col = new Color(1.0f,1.0f,1.0f,190.0f/255.0f);
			ren.sharedMaterial.SetColor("_Color",col);
			Vector3 deltaPos = touchPos - mousePrevPos;
			mousePrevPos = touchPos;
			trail[0].localPosition = new Vector3(touchPos.x - Screen.width,touchPos.y - Screen.height,100.0f);
			if(leftFingerId == 0)
			{
				Vector2 dif = (new Vector2(touchPos.x,touchPos.y) - leftTouchBeginPos);
				if(!mGui.pinching)
				{
					leftTouch.touchDeltafromBegin = dif;
					mGui.SetLeftTouch(leftTouch);
				}
				leftTouchDelta = new Vector2(deltaPos.x,deltaPos.y);              
			}
			else if(rightFingerId == 0)
			{
				Vector2 dif = (new Vector2(touchPos.x,touchPos.y) - rightTouchBeginPos);
				if(!mGui.pinching)
				{
					rightTouch.touchDeltafromBegin = dif;
					mGui.SetRightTouch(rightTouch);
				}
				rightTouchDelta = new Vector2(deltaPos.x,deltaPos.y); 
			}
		}
		else if(Input.GetMouseButtonUp(0))
	    {
			StartCoroutine(DissolveSphere(trail[0].GetComponent<MeshRenderer>()));
			//trailId[currentTouch.fingerId] = -1;
			//renderers[currentTouch.fingerId].time = 0.0f;
			if(mGui.pinching)
			{
				mGui.pinching = false;
				rightTouch.touchHalf = 0;
				rightTouch.touchState = TouchState.NONE;
				leftTouch.touchHalf = 0;
				leftTouch.touchState = TouchState.NONE;
				rightFingerId = -1;
				leftFingerId = -1;
				return;
			}
			
			if(leftFingerId == 0)
			{
				if(leftTouch.touchDeltafromBegin.magnitude < thresholdMag)
				{
					leftTouch.touchState = TouchState.TAP_ENDED;
				}
				mGui.SetLeftTouch(leftTouch);
				leftFingerId = -1;
				leftTouch.touchHalf = 0;
				leftTouch.touchState = TouchState.NONE;
			}
			else if(rightFingerId == 0)
			{
				if(rightTouch.touchDeltafromBegin.magnitude < thresholdMag)
				{
					rightTouch.touchState = TouchState.TAP_ENDED;
				}
				mGui.SetRightTouch(rightTouch);
				rightFingerId = -1;
				rightTouch.touchHalf = 0;
				rightTouch.touchState = TouchState.NONE;
			}

		}
#endif


	}

	IEnumerator DissolveSphere(MeshRenderer ren)
	{
		Material mat = ren.sharedMaterial;
		float alpha = mat.GetColor("_Color").a;
		//Debug.Log ("alpha = " + alpha);
		while (alpha > 0.0f) 
		{
			alpha-=1.0f*Time.deltaTime;
			mat.SetColor("_Color",new Color(1.0f,1.0f,1.0f,alpha));
			yield return 0;
			alpha = mat.GetColor("_Color").a;
		}
	}


}
