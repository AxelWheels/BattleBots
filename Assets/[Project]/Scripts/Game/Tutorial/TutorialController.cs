using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TutorialController : SingletonManager<TutorialController>
{
    [SerializeField]
    public List<TutorialStep> m_TutorialSteps = new List<TutorialStep>();

    public Text m_StepText;

    private TutorialStep m_CurrentStep;

    public TutorialStep StepOrder(int lOrder)
    {
        for (int i = 0; i < m_TutorialSteps.Count; i++)
        {
            if (m_TutorialSteps[i].m_Order == lOrder)
                return m_TutorialSteps[i];
        }
        return null;
    }

    // Use this for initialization
    void Start()
    {
        //NextStep( 0 );
    }

    private void OnEnable()
    {
        NextStep(0);
    }

    // Update is called once per frame
    void Update()
    {
        if (m_CurrentStep != null)
        {
            if (!m_CurrentStep.StepCompleted)
                m_CurrentStep.StepProgress();
        }
    }

    public void CompletedStep()
    {
        NextStep(m_CurrentStep.m_Order + 1);
    }

    public void NextStep(int lStepOrder)
    {
        m_CurrentStep = StepOrder(lStepOrder);

        if (!m_CurrentStep)
        {
            TutorialFinished();
            return;
        }

        m_StepText.text = m_CurrentStep.m_StepExplanation;
    }

    public void TutorialFinished()
    {
        m_CurrentStep = null;
        m_StepText.text = "Congratulations! You have completed the tutorial!";
    }
}
