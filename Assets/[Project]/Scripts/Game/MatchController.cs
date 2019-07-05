using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MatchController : SingletonManager<MatchController>
{
	private MatchData m_MatchData;

	[SerializeField]
	private SoundData m_AnnouncerSounds;
	[SerializeField]
	private SoundData m_GameSounds;

	[SerializeField]
	private string m_MatchStartSound;
	[SerializeField]
	private string m_AnnouncerStartSound;
	[SerializeField]
	private string m_MatchEndSound;
	[SerializeField]
	private string m_AnnouncerEndSound;

	[SerializeField]
	private float m_CountdownTime = 0;
	[SerializeField]
	private float m_EndMatchTime = 0;

	private List<PlayerController> m_CurrentPlayers;
	private GameModeData m_GameModeData;

	private bool m_InProgress = false;

	private int m_PlayersLeft = 4;

	private float m_TimeLeft = float.MaxValue;

	public List<PlayerController> CurrentPlayers { get { return m_CurrentPlayers; } }
	public GameModeData GameModeData { get { return m_GameModeData; } }

	public bool InProgress { get { return m_InProgress; } }

	public int PlayersLeft { get { return m_PlayersLeft; } set { m_PlayersLeft = value; } }

	public float TimeLeft { get { return m_TimeLeft; } }

	public delegate void MatchStarted( GameModeData lGameData );
	public event MatchStarted OnMatchStarted;

	public delegate void MatchEnded();
	public event MatchEnded OnMatchEnded;

	private void Start()
	{
		ArenaController.Instance.OnArenaLoad += OnArenaLoad;
	}

	private void Update()
	{
		if( m_GameModeData != null )
		{
			if( m_InProgress )
			{
				if( !GameController.Instance.Paused && !m_GameModeData.UnlimitedTime )
				{
					m_TimeLeft -= Time.unscaledDeltaTime;
				}

				CheckEndConditions();
			}
		}
	}

	private void OnArenaLoad( string lArena )
	{
		StartCoroutine( StartMatchRoutine() );
	}

	public void SetupMatch( string lArena, GameModeData lGameMode, int lNumberOfPlayers )
	{
		ArenaController.Instance.LoadArena( lArena );

		m_GameModeData = lGameMode;

		m_CurrentPlayers = GameController.Instance.SpawnPlayers( lNumberOfPlayers );

		m_PlayersLeft = lNumberOfPlayers;

		if( !m_GameModeData.UnlimitedTime )
		{
			m_TimeLeft = m_GameModeData.TimeLimit;
		}

		if( !m_GameModeData.UnlimitedLives )
		{
			for( int i = 0; i < m_CurrentPlayers.Count; i++ )
			{
				//Debug.Log( m_GameModeData.NumberOfLives );
				m_CurrentPlayers[i].Lives = m_GameModeData.NumberOfLives;
				m_CurrentPlayers[i].PlayerStatus.SetupLivesUI();
				m_CurrentPlayers[i].CanInput = false;
			}
		}
		else
		{
			for( int i = 0; i < m_CurrentPlayers.Count; i++ )
			{
				m_CurrentPlayers[i].Lives = int.MaxValue;
			}
		}
	}

	public void StartMatch()
	{
		SoundController.Instance.PlaySound( m_GameSounds.GetSound( m_MatchStartSound ), Camera.main.transform, false, m_GameSounds.GetVolume( m_MatchStartSound ) );
		SoundController.Instance.PlaySound( m_AnnouncerSounds.GetSound( m_AnnouncerStartSound ), Camera.main.transform, false, m_AnnouncerSounds.GetVolume( m_AnnouncerStartSound ) );

		for( int i = 0; i < m_CurrentPlayers.Count; i++ )
		{
			m_CurrentPlayers[i].CanInput = true;
		}

		m_InProgress = true;

		if( OnMatchStarted != null )
		{
			OnMatchStarted( m_GameModeData );
		}
	}

	public void RemovePlayer( PlayerController lPlayer )
	{
		m_CurrentPlayers.Remove( lPlayer );
	}

	public void DespawnPlayers()
	{
		for( int i = m_CurrentPlayers.Count; --i >= 0; )
		{
			Destroy( m_CurrentPlayers[i].gameObject );

			m_CurrentPlayers.Remove( m_CurrentPlayers[i] );
		}
	}

	private void CheckEndConditions()
	{
		bool lCanEnd = false;

		if( !m_GameModeData.UnlimitedTime )
		{
			if( m_TimeLeft <= 0 )
			{
				lCanEnd = true;
			}
		}

		if( !m_GameModeData.UnlimitedLives )
		{
			if( m_PlayersLeft <= 1 )
			{
				lCanEnd = true;
			}
		}

		if( lCanEnd )
		{
			EndMatch();
		}
	}

	public void EndMatch()
	{
		SoundController.Instance.PlaySound( m_GameSounds.GetSound( m_MatchEndSound ), Camera.main.transform, false, m_GameSounds.GetVolume( m_MatchEndSound ) );
		SoundController.Instance.PlaySound( m_AnnouncerSounds.GetSound( m_AnnouncerEndSound ), Camera.main.transform, false, m_AnnouncerSounds.GetVolume( m_AnnouncerEndSound ) );

		SceneManager.SetActiveScene( SceneManager.GetSceneByName( "MainScene" ) );

		for( int i = 0; i < CurrentPlayers.Count; i++ )
		{
			CurrentPlayers[i].ResetVibration();
		}

		//Sort players in descending order based on kills
		m_CurrentPlayers.Sort( ( PlayerController lA, PlayerController lB ) => lB.PlayerStats.Score.CompareTo( lA.PlayerStats.Score ) );

		ResultPanel lResultPanel = (ResultPanel)UIController.Instance.UIPanels[eUIPanel.Results];
		lResultPanel.DisablePodiums();

		//After sort set kills to highest kill in match
		int lKills = m_CurrentPlayers[0].PlayerStats.Score;
		int lPlayerPlacement = 0;

		//Set Results screen mech colours and order mechs appropriately
		for( int i = 0; i < m_CurrentPlayers.Count; i++ )
		{
			//Debug.Log( m_CurrentPlayers[i].PlayerColour.ColourName );

			m_CurrentPlayers[i].PlayerStatsObject = GameObject.Instantiate( UIController.Instance.PlayerStatsPrefab, UIController.Instance.ResultsUIParent );

			GameController.Instance.SetMechMaterial( lResultPanel.PodiumMechs[i], m_CurrentPlayers[i].PlayerColour );

			m_CurrentPlayers[i].CanInput = false;
			lResultPanel.PodiumMechs[i].SetActive( true );

			if( lKills > m_CurrentPlayers[i].PlayerStats.Score )
			{
				lKills = m_CurrentPlayers[i].PlayerStats.Score;

				lPlayerPlacement++;
			}

			if( !GameModeData.UnlimitedLives )
				m_CurrentPlayers[i].PlayerStats.Score = lPlayerPlacement + 1;

			//Initialise PlayerStats for the results screen
			PlayerStatsUI lPlayerStats = m_CurrentPlayers[i].PlayerStatsObject.GetComponent<PlayerStatsUI>();
			lPlayerStats.Stats = m_CurrentPlayers[i].PlayerStats;
			lPlayerStats.SetTextColour( m_CurrentPlayers[i].PlayerColour.PColour );
			lPlayerStats.Initialise();

			Vector3 lPos = lResultPanel.PodiumMechs[i].transform.localPosition;
			//7.5f is current standard height of podiums, CHANGE AT SOME POINT - Alex C
			lPos.y = 7.5f + ( lPlayerPlacement * -1.5f );
			lResultPanel.PodiumMechs[i].transform.localPosition = lPos;

			m_CurrentPlayers[i].PlayerStatus.ResetLivesUI();
		}

		m_InProgress = false;

		GamePanel lGP = (GamePanel)UIController.Instance.UIPanels[eUIPanel.Game];

		for( int i = 0; i < lGP.Players.Length; i++ )
		{
			lGP.Players[i].gameObject.SetActive( false );
		}

		UIController.Instance.ChangePanel( eUIPanel.Results );

		StartCoroutine( EndMatchRoutine() );

		if( OnMatchEnded != null )
		{
			OnMatchEnded();
		}

	}

	private IEnumerator StartMatchRoutine()
	{
		//Countdown sounds and graphics
		GamePanel lGP = (GamePanel)UIController.Instance.UIPanels[eUIPanel.Game];
		lGP.Countdown.SetActive( true );
		lGP.Countdown.GetComponent<Animation>().Play();

		yield return new WaitForSecondsRealtime( m_CountdownTime );

		StartMatch();
	}

	private IEnumerator EndMatchRoutine()
	{
		yield return new WaitForSecondsRealtime( m_EndMatchTime );

		ArenaController.Instance.UnloadArena();

		DespawnPlayers();

		GameController.Instance.ChangeState( new ResultState() );
	}
}
