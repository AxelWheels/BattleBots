using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PracticeState : GameStateBase
{
	public override void PushState()
	{
		OnBegin();
	}

	protected override void OnBegin()
	{
		base.OnBegin();

		UIController.Instance.ChangePanel( eUIPanel.Game );
		UIController.Instance.TransitionPanelIn( eUIPanel.Tutorial );
	}
	public override void PopState()
	{
		OnEnd();
	}

	protected override void OnEnd()
	{
		base.OnEnd();

		UIController.Instance.TransitionPanelOut( eUIPanel.Tutorial );
		GameController.Instance.Tutorial = false;
	}
}
