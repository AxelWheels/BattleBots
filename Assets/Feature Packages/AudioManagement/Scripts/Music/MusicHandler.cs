using Calvertechnical.Audio;
using System.Collections.Generic;
using UnityEngine;

namespace BattleBots
{
	[System.Serializable]
	public class MusicHandler
	{
		[Header("Music Fields")]
		[SerializeField]
		private Transform m_musicChannelParent;

		[SerializeField]
		private MusicChannel m_musicChannelPrefab;

		private Dictionary<int, MusicChannel> m_channels = new Dictionary<int, MusicChannel>();

		public void Initialise()
		{
			//Intialise first 2 channels for basic music transitions
			m_channels.Add(0, GameObject.Instantiate(m_musicChannelPrefab, m_musicChannelParent));
			m_channels.Add(1, GameObject.Instantiate(m_musicChannelPrefab, m_musicChannelParent));

			foreach (var channel in m_channels)
			{
				channel.Value.gameObject.SetActive(false);
			}
		}

		public void SetupMusicSource(MusicChannel channel, MusicData musicData)
		{
			AudioSource source = channel.Source;

			source.clip = musicData.RandomClip;

			source.playOnAwake = musicData.PlayOnAwake;
			//source.volume = data.Volume;
			source.pitch = musicData.Pitch;
			source.priority = musicData.Priority;
			source.panStereo = musicData.StereoPan;
			source.spatialBlend = musicData.SpatialBlend;
			source.mute = musicData.Mute;
			source.loop = musicData.Loop;

			source.outputAudioMixerGroup = musicData.Mixer.outputAudioMixerGroup;

			source.bypassEffects = musicData.BypassEffects;
			source.bypassListenerEffects = musicData.BypassListenerEffects;
			source.bypassReverbZones = musicData.BypassReverbZone;

			source.reverbZoneMix = musicData.ReverbZoneMix;
		}

		public void TransitionMusic(int channel, TransitionType transition, float duration, MusicData music = null)
		{
			if (m_channels.ContainsKey(channel))
			{
				m_channels[channel].TransitionChannel(transition, duration, music);
			}
			else
			{
				Debug.LogError("Channel does not currently exist!", AudioManager.Instance);
			}
		}

		public void TransitionMusic(int startChannel, int endChannel, TransitionType transition, float duration, MusicData music)
		{
			if (m_channels.ContainsKey(startChannel) && m_channels.ContainsKey(endChannel))
			{
				m_channels[startChannel].TransitionChannel(transition, duration);
			}
			else
			{
				Debug.LogError("Either your start or end Channel does not currently exist!", AudioManager.Instance);
			}
		}

		public void CreateNewChannel()
		{
			m_channels.Add(m_channels.Count, GameObject.Instantiate(m_musicChannelPrefab));
		}
	}
}
