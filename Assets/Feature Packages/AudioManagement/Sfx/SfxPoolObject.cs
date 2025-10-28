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

        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
        
        }

        // Update is called once per frame
        void Update()
        {
        
        }
    }
}
