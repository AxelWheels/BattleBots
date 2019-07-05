using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerStatsUI : MonoBehaviour
{
	[SerializeField] private Text m_DamageDealt;
	[SerializeField] private Text m_DamageTaken;
	[SerializeField] private Text m_Kills;
	[SerializeField] private Text m_Deaths;
	private PlayerStats m_PlayerStats;

	public PlayerStats Stats { set { m_PlayerStats = value; } }

	public void Initialise()
	{
		m_DamageDealt.text = m_PlayerStats.DamageDealt.ToString();
		m_DamageTaken.text = m_PlayerStats.DamageTaken.ToString();
		m_Kills.text = m_PlayerStats.Score.ToString();
		m_Deaths.text = m_PlayerStats.Deaths.ToString();
	}

	public void OnEnable()
	{
		Initialise();
	}

	public void SetTextColour( Color lColour )
	{
		m_DamageDealt.color = lColour;
		m_DamageTaken.color = lColour;
		m_Kills.color = lColour;
		m_Deaths.color = lColour;
	}
}
