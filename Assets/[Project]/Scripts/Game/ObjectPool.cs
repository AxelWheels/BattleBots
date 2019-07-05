using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Class that is able to pool objects on start so that they may be retrieved from their respective pools rather than being instantiated.
/// </summary>
public class ObjectPool : MonoBehaviour
{
	[SerializeField]
	private PooledObject m_Prefab;
	[SerializeField]
	private List<PooledObject> m_AvailableObjects = new List<PooledObject>();

	//Returns the object at the last available index in the pool.
	public PooledObject GetObject()
	{
		PooledObject lObj;
		int lLastAvailableIndex = m_AvailableObjects.Count - 1;

		if( lLastAvailableIndex >= 0 && m_AvailableObjects[lLastAvailableIndex] != null )
		{
			lObj = m_AvailableObjects[lLastAvailableIndex];
			m_AvailableObjects.RemoveAt( lLastAvailableIndex );
			lObj.gameObject.SetActive( true );
		}
		else
		{
			lObj = Instantiate<PooledObject>( m_Prefab );
			lObj.name = m_Prefab.name;
			lObj.transform.SetParent( transform, false );
			lObj.Pool = this;
		}
		return lObj;
	}

	//Add an object to an object pool of its type.
	public void AddObject( PooledObject lObj )
	{
		lObj.gameObject.SetActive( false );
		m_AvailableObjects.Add( lObj );
	}

	//Returns a pool instance for the prefab.
	public static ObjectPool GetPool( PooledObject m_Prefab )
	{
		GameObject lObj;
		ObjectPool lPool;

		//Prevents multiple pools with the same name from being created in the editor.
		if( Application.isEditor )
		{
			lObj = GameObject.Find( m_Prefab.name + " Pool" );
			if( lObj )
			{
				lPool = lObj.GetComponent<ObjectPool>();
				if( lPool )
				{
					return lPool;
				}
			}
		}

		lObj = new GameObject( m_Prefab.name + " Pool" );
		lPool = lObj.AddComponent<ObjectPool>();
		lPool.m_Prefab = m_Prefab;
		//lObj.transform.parent = EffectsController.Instance.PoolParent.transform;
		return lPool;
	}
}
