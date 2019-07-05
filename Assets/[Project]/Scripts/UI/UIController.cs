using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// A script that controls the enabling/disabling of UIPanels
/// </summary>
///
/// Daniel Beard
///

[Serializable]
public enum eUIPanel
{
	Debug = 0,
	Menu,
	Setup,
	Game,
	Pause,
	Results,
	Load,
	Ready,
	Tutorial,
	Settings
}

public class UIController : SingletonManager<UIController>
{
	public eUIPanel CurrentPanel
	{
		get { return m_CurrentPanel; }
		set { m_CurrentPanel = value; }
	}

	[SerializeField] private Transform m_GameUIParent;
	[SerializeField] private GameObject m_PlayerStatusPrefab;

	[SerializeField] private Transform m_ResultsUIParent;
	[SerializeField] private GameObject m_PlayerStatsObject;

	[SerializeField] private Dictionary<eUIPanel, UIPanel> m_UIPanels;

	[SerializeField] private SoundData m_UISoundData;
	[SerializeField] private string m_ChangePanelSound;

	private eUIPanel m_CurrentPanel = eUIPanel.Menu;

	public Dictionary<eUIPanel, UIPanel> UIPanels { get { return m_UIPanels; } }
	public Transform GameUIParent { get { return m_GameUIParent; } }
	public GameObject PlayerStatusPrefab { get { return m_PlayerStatusPrefab; } }
	public Transform ResultsUIParent { get { return m_ResultsUIParent; } }
	public GameObject PlayerStatsPrefab { get { return m_PlayerStatsObject; } }

	public void Awake()
	{
	}

	private void Update()
	{
	}

	public UIPanel GetScreen( eUIPanel lUIPanelType )
	{
		return m_UIPanels[lUIPanelType];
	}

	public void TransitionPanelIn( int lUIPanelType )
	{
		m_CurrentPanel = (eUIPanel)lUIPanelType;
		m_UIPanels[(eUIPanel)lUIPanelType].GetComponent<Tweener>().Play( false );
	}

	public void TransitionPanelIn( eUIPanel lUIPanelType )
	{
		m_UIPanels[lUIPanelType].GetComponent<Tweener>().Play( false );
	}

	public void TransitionPanelOut( int lUIPanelType )
	{
		m_UIPanels[(eUIPanel)lUIPanelType].GetComponent<Tweener>().Play( true );
	}

	public void TransitionPanelOut( eUIPanel lUIPanelType )
	{
		m_UIPanels[lUIPanelType].GetComponent<Tweener>().Play( true );
	}

	/// <summary>
	/// Transitions between 2 panels, if panel specifies delay next transition. Takes an int to be used as UnityEvent
	/// </summary>
	/// <param name="lUIPanelType"></param>
	public void ChangePanel( int lUIPanelType )
	{
		ChangePanel( (eUIPanel)lUIPanelType );
	}

	public void ChangePanel( eUIPanel lUIPanelType )
	{
		m_UIPanels[m_CurrentPanel].GetComponent<Tweener>().Play( true );

		//If transition hold is true delay next transition by the duration of the first tweener
		if( m_UIPanels[m_CurrentPanel].HoldTransition )
			StartCoroutine( DelayTransition( m_UIPanels[(eUIPanel)m_CurrentPanel].GetComponent<Tweener>().Duration, (int)lUIPanelType ) );
		else
			m_UIPanels[lUIPanelType].GetComponent<Tweener>().Play( false );

		SoundController.Instance.PlaySound( m_UISoundData.GetSound( m_ChangePanelSound ), CameraController.Instance.MenuCam.transform, false, m_UISoundData.GetVolume( m_ChangePanelSound ) );

		m_CurrentPanel = lUIPanelType;
	}

	private IEnumerator DelayTransition( float time, int lUIPanelType )
	{
		yield return new WaitForSecondsRealtime( time );

		m_UIPanels[(eUIPanel)lUIPanelType].GetComponent<Tweener>().Play( false );
	}
}
