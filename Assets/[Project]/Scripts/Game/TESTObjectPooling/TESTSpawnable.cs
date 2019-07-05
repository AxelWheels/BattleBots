using UnityEngine;

[RequireComponent( typeof( Rigidbody ) )]
public class TESTSpawnable : PooledObject
{
	Rigidbody body;

	void Awake()
	{
		body = GetComponent<Rigidbody>();
	}

	private void OnTriggerEnter( Collider other )
	{
		if( other.CompareTag( "KillPlane" ) )
		//NECESSARY for object pooling.
		{
			ReturnToPool();
		}
	}
}
