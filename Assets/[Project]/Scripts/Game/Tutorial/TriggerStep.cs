using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerStep : TutorialStep
{
    public override void StepProgress()
    {
        if (GameObject.Find("TutorialTrigger").GetComponent<ObjectiveTrigger>().m_Triggered)
        {
            OnStepCompleted.Invoke();

            TutorialController.Instance.CompletedStep();
        }
    }
}
