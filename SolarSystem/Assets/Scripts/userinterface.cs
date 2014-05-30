using UnityEngine;
using System.Collections;

public class userinterface : MonoBehaviour {

	// Use this for initialization
	Rect solarSysRect;
	Rect solarBackRect;

	Rect sunRect;
	Rect mercRect;
	Rect venusRect;
	Rect earthRect;
	Rect marsRect;
	Rect jupiterRect;
	Rect saturnRect;
	Rect neptuneRect;
	Rect uranusRect;
	Rect plutoRect;
	Rect moonRect;



	public enum Selection
	{
		none,
		sun,
		mercury,
		venus,
		earth,
		mars,
		jupiter,
		saturn,
		neptune,
		uranus,
		pluto,
		moon
	};

	public Selection currentSelection;


	public enum GUIState
	{
		sun,
		mercury,
		venus,
		earth,
		mars,
		jupiter,
		saturn,
		neptune,
		uranus,
		pluto,
		moon,
		none
	};
	public GUIState currentState;
	public Texture2D suntexture;
	public Texture2D suntextureName;
	public Texture2D mercurytexture;
	public Texture2D mercurytextureName;
	public Texture2D venustexture;
	public Texture2D venustextureName;
	public Texture2D earthtexture;
	public Texture2D earthtextureName;
	public Texture2D marstexture;
	public Texture2D marstextureName;
	public Texture2D jupitertexture;
	public Texture2D jupitertextureName;
	public Texture2D saturntexture;
	public Texture2D saturntextureName;
	public Texture2D neptunetexture;
	public Texture2D neptunetexture1;
	public Texture2D neptunetextureName;
	public Texture2D uranustexture;
	public Texture2D uranustextureName;
	public Texture2D moontexture;
	public Texture2D moontextureName;
	public Texture2D plutotexture;
	public Texture2D plutotextureName;

	public Texture2D solarbutton;
	public Texture2D quitbutton;
	public GUIStyle myguistyle;




	public bool freeMove = true;
	public bool showPlanetButtons = false;
	public bool firstLookaT = true;
	public bool showEarthSats = false;



	cameraMove cameraMovescript;
	GameObject cameraobject;
	welcomescreen welcomeobj;


	void Start () {
		solarBackRect = new Rect (Screen.width * 0.88f,Screen.height* 0.015f,90,40);
		solarSysRect = new Rect (Screen.width/2,Screen.height* 0.015f,120,60);
		sunRect = new Rect (Screen.width * 0.015f,Screen.height * 0.015f,70,40);
		mercRect = new Rect (Screen.width * 0.015f,Screen.height* 0.065f,70,40);
		venusRect = new Rect (Screen.width * 0.015f,Screen.height* 0.115f,70,40);
		earthRect = new Rect (Screen.width * 0.015f,Screen.height* 0.165f,70,40);
		marsRect = new Rect (Screen.width * 0.015f,Screen.height* 0.215f,70,40);
		jupiterRect = new Rect (Screen.width * 0.097f,Screen.height* 0.015f,70,40);
		saturnRect = new Rect (Screen.width * 0.179f,Screen.height* 0.015f,70,40);
		neptuneRect = new Rect (Screen.width * 0.261f,Screen.height* 0.015f,70,40);
		uranusRect = new Rect (Screen.width * 0.343f,Screen.height* 0.015f,70,40);
		plutoRect = new Rect (Screen.width * 0.425f,Screen.height* 0.015f,70,40);
		moonRect = new Rect (Screen.width * 0.88f,Screen.height/2,70,40);


		myguistyle = new GUIStyle ();

		cameraobject = GameObject.FindWithTag ("MainCamera"); 
		cameraMovescript = cameraobject.GetComponent<cameraMove> () as cameraMove;

		welcomeobj = cameraobject.GetComponent<welcomescreen> () as welcomescreen;
		if (audio.clip.isReadyToPlay) {
						audio.Play ();
				}
	}

