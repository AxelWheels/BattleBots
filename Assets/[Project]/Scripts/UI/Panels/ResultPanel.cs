﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// A class that controls the result state's UIPanel
/// </summary>
/// 
/// Daniel Beard
///

public class ResultPanel : UIPanel
{
	[SerializeField] private Image[] m_WinnerSprite;
	[SerializeField] private GameObject[] m_PodiumMechs;

	public Image[] WinnerSprite { get { return m_WinnerSprite; } set { m_WinnerSprite = value; } }
	public GameObject[] PodiumMechs { get { return m_PodiumMechs; } set { m_PodiumMechs = value; } }

	private void Update()
	{
		CheckEventSystem();
	}

	public void SetMenuState()
	{
		GameController.Instance.ChangeState( new MenuState() );
	}

	public void DisablePodiums()
	{
		for( int i = 0; i < m_PodiumMechs.Length; i++ )
		{
			m_PodiumMechs[i].SetActive( false );
		}
	}

	public override void OnTransitionIn()
	{
		base.OnTransitionIn();
	}

	public override void OnTransitionOut()
	{
		base.OnTransitionOut();
	}

	public override void OnTransition()
	{
		base.OnTransition();
	}
}
