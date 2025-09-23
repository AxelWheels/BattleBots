using UnityEngine;
using UnityEngine.Audio;

namespace Calvertechnical.Audio
{
    [CreateAssetMenu(fileName = "AudioData", menuName = "Scriptable Objects/AudioData")]
    public class AudioData : ScriptableObject
    {
        [field: SerializeField]
        public AudioClip[] AudioClips { get; set; }

        [field: SerializeField]
        public AudioMixer Mixer { get; set; }

        [field: SerializeField]
        public bool Mute { get; set; }
        
        [field: SerializeField]
        public bool BypassEffects { get; set; }

		[field: SerializeField]
		public bool BypassListenerEffects { get; set; }

		[field: SerializeField]
		public bool BypassReverbZone { get; set; }

        [field: SerializeField]
        public bool PlayOnAwake { get; set; } = true;

		[field: SerializeField]
		public bool Loop { get; set; } = true;

		[field: SerializeField]
        public int Priority { get; set; }

		[field: SerializeField]
        public float Volume { get; set; }

        [field: SerializeField]
        public float Pitch { get; set; }

        [field: SerializeField]
        public float StereoPan { get; set; }

        [field: SerializeField]
        public float SpatialBlend { get; set; }

        [field: SerializeField]
        public float ReverbZoneMix { get; set; }

        public AudioClip GetRandomClip => AudioClips[Random.Range(0, AudioClips.Length - 1)];
        public AudioClip GetFirstClip => AudioClips[0];
    }
}
