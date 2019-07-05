using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

//Base step that can be inherited from for more unique and complex steps
public class TutorialStep : MonoBehaviour
{
    //Holds list of sub steps if you need it
    [SerializeField]
    protected List<TutorialStep> m_SubSteps = new List<TutorialStep>();

    public int m_Order;
    public string m_StepExplanation;

    protected bool m_StepCompleted = false;

    //Can be set in inspector to invoke a method similar to a button. Use OnStepCompleted.Invoke() Can assign multiple methods to this
    public UnityEvent OnStepCompleted;

    public bool StepCompleted { get { return m_StepCompleted; } }

    //Check list of substeps have all completed
    protected bool SubStepsCompleted()
    {
        foreach (TutorialStep step in m_SubSteps)
        {
            if (!step.m_StepCompleted)
                return false;
        }

        return true;
    }

    virtual public void StepProgress()
    {

    }
}
