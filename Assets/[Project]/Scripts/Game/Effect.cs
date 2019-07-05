using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Effect : PooledObject
{
	//If needed
	[SerializeField]
	private int m_InitialPoolInstances = 2;
	[SerializeField]
	private float m_Duration = 5.0f;

	#region Properties
	public int InitialPoolInstances
	{
		get
		{
			return m_InitialPoolInstances;
		}

		set
		{
			m_InitialPoolInstances = value;
		}
	}

	public float Duration
	{
		get
		{
			return m_Duration;
		}

		set
		{
			m_Duration = value;
		}
	}
	#endregion
}
