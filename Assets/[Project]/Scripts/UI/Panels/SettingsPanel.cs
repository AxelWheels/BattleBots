using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class SettingsPanel : UIPanel
{
    [SerializeField] private GameObject m_GameUI;
    [SerializeField] private PostProcessVolume m_PPV;

    public void TogglePostProcessing(bool lValue)
    {
        m_PPV.enabled = lValue;
    }

    public void ToggleGameUI(bool lValue)
    {
        m_GameUI.SetActive(lValue);
    }
}
