using UnityEngine;

/// <summary>
/// A component that controls the menu UI panel
/// </summary>
/// 
/// Daniel Beard
/// 
public class MenuPanel : UIPanel
{
	[SerializeField] private Tweener m_SettingsTweener;

	[SerializeField] private CanvasGroup m_MenuCanvasGroup;
	[SerializeField] private CanvasGroup m_SettingsCanvasGroup;

	[SerializeField] private GameObject m_SettingsFocusObject;

	private void Update()
	{
		if( Input.GetButtonDown( "B_All" ) )
		{
			if( GameController.Instance.InSettings )
			{
				ToggleSettings( false );
			}
		}

		CheckEventSystem();
	}

	public void ToggleSettings( bool lIn )
	{
		GameController.Instance.InSettings = lIn;

		if( lIn )
		{
			UIController.Instance.TransitionPanelIn( eUIPanel.Settings );
			StartCoroutine( SetEventSystem( UIController.Instance.UIPanels[eUIPanel.Settings] ) );
		}
		else
		{
			UIController.Instance.TransitionPanelOut( eUIPanel.Settings );
			StartCoroutine( SetEventSystem( this ) );
		}

		CG.interactable = !lIn;
		UIController.Instance.UIPanels[eUIPanel.Settings].CG.interactable = lIn;
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
