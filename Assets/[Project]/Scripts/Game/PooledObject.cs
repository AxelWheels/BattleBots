using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Class to inherit from for any object that requires a pool.
/// </summary>
public class PooledObject : MonoBehaviour
{
	[SerializeField]
	public ObjectPool m_Pool;

	[System.NonSerialized]
	ObjectPool m_PoolInstanceForPrefab;

	public ObjectPool Pool
	{
		get
		{
			return m_Pool;
		}
		set
		{
			m_Pool = value;
		}
	}

	//Return an object to its corresponding object pool.
	public void ReturnToPool()
	{
		if( Pool )
		{
			Pool.AddObject( this );
		}
		else
		{

		}
	}

	public void ReturnToPool( float lKillTimer )
	{
		Invoke( "ReturnToPool", lKillTimer );
	}

	public void ReturnToPool( ObjectPool lPool )
	{
		this.Pool = lPool;
		Pool.AddObject( this );
	}

	//Generic function to allow creation of object pools of any type.
	public T GetPooledInstance<T>() where T : PooledObject
	{
		if( !m_PoolInstanceForPrefab )
		{
			m_PoolInstanceForPrefab = ObjectPool.GetPool( this );
		}
		return (T)m_PoolInstanceForPrefab.GetObject();
	}
}
