using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectsController : SingletonManager<EffectsController>
{
	[SerializeField]
	private List<PooledObject> m_EffectsData = new List<PooledObject>();

	[SerializeField]
	private GameObject m_PoolParent;

	[SerializeField]
	private int m_PoolSize = 5;

	[SerializeField]
	private float m_EffectKillTimer = 1;

	public GameObject PoolParent
	{
		get
		{
			return m_PoolParent;
		}
	}

	public void CreatePools()
	{
		for( int i = 0; i < m_EffectsData.Count; i++ )
		{
			for( int j = 0; j < m_PoolSize; j++ )
			{
				PooledObject lSpawn = m_EffectsData[i].GetPooledInstance<PooledObject>();
				lSpawn.ReturnToPool( 0 );
			}
		}
	}

	public void PlayEffectAtPosition( string lName, Vector3 lPosition, Quaternion lRotation, float lDelay, Transform lParent = null )
	{
		StartCoroutine( DelayEffectRoutine( lName, lPosition, lRotation, lDelay, lParent ) );
	}

	//Overloaded function for using object pools. Needs extra looking into.
	public void PlayEffectAtPosition( string lName, Vector3 lPosition, Quaternion lRotation, Transform lParent = null, float lKillTimer = 0.0f )
	{
		PooledObject lEffect = FindEffectByName( lName );
		PooledObject lSpawn = lEffect.GetPooledInstance<PooledObject>();

		lSpawn.transform.position = lPosition;
		lSpawn.transform.rotation = lRotation;

		if( lParent != null )
		{
			lSpawn.transform.parent = lParent;
		}

		if( lKillTimer != 0.0f )
		{
			lSpawn.ReturnToPool( lKillTimer );
		}
		else
		{
			lSpawn.ReturnToPool( m_EffectKillTimer );
		}
	}

	public void PlayEffectAtPosition( string lName, Vector3 lPosition, Quaternion lRotation, Vector3 lLocalPosition, Transform lParent = null, float lKillTimer = 0.0f )
	{
		PooledObject lEffect = FindEffectByName( lName );
		PooledObject lSpawn = lEffect.GetPooledInstance<PooledObject>();

		lSpawn.transform.position = lPosition;
		lSpawn.transform.rotation = lRotation;

		if( lParent != null )
		{
			lSpawn.transform.parent = lParent;
			lSpawn.transform.localPosition = lLocalPosition;

		}

		if( lKillTimer != 0.0f )
		{
			lSpawn.ReturnToPool( lKillTimer );
		}
		else
		{
			lSpawn.ReturnToPool( m_EffectKillTimer );
		}
	}

	public PooledObject FindEffectByName( string lName )
	{
		foreach( PooledObject lObject in m_EffectsData )
		{
			if( lObject.name == lName )
			{
				return lObject;
			}
		}
		return null;
	}

	private IEnumerator DelayEffectRoutine( string lName, Vector3 lPosition, Quaternion lRotation, float lDelay, Transform lParent = null )
	{
		while( true )
		{
			yield return new WaitForSeconds( lDelay );

			PlayEffectAtPosition( lName, lPosition, lRotation, lParent );

			break;
		}
	}

	private void Start()
	{
		CreatePools();
	}
}
