using UnityEngine;

namespace Calvertechnical.Audio
{
	[CreateAssetMenu(fileName = "MusicData", menuName = "Scriptable Objects/MusicData")]
	public class MusicData : AudioData
	{
		[field: SerializeField]
		public int MusicChannel { get; set; }
	}
}
