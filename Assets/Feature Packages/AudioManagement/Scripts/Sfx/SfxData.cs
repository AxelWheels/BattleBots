using UnityEngine;

namespace Calvertechnical.Audio
{
	[CreateAssetMenu(fileName = "SfxData", menuName = "Calvertechnical/Audio/SfxData", order = 50)]
	public class SfxData : AudioData
	{
		[field: SerializeField]
		public bool SingleInstanceEffect;

		[field: SerializeField, Tooltip("When playing this sound effect multiple times create a buffer before it can be played again.")]
		public float ReplayBufferDuration;

		[field: SerializeField, Tooltip("The maximum number of Sfx Objects that can exist at one time for this Sfx.")]
		public int SfxLimit;

		public void Play()
		{
			AudioManager.Instance.Sfx.Play(this, Vector3.zero);
		}
	}
}