using UnityEngine;

namespace Calvertechnical.Audio
{
	[CreateAssetMenu(fileName = "SfxData", menuName = "Calvertechnical/Audio/SfxData", order = 50)]
	public class SfxData : AudioData
	{
		public void Play()
		{
			AudioManager.Instance.Sfx.Play(this);
		}
	}
}