using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu( fileName = "EffectObjectData.asset", menuName = "Onyx/Create Effect Object", order = 0 )]
public class EffectObjectData : ScriptableObject
{
	[SerializeField]
	private Effect m_Object;
	[SerializeField]
	private int m_InitialPoolInstances = 2;
	[SerializeField]
	private float m_Duration = 5.0f;

	public Effect Object
	{
		get
		{
			return m_Object;
		}

		set
		{
			m_Object = value;
		}
	}

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
}
