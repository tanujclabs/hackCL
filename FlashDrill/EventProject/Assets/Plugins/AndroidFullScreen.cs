using UnityEngine;
using System.Collections;
using System.IO;

public class AndroidFullScreen : MonoBehaviour {

	// Use this for initialization
	void Awake () {
		//DisableSystemUI();
	}
	
	// Update is called once per frame
	void Update () {

	}

	static AndroidJavaObject activityInstance;
	static AndroidJavaObject windowInstance;	
	static AndroidJavaObject viewInstance;
	public delegate void RunPtr();
	
	public static void Run()
	{
		if (viewInstance != null) {
			viewInstance.Call("setSystemUiVisibility", 1|2|4|256|512|1024|2048|4096);
			//viewInstance.Call("setNavVisibility", false);
		}	
	}

	public static void DisableSystemUI()	
	{
		if (Application.platform != RuntimePlatform.Android)		
			return;
		DisableNavUI();
		
	}

	static void DisableNavUI()	
	{
		if (Application.platform != RuntimePlatform.Android)	
			return;		
		
		using (AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
		{
			activityInstance = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");	
			windowInstance = activityInstance.Call<AndroidJavaObject>("getWindow");
			viewInstance = windowInstance.Call<AndroidJavaObject>("getDecorView");			
			
			AndroidJavaRunnable RunThis;
			RunThis = new AndroidJavaRunnable(new RunPtr(Run));
			
			activityInstance.Call("runOnUiThread", RunThis);			
		}
	}
}
