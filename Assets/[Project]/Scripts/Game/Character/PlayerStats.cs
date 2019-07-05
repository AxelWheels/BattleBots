using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerStats
{
	private int m_DamageTaken = 0;
	private int m_DamageDealt = 0;
	private int m_Score = 0;
	private int m_Deaths = 0;
	private int m_TrapsTriggered = 0;
	private int m_PowerupsTaken = 0;
	private int m_Suicides = 0;
	private int m_BestSpree = 0;

	private float m_DistanceTravelled = 0.0f;
	private float m_LongestLife = 0.0f;

	public int DamageTaken { get { return m_DamageTaken; } }
	public int DamageDealt { get { return m_DamageDealt; } }
	public int Score { get { return m_Score; } set { m_Score = value; } }
	public int Deaths { get { return m_Deaths; } }
	public int TrapsTriggered { get { return m_TrapsTriggered; } }
	public int PowerupsTaken { get { return m_PowerupsTaken; } }
	public int Suicides { get { return m_Suicides; } }
	public int BestSpree { get { return m_BestSpree; } }

	public float DistanceTravelled { get { return m_DistanceTravelled; } }
	public float LongestLife { get { return m_LongestLife; } }

	public PlayerStats()
	{
		Initialise();
	}

	public void Initialise()
	{
		m_DamageTaken = 0;
		m_DamageDealt = 0;
		m_Score = 0;
		m_Deaths = 0;
		m_TrapsTriggered = 0;
		m_PowerupsTaken = 0;
	}

	public void AddDamageTaken( int lDamage )
	{
		m_DamageTaken += lDamage;
	}

	public void AddDamageDealt( int lDamage )
	{
		m_DamageDealt += lDamage;
	}

	public void IncrementScore()
	{
		m_Score++;
	}
	public void DecrementScore()
	{
		m_Score--;
	}

	public void IncrementDeaths()
	{
		m_Deaths++;
	}

	public void IncrementTrapsTriggered()
	{
		m_TrapsTriggered++;
	}

	public void IncrementPowerupsTaken()
	{
		m_PowerupsTaken++;
	}

	public void IncrementSuicides()
	{
		m_Suicides++;
	}

	public void AddDistanceTravelled( float lDistanceToAdd )
	{
		m_DistanceTravelled += lDistanceToAdd;
	}
}
