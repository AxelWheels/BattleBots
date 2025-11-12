using Calvertechnical.Audio;
using UnityEngine;

namespace BattleBots
{
    public class SfxPoolObject : MonoBehaviour
    {
        [SerializeField]
        private bool m_returnOnFinish;

        [field: SerializeField]
        public AudioSource AudioSource { get; private set; }

        public SfxData Data { get; set; }

        public void Initialise(SfxData data, bool returnOnFinish)
        {
            Data = data;
            m_returnOnFinish = returnOnFinish;
        }

        // Update is called once per frame
        void Update()
        {
            if (!AudioSource.isPlaying && AudioSource.time >= 0)
            {
                AudioManager.Instance.Sfx.ReturnSfxPoolObject(this);
            }
        }

        public void StopAudio()
        {
            AudioSource.Stop();

			AudioManager.Instance.Sfx.ReturnSfxPoolObject(this);
		}
	}
}
