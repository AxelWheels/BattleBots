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
    }
}
