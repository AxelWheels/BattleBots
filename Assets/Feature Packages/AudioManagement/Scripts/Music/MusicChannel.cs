using System.Collections;
using UnityEngine;

public enum TransitionType
{
	None,
	LinearIn,
	LinearOut,
	EaseInOut,
	EaseOutIn,
}
namespace Calvertechnical.Audio
{
	public class MusicChannel : MonoBehaviour
	{
		[SerializeField]
		private AudioSource m_source;

		public AudioSource Source => m_source;

		private void Update()
		{
			//If music isn't looped deactivate the object when it's done
			if (!m_source.isPlaying && m_source.time >= 0)
			{
				m_source.gameObject.SetActive(false);
			}
		}

		public void TransitionChannel(TransitionType transition, float duration, MusicData music = null)
		{
			if (music != null)
			{
				AudioManager.Instance.Music.SetupMusicSource(this, music);
			}

			AudioManager.Instance.StartCoroutine(TransitionChannelVolume(duration, GetTransitionCurve(transition)));
		}

		/// <summary>
		/// General use will involve only 0 - 1 curvers so should work every time
		/// Allows for custom curves but they need to watch for how they behave when evaluated</summary>
		/// <param name="duration"></param>
		/// <param name="transitionCurve"></param>
		/// <returns></returns>
		public IEnumerator TransitionChannelVolume(float duration, AnimationCurve transitionCurve)
		{
			float timer = 0f;

			//Make sure our channel is active before using
			m_source.gameObject.SetActive(true);

			while (timer < duration)
			{
				timer += Time.unscaledDeltaTime;

				//TODO: Transition with music data volume min max
				m_source.volume = transitionCurve.Evaluate(timer / duration);

				yield return null;
			}

			m_source.volume = transitionCurve.Evaluate(1f);

			//If channel is no longer playing sound disable it
			m_source.gameObject.SetActive(m_source.volume > 0f);
		}

		public AnimationCurve GetTransitionCurve(TransitionType transition)
		{
			switch (transition)
			{
				case TransitionType.LinearIn:
					return AnimationCurve.Linear(0f, 0f, 1f, 1f);
				case TransitionType.LinearOut:
					return AnimationCurve.Linear(1f, 1f, 0f, 0f);
				case TransitionType.EaseInOut:
					return AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);
				case TransitionType.EaseOutIn:
					return AnimationCurve.EaseInOut(1f, 1f, 0f, 0f);
				default:
					return null;
			}
		}
	}
}
