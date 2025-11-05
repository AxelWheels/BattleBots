using UnityEngine;

namespace Calvertechnical.Audio
{
	[CreateAssetMenu(fileName = "MusicData", menuName = "Calvertechnical/Audio/MusicData")]
	public class MusicData : AudioData
	{
		//TODO: Make sure this field is implemented properly in the music handler and music channel scripts
		[field: SerializeField]
		public int MusicChannel { get; set; }

		[field: SerializeField]
		public float TransitionDuration { get; set; }

		//Default play for ease of use
		public void Play()
		{
			AudioManager.Instance.Music.TransitionMusic(MusicChannel, TransitionType.LinearIn, 0.5f, this);
		}
	}
}
