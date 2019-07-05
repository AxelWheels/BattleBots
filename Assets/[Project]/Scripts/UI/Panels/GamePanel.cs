using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// A component that controls the in-game UI panel
/// </summary>
/// 
/// Daniel Beard
/// 
public class GamePanel : UIPanel
{
	[SerializeField]
	private Text m_TimerText;
	[SerializeField]
	private GameObject m_TimerObject;
	[SerializeField]
	private GameObject m_Countdown;
	[SerializeField]
	private PlayerStatus[] m_Players;

	public GameObject Countdown { get { return m_Countdown; } }
	public PlayerStatus[] Players { get { return m_Players; } }

	private void Start()
	{
		MatchController.Instance.OnMatchStarted += OnMatchStarted;
		MatchController.Instance.OnMatchEnded += OnMatchEnded;
	}

	private void OnMatchStarted( GameModeData lGameData )
	{
		m_TimerObject.SetActive( !lGameData.UnlimitedTime );
	}

	private void OnMatchEnded()
	{
		m_TimerObject.SetActive( false );
	}

	private void Update()
	{
		if( MatchController.Instance.InProgress )
		{
			string lMinutes = ( Mathf.Floor( MatchController.Instance.TimeLeft / 60 ) ).ToString( "00" );
			string lSeconds = ( Mathf.Floor( MatchController.Instance.TimeLeft % 60 ) ).ToString( "00" );

			m_TimerText.text = lMinutes + ":" + lSeconds;
		}
	}

	public override void OnTransitionIn()
	{
		base.OnTransitionIn();
	}

	public override void OnTransitionOut()
	{
		base.OnTransitionOut();

		m_Countdown.SetActive( false );
	}

	public override void OnTransition()
	{
		base.OnTransition();
	}
}
