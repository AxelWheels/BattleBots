using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
* Bool to disable all but required inputs (additionally to disable all inputs period?)
* Add ability to pause scene on step activating (so that feedback text can be shown to player)
* Add image to be set for each step to show required button
*/

public class InputStep : TutorialStep
{
    public List<string> m_Inputs = new List<string>();
    public List<string> m_ResetList = new List<string>();

    private void Start()
    {
        m_ResetList = new List<string>(m_Inputs);
    }

    private void OnEnable()
    {
        if (m_ResetList.Count == 0)
            m_ResetList = new List<string>(m_Inputs);

        ResetStep();
    }

    public override void StepProgress()
    {
        for (int i = 0; i < m_Inputs.Count; i++)
        {
            try
            {
                if (Input.GetButtonDown(m_Inputs[i] + "1"))
                {
                    m_Inputs.RemoveAt(i);
                    break;
                }
            }
            catch (Exception e)
            {
                Debug.Log("Invalid Input");
            }

            try
            {
                if (Mathf.Abs(Input.GetAxis(m_Inputs[i] + "_1")) > 0.75f)
                {
                    m_Inputs.RemoveAt(i);
                    break;
                }
            }
            catch (Exception e)
            {
                Debug.Log("Invalid Input");
            }
        }

        if (m_Inputs.Count == 0)
        {
            OnStepCompleted.Invoke();

            TutorialController.Instance.CompletedStep();
        }
    }

    public void ResetStep()
    {
        m_Inputs = new List<string>(m_ResetList);
    }
}
