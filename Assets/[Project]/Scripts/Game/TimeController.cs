using System.Collections;
using UnityEngine;

public class TimeController : MonoBehaviourSingleton<TimeController>
{
    [SerializeField] private AnimationCurve timeDampCurve = AnimationCurve.Linear(0.0f, 0.0f, 1.0f, 1.0f);

    [SerializeField] private SoundData soundData = null;

    [SerializeField] private string slowTimeSound = "";

    private Coroutine dampenTimeRoutine;

    private bool slowTime = false;

    private void OnGameStateChange(GameStateBase lState)
    {
        Time.timeScale = 1.0f;
    }

    public void TryDampenTime()
    {
		if(!slowTime)
		{
			SoundController.Instance.PlaySound(soundData.GetSound(slowTimeSound), Camera.main.transform, false, 0.02f);

			//Just in case the coroutine is still running for some reason
			if(dampenTimeRoutine != null)
			{
				StopCoroutine(dampenTimeRoutine);
			}

			dampenTimeRoutine = StartCoroutine(DampenTimeRoutine());
		}
	}

    private IEnumerator DampenTimeRoutine()
    {
        //Prevent other 
        slowTime = true;

        float lStartTime = Time.time;

        //Get last key's time and calculate end time
        float lEndTime = lStartTime + timeDampCurve.keys[timeDampCurve.keys.Length - 1].time;

        while (Time.time < lEndTime)
        {
            //Set time scale to the curve
            Time.timeScale = timeDampCurve.Evaluate(Time.time - lStartTime);
            yield return null;
        }

        Time.timeScale = 1.0f;

        slowTime = false;
    }
}
