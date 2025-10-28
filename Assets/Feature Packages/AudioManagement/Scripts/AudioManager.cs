using BattleBots;
using Calvertechnical.Utility;
using UnityEngine;

namespace Calvertechnical.Audio
{
    public class AudioManager : SingletonInstance<AudioManager>
    {
        [SerializeField]
        public SfxHandler Sfx;
		[SerializeField]
		public MusicHandler Music;

		protected override void Awake()
		{
            base.Awake();

            Sfx.Initialise();
            Music.Initialise();
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
