using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// A class that controls the main gameplay phase
/// </summary>
/// 
/// Daniel Beard
///
public class GameState : GameStateBase
{

	public override void PushState()
	{
		OnBegin();
	}

	protected override void OnBegin()
	{
		base.OnBegin();
		if( GameController.Instance.DebugMode )
		{
			UIController.Instance.GetScreen( eUIPanel.Debug ).Show();
		}
		UIController.Instance.ChangePanel( eUIPanel.Game );
	}

	public override void PopState()
	{
		OnEnd();
	}

	protected override void OnEnd()
	{
		base.OnEnd();
		UIController.Instance.GetScreen( eUIPanel.Debug ).Hide();

		GameController.Instance.ActivePlayerIDs.Clear();
		GameController.Instance.ActiveAIIDs.Clear();

		for( int i = 0; i < MatchController.Instance.CurrentPlayers.Count; i++ )
		{
			MatchController.Instance.CurrentPlayers[i].ResetVibration();
		}
	}
}
