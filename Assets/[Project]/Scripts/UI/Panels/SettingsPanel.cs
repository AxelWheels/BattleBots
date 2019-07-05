using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class SettingsPanel : UIPanel
{
	[SerializeField] private GameObject m_GameUI;
	[SerializeField] private PostProcessVolume m_PPV;

	public void TogglePostProcessing( bool lValue )
	{
		m_PPV.enabled = lValue;
	}

	public void ToggleGameUI( bool lValue )
	{
		m_GameUI.SetActive( lValue );
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
