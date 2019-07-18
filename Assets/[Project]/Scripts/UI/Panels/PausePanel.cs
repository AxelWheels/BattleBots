using UnityEngine;

/// <summary>
/// A class that controls the pause menu UIPanel
/// </summary>
/// 
/// Daniel Beard
///

public class PausePanel : UIPanel
{
    // Update is called once per frame
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
