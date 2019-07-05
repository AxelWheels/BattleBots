using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu( fileName = "GameModeData.asset", menuName = "Onyx/Create GameModeData Object", order = 0 )]
public class GameModeData : ScriptableObject
{
	[SerializeField]
	private string m_GameModeName = "NewGameMode";

	[Header( "Lives Options" )]
	[SerializeField]
	private bool m_UnlimitedLives = false;
	[SerializeField]
	private int m_NumberOfLives = 0;

	[Header( "Time Options" )]
	[SerializeField]
	private bool m_UnlimitedTime = false;
	[SerializeField]
	private float m_TimeLimit = 0.0f;

	[Header( "Game Options" )]
	[SerializeField]
	private bool m_Powerups = false;
	[SerializeField]
	private bool m_Traps = false;

	public bool UnlimitedLives { get { return m_UnlimitedLives; } }
	public int NumberOfLives { get { return m_NumberOfLives; } }

	public bool UnlimitedTime { get { return m_UnlimitedTime; } }
	public float TimeLimit { get { return m_TimeLimit; } }

	public bool Powerups { get { return m_Powerups; } }
	public bool Traps { get { return m_Traps; } }
}