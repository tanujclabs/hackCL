using UnityEngine;
using System.Collections;

/**
 * an object that the player can collide with
 */
public class CollidableObject : MonoBehaviour {
	
	// effect shown when collectible is picked up
	
	public string _type = "generic";
	public string MoveTowards= null;
	
	/**
	 * Displays collision box
	 */
	void OnDrawGizmos()
	{
		Matrix4x4 rotationMatrix = Matrix4x4.TRS(transform.position, transform.rotation, transform.lossyScale);
		Gizmos.matrix = rotationMatrix; 
		Gizmos.color = new Color (0,1,1,.5f);
		Gizmos.DrawCube(Vector3.zero, new Vector3(1f,1f,1f));
	}
	
	

}	
