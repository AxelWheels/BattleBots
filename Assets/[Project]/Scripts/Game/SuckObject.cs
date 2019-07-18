using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SuckObject : MonoBehaviour
{
	[SerializeField]
	private GameObject m_SuckEffect;

	// Use this for initialization
	[SerializeField]
	private float m_PullingPower;

	[SerializeField]
	private float m_ActiveTime;

	[SerializeField]
	private bool m_Permanent;

	private Collider m_OwnerCollider;

	private List<Rigidbody> m_PlayersInRange = new List<Rigidbody>();

	public Collider OwnerCollider { get { return m_OwnerCollider; } set { m_OwnerCollider = value; } }

	void Start()
	{
        if (m_SuckEffect != null)
        {
			//EffectsController.Instance.PlayEffectAtPosition( m_SuckEffect.name, transform.position, Quaternion.identity );
        }
	}

	// Update is called once per frame
	void Update()
	{
		if( !m_Permanent )
		{
			if( m_ActiveTime <= 0 )
			{
				Destroy( gameObject );
			}
		}

		m_ActiveTime = Mathf.Max( 0f, m_ActiveTime - Time.deltaTime );
	}

	private void FixedUpdate()
	{
		for( int i = 0; i < m_PlayersInRange.Count; i++ )
		{
			if( m_PlayersInRange[i] != null )
			{
				if( m_PlayersInRange[i].GetComponent<PlayerController>().Dead )
				{
					m_PlayersInRange.Remove( m_PlayersInRange[i] );
					i--;
				}
				else
				{
					Vector3 lDirection = gameObject.transform.position - m_PlayersInRange[i].transform.position;
					Vector3 lPull = new Vector3( lDirection.x, 0, lDirection.z );
					m_PlayersInRange[i].AddForce( lPull * m_PullingPower );
				}
			}
		}

	}

	private void OnTriggerEnter( Collider other )
	{
		if( other.tag == "Player" )
		{
			m_PlayersInRange.Add( other.GetComponentInParent<Rigidbody>() );
			if( !m_Permanent )
			{
				StartCoroutine( other.GetComponentInParent<PlayerController>().Detach( m_ActiveTime ) );
			}
			if( other != m_OwnerCollider )
			{
				other.GetComponentInParent<PlayerController>().ChangeHealth( m_OwnerCollider, 0 );
			}
		}
	}

	private void OnTriggerExit( Collider other )
	{
		if( other.tag == "Player" )
		{
			other.GetComponentInParent<Rigidbody>().velocity = Vector3.zero;
			m_PlayersInRange.Remove( other.GetComponentInParent<Rigidbody>() );
			other.GetComponentInParent<PlayerController>().ShouldDetach = false;

			if( other != m_OwnerCollider )
			{
				other.GetComponentInParent<PlayerController>().ChangeHealth( m_OwnerCollider, 0 );
			}
		}
	}
}
