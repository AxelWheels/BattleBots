using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum TrapType
{
	Blade,
	Fire,
	Hades
}

[CreateAssetMenu( fileName = "TrapData.asset", menuName = "Onyx/Create TrapData Object", order = 0 )]
public class TrapsData : ScriptableObject
{
	[SerializeField]
	private TrapType m_TrapType;
	[SerializeField]
	private int m_Damage = 0;
	[SerializeField]
	private float m_ArmedTime = 0f; //How fast does the trap reset/reload ; 1 second load time.
	[SerializeField]
	private float m_DisarmedTime = 0f;
	[SerializeField]
	private float m_HitStunTime = 0f;

	#region Properties
	public TrapType GetTrapTypes { get { return m_TrapType; } }
	public int Damage { get { return m_Damage; } }
	public float ArmedTime { get { return m_ArmedTime; } }
	public float DisarmedTime { get { return m_DisarmedTime; } }
	public float HitStunTime { get { return m_HitStunTime; } }
	#endregion
}