#pragma strict

var adjustSpeed : float = 1;
private var fromRotation : Quaternion;
private var toRotation : Quaternion;
private var targetNormal : Vector3;
private var hit : RaycastHit;
private var weight : float = 1;
 
function Start() {
    targetNormal = transform.up;
}
 
function FixedUpdate() 
{
    if( Physics.Raycast (transform.position, -Vector3.up, hit)) {
        if(hit.distance >.9) rigidbody.AddForce(-Vector3.up * 350000);
        if(hit.normal == transform.up) return;
        if(hit.normal != targetNormal) {
            targetNormal = hit.normal;
            fromRotation = transform.rotation;
            toRotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
            weight = 0;
        }
        if(weight <= 1) {
            weight += Time.deltaTime * adjustSpeed;
            transform.rotation = Quaternion.Slerp(fromRotation, toRotation, weight);
            //Or to smooth the weight
            //tranform.rotation = Quaternion.Slerp(fromRotation, toRotation,
            //                                        Mathf.SmoothStep(weight));
        }
    }
    
    rigidbody.velocity = Vector3( 100, 0, 0 );
}