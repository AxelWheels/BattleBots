using System.Collections;
using UnityEngine;

public class TimeController : SingletonManager<TimeController>
{
    [SerializeField]
    private AnimationCurve m_TimeDampCurve;

    [SerializeField]
    private SoundData m_SoundData;

    [SerializeField]
    private string m_SlowTimeSound;

    private Coroutine m_DampenTimeRoutine;

    private bool m_SlowTime = false;

    private void Start()
    {
        GameController.Instance.OnGameStateChange += OnGameStateChange;
    }

    private void OnGameStateChange(GameStateBase lState)
    {
        Time.timeScale = 1.0f;
    }

    public void TryDampenTime()
    {
        //if( !m_SlowTime )
        //{
        //	SoundController.Instance.PlaySound( m_SoundData.GetSound( m_SlowTimeSound ), Camera.main.transform, false, 0.02f);

        //	//Just in case the coroutine is still running for some reason
        //	if( m_DampenTimeRoutine != null && MatchController.Instance.InProgress )
        //	{
        //		StopCoroutine( m_DampenTimeRoutine );
        //	}

        //	m_DampenTimeRoutine = StartCoroutine( DampenTimeRoutine() );
        //}
    }

    private IEnumerator DampenTimeRoutine()
    {
        //Prevent other 
        m_SlowTime = true;

        float lStartTime = Time.time;

        //Get last key's time and calculate end time
        float lEndTime = lStartTime + m_TimeDampCurve.keys[m_TimeDampCurve.keys.Length - 1].time;

        while (Time.time < lEndTime)
        {
            //Set time scale to the curve
            Time.timeScale = m_TimeDampCurve.Evaluate(Time.time - lStartTime);
            yield return null;
        }

        Time.timeScale = 1.0f;

        m_SlowTime = false;
    }
}