	void OnGUI()
	{
		if(GUI.Button(new Rect(Screen.width * 0.88f,Screen.height* 0.88f,50,50),quitbutton,myguistyle))
		{
			Application.Quit();
		}
		
		if (freeMove && welcomeobj.startGamegui) 
		{
			if (GUI.Button (solarSysRect, solarbutton,myguistyle)) 
			{
				showPlanetButtons = !showPlanetButtons;
				freeMove = false;
				currentSelection = Selection.none;
				currentState = GUIState.none;
				//Debug.Log("In solar button:" + currentState);
			}
		}
		else if(!freeMove)
		{
			if(GUI.Button(solarBackRect,"Back"))
			{
				showPlanetButtons = false;
				freeMove = true;
			}
		}

		if (showEarthSats)
		{
			if (GUI.Button (moonRect, "Moon"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.moon;
				cameraMovescript.startTime = Time.time;
				cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position,cameraMovescript.planetCameraPosition);
				Debug.Log("Camera Object Position: "+cameraobject.transform.position + "| PlanetCamera Position: " +cameraMovescript.planetCameraPosition +"Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.moon;
				
			}
		}


		if (showPlanetButtons) 
		{
			if (GUI.Button (mercRect, "Mercury"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.mercury;
				cameraMovescript.startTime = Time.time;
				cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position,cameraMovescript.planetCameraPosition);
				Debug.Log("Camera Object Position: "+cameraobject.transform.position + "| PlanetCamera Position: " +cameraMovescript.planetCameraPosition +"Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.mercury;
				showEarthSats = false;
			}

			if (GUI.Button (venusRect, "Venus"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.venus;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.venus;
				showEarthSats = false;
			}

			if (GUI.Button (earthRect, "Earth"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.earth;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				showEarthSats = true;
				currentState = GUIState.earth;
			}

			if (GUI.Button (marsRect, "Mars"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.mars;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.mars;
				showEarthSats = false;
			}

			if (GUI.Button (jupiterRect, "Jupiter"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.jupiter;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.jupiter;
				showEarthSats = false;
			}

			if (GUI.Button (saturnRect, "Saturn"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.saturn;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.saturn;
				showEarthSats = false;
			}

			if (GUI.Button (neptuneRect, "Neptune"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.neptune;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.neptune;
				showEarthSats = false;
			}

			if (GUI.Button (uranusRect, "Uranus"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.uranus;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.uranus;
				showEarthSats = false;
			}

			if (GUI.Button (plutoRect, "Pluto"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.pluto;
                cameraMovescript.startTime = Time.time;
                cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position, cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				firstLookaT = true;
				currentState = GUIState.pluto;
				showEarthSats = false;
			}

			if (GUI.Button (sunRect, "Sun"))
			{
				cameraMovescript.defaultfieldofView =Camera.main.fieldOfView;
				currentSelection = Selection.sun;
				cameraMovescript.startTime = Time.time;
				firstLookaT = true;
				cameraMovescript.journeydistance = Vector3.Distance(cameraobject.transform.position,cameraMovescript.planetCameraPosition);
                Debug.Log("Camera Object Position: " + cameraobject.transform.position + "| PlanetCamera Position: " + cameraMovescript.planetCameraPosition + "Distance: " + cameraMovescript.journeydistance);
				currentState = GUIState.sun;
				showEarthSats = false;
			}

			else if(currentState == GUIState.sun)
			{
				Debug.Log("Current Gui State: " + currentState);
				GUI.Box(new Rect(Screen.width * 0.08f,Screen.height * 0.22f,suntexture.width/2,suntexture.height/2),suntexture);
				GUI.Box(new Rect(Screen.width * 0.08f,Screen.height * 0.12f,suntextureName.width/2,suntextureName.height/2),suntextureName);
			}

			else if(currentState == GUIState.mercury)
			{
				GUI.Box(new Rect(Screen.width * 0.48f,Screen.height * 0.22f,mercurytexture.width/2,mercurytexture.height/2),mercurytexture);
				GUI.Box(new Rect(Screen.width * 0.48f,Screen.height * 0.12f,mercurytextureName.width/2,mercurytextureName.height/2),mercurytextureName);
			}

			else if(currentState == GUIState.venus)
			{
				GUI.Box(new Rect(Screen.width * 0.24f,Screen.height * 0.26f,venustexture.width/2,venustexture.height/2),venustexture);
				GUI.Box(new Rect(Screen.width * 0.24f,Screen.height * 0.16f,venustextureName.width/2,venustextureName.height/2),venustextureName);
			}

			if(currentState == GUIState.earth)
			{
				GUI.Box(new Rect(Screen.width * 0.42f,Screen.height * 0.12f,earthtexture.width/2,earthtexture.height/2),earthtexture);
				GUI.Box(new Rect(Screen.width * 0.42f,Screen.height * 0.85f,earthtextureName.width/2,earthtextureName.height/2),earthtextureName);
			}

			if(currentState == GUIState.mars)
			{
				GUI.Box(new Rect(Screen.width * 0.52f,Screen.height * 0.1f,marstexture.width/2,marstexture.height/2),marstexture);
				GUI.Box(new Rect(Screen.width * 0.48f,Screen.height * 0.87f,marstextureName.width/2,marstextureName.height/2),marstextureName);
			}

			if(currentState == GUIState.jupiter)
			{
				GUI.Box(new Rect(Screen.width * 0.44f,Screen.height * 0.24f,jupitertexture.width/2,jupitertexture.height/2),jupitertexture);
				GUI.Box(new Rect(Screen.width * 0.44f,Screen.height * 0.10f,jupitertextureName.width/2,jupitertextureName.height/2),jupitertextureName);
			}

			if(currentState == GUIState.saturn)
			{
				GUI.Box(new Rect(Screen.width * 0.32f,Screen.height * 0.72f,saturntexture.width/2,saturntexture.height/2),saturntexture);
				GUI.Box(new Rect(Screen.width * 0.24f,Screen.height * 0.16f,saturntextureName.width/2,saturntextureName.height/2),saturntextureName);
			}

			if(currentState == GUIState.neptune)
			{
				GUI.Box(new Rect(Screen.width * 0.08f,Screen.height * 0.56f,neptunetexture1.width/2,neptunetexture1.height/2),neptunetexture1);
				GUI.Box(new Rect(Screen.width * 0.52f,Screen.height * 0.2f,neptunetexture.width,neptunetexture.height/2),neptunetexture);
				GUI.Box(new Rect(Screen.width * 0.5f,Screen.height * 0.1f,neptunetextureName.width/2,neptunetextureName.height/2),neptunetextureName);
			}

			if(currentState == GUIState.uranus)
			{
				GUI.Box(new Rect(Screen.width * 0.14f,Screen.height * 0.18f,uranustexture.width/1.2f,uranustexture.height/1.3f),uranustexture);
				GUI.Box(new Rect(Screen.width * 0.08f,Screen.height * 0.08f,uranustextureName.width/2,uranustextureName.height/2),uranustextureName);
			}

			if(currentState == GUIState.moon)
			{
				GUI.Box(new Rect(Screen.width * 0.44f,Screen.height * 0.18f,moontexture.width/2,moontexture.height/2),moontexture);
				GUI.Box(new Rect(Screen.width * 0.44f,Screen.height * 0.08f,moontextureName.width/2,moontextureName.height/2),moontextureName);
			}

			if(currentState == GUIState.pluto)
			{
				GUI.Box(new Rect(Screen.width * 0.14f,Screen.height * 0.7f,plutotexture.width/1.2f,plutotexture.height/1.5f),plutotexture);
				GUI.Box(new Rect(Screen.width * 0.28f,Screen.height * 0.08f,plutotextureName.width/2,plutotextureName.height/2),plutotextureName);
			}
			}


	}

	// Update is called once per frame
	void Update () {
		Debug.Log ("Selection: " + currentSelection);
	
	}



}
