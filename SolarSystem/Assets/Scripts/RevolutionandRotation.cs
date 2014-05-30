using UnityEngine;
using System.Collections;

public class RevolutionandRotation : MonoBehaviour {

	// Use this for initialization
	public Transform earthAxis;
	public Transform earthModel;
	public Transform marsAxis;
	public Transform marsModel;
	public Transform mercuryAxis;
	public Transform mercuryModel;
	public Transform sunAxis;
	public Transform sunModel;
	public Transform venusAxis;
	public Transform venusModel;
	public Transform jupiterAxis;
	public Transform jupiterModel;
	public Transform saturnAxis;
	public Transform saturnModel;
	public Transform neptuneAxis;
	public Transform neptuneModel;
	public Transform uranusAxis;
	public Transform uranusModel;
	public Transform plutoAxis;
	public Transform plutoModel;
	public Transform moonModel;
	public Transform moonAxis;

	public Vector3 SunrotateSpeed;
	public Vector3 MercuryrotateSpeed;
	public Vector3 VenusrotateSpeed;
	public Vector3 EarthrotateSpeed;
	public Vector3 MarsrotateSpeed;
	public Vector3 JupiterrotateSpeed;
	public Vector3 SaturnrotateSpeed;
	public Vector3 NeptunerotateSpeed;
	public Vector3 UranusrotateSpeed;
	public Vector3 PlutorotateSpeed;
	public Vector3 MoonrotateSpeed;

	public Vector3 mercuryRevoluteSpeed;
	public Vector3 venusRevoluteSpeed;
	public Vector3 earthRevoluteSpeed;
	public Vector3 marsRevoluteSpeed;
	public Vector3 jupiterRevoluteSpeed;
	public Vector3 saturnRevoluteSpeed;
	public Vector3 uranusRevoluteSpeed;
	public Vector3 neptuneRevoluteSpeed;
	public Vector3 plutoRevoluteSpeed;
	public Vector3 moonRevoluteSpeed;
	ArrayList planetAxisList = new ArrayList(10);


	void Start () {
		earthAxis = this.gameObject.transform.Find ("EarthAxis");
		earthModel = earthAxis.Find ("Earth");

		marsAxis = this.gameObject.transform.Find ("MarsAxis");
		marsModel = marsAxis.Find("Mars");

		jupiterAxis = this.gameObject.transform.Find ("JupiterAxis");
		jupiterModel = jupiterAxis.Find ("Jupiter");

		saturnAxis = this.gameObject.transform.Find ("SaturnAxis");
		saturnModel = saturnAxis.Find ("Saturn");

		uranusAxis = this.gameObject.transform.Find ("UranusAxis");
		uranusModel = uranusAxis.Find ("Uranus");

		neptuneAxis = this.gameObject.transform.Find ("NeptuneAxis");
		neptuneModel = neptuneAxis.Find ("Neptune");

		plutoAxis = this.gameObject.transform.Find ("PlutoAxis");
		plutoModel = plutoAxis.Find ("Pluto");

		venusAxis = this.gameObject.transform.Find ("VenusAxis");
		venusModel = venusAxis.Find ("Venus");

		mercuryAxis = this.gameObject.transform.Find ("MercuryAxis");
		mercuryModel = mercuryAxis.Find ("Mercury");

		sunAxis = this.gameObject.transform.Find ("SunAxis");
		sunModel = sunAxis.Find ("Sun");

		moonAxis = earthModel.Find ("MoonAxis");
		moonModel = moonAxis.Find ("Moon");

		planetAxisList.Add (earthAxis);
		planetAxisList.Add (marsAxis);
		planetAxisList.Add (jupiterAxis);
		planetAxisList.Add (saturnAxis);
		planetAxisList.Add (uranusAxis);
		planetAxisList.Add (neptuneAxis);
		planetAxisList.Add (plutoAxis);
		planetAxisList.Add (venusAxis);
		planetAxisList.Add (mercuryAxis);
		planetAxisList.Add (sunAxis);

	
	}
	
	// Update is called once per frame
	void Update () {

		//sunAxis.transform.Rotate (SunrotateSpeed * Time.smoothDeltaTime);
		mercuryAxis.transform.Rotate (mercuryRevoluteSpeed * Time.smoothDeltaTime);
		venusAxis.transform.Rotate (venusRevoluteSpeed * Time.smoothDeltaTime);
		earthAxis.transform.Rotate (earthRevoluteSpeed * Time.smoothDeltaTime);
		marsAxis.transform.Rotate (marsRevoluteSpeed * Time.smoothDeltaTime);
		jupiterAxis.transform.Rotate (jupiterRevoluteSpeed * Time.smoothDeltaTime);
		saturnAxis.transform.Rotate (saturnRevoluteSpeed * Time.smoothDeltaTime);
		neptuneAxis.transform.Rotate (neptuneRevoluteSpeed * Time.smoothDeltaTime);
		uranusAxis.transform.Rotate (uranusRevoluteSpeed * Time.smoothDeltaTime);
		plutoAxis.transform.Rotate (plutoRevoluteSpeed * Time.smoothDeltaTime);
		moonAxis.transform.Rotate (moonRevoluteSpeed * Time.smoothDeltaTime);

		mercuryModel.Rotate (MercuryrotateSpeed * Time.smoothDeltaTime);
		venusModel.Rotate (VenusrotateSpeed * Time.smoothDeltaTime);
		earthModel.Rotate (EarthrotateSpeed * Time.smoothDeltaTime);
		moonModel.Rotate (MoonrotateSpeed * Time.smoothDeltaTime);
		marsModel.Rotate (MarsrotateSpeed * Time.smoothDeltaTime);
		jupiterModel.Rotate (JupiterrotateSpeed * Time.smoothDeltaTime);
		saturnModel.Rotate (SaturnrotateSpeed * Time.smoothDeltaTime);
		neptuneModel.Rotate (NeptunerotateSpeed * Time.smoothDeltaTime);
		uranusModel.Rotate (UranusrotateSpeed * Time.smoothDeltaTime);
		plutoModel.Rotate (PlutorotateSpeed * Time.smoothDeltaTime);
		sunModel.Rotate (SunrotateSpeed *Time.smoothDeltaTime);

	
	}
}
