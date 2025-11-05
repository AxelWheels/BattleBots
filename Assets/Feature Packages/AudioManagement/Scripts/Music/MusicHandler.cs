using Calvertechnical.Audio;
using Mono.Cecil;
using System;
using System.Collections.Generic;
using System.Security.Policy;
using UnityEngine;
using static UnityEngine.Analytics.IAnalytic;

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

		public void SetupMusicSource(MusicChannel channel, MusicData data)
		{
			AudioSource source = channel.Source;

			source.clip = data.RandomClip;

			source.playOnAwake = data.PlayOnAwake;
			//source.volume = data.Volume;
			source.pitch = data.Pitch;
			source.priority = data.Priority;
			source.panStereo = data.StereoPan;
			source.spatialBlend = data.SpatialBlend;
			source.mute = data.Mute;
			source.loop = data.Loop;

			source.outputAudioMixerGroup = data.Mixer.outputAudioMixerGroup;

			source.bypassEffects = data.BypassEffects;
			source.bypassListenerEffects = data.BypassListenerEffects;
			source.bypassReverbZones = data.BypassReverbZone;

			source.reverbZoneMix = data.ReverbZoneMix;
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
