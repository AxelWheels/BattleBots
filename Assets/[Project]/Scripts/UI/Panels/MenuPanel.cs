using UnityEngine;

/// <summary>
/// A component that controls the menu UI panel
/// </summary>
/// 
/// Daniel Beard
/// 
public class MenuPanel : UIPanel
{
    [SerializeField] private CanvasGroup m_MenuCanvasGroup;
    [SerializeField] private CanvasGroup m_SettingsCanvasGroup;

    [SerializeField] private GameObject m_SettingsFocusObject;

    private new void Update()
    {
        if (Input.GetButtonDown("B_All"))
        {
            if (GameController.Instance.InSettings)
            {
                ToggleSettings(false);
            }
        }

        CheckEventSystem();
    }

    public void ToggleSettings(bool lIn)
    {
        GameController.Instance.InSettings = lIn;

        if (lIn)
        {
            UIController.Instance.TransitionPanelIn(eUIPanel.Settings);
            StartCoroutine(SetEventSystem(UIController.Instance.UIPanels[eUIPanel.Settings]));
        }
        else
        {
            UIController.Instance.TransitionPanelOut(eUIPanel.Settings);
            StartCoroutine(SetEventSystem(this));
        }

        CG.interactable = !lIn;
        UIController.Instance.UIPanels[eUIPanel.Settings].CG.interactable = lIn;
    }
}
