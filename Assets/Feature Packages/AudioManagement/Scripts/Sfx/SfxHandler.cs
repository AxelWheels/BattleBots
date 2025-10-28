using Calvertechnical.Audio;
using System.Collections.Generic;
using UnityEngine;

namespace BattleBots
{
	[System.Serializable]
	public class SfxHandler
	{
		[SerializeField]
		private Transform m_sfxPoolParent;

		[SerializeField]
		private SfxPoolObject m_sfxBlueprint;

		[SerializeField]
		private int m_initialPoolSize = 50;

		private Stack<SfxPoolObject> m_inactiveAudioPool = new Stack<SfxPoolObject>();
		private HashSet<SfxPoolObject> m_activeAudioPool = new HashSet<SfxPoolObject>();

		public void Initialise()
		{
			//Populate initial audio pool
			for (int i = 0; i < m_initialPoolSize; i++)
			{
				SfxPoolObject poolObject = GameObject.Instantiate(m_sfxBlueprint, m_sfxPoolParent);
				poolObject.gameObject.SetActive(false);

				m_inactiveAudioPool.Push(poolObject);
			}
		}

		/// <summary>
		/// If our inactive pool is empty we can't retrieve any new objects so we extend the pool by creating new objects if that happens
		/// </summary>
		/// <returns></returns>
		public SfxPoolObject RetrieveSfxPoolObject()
		{
			SfxPoolObject poolObject;

			if (m_inactiveAudioPool.Count == 0)
			{
				poolObject = GameObject.Instantiate(m_sfxBlueprint, m_sfxPoolParent);
			}
			else
			{
				poolObject = m_inactiveAudioPool.Pop();
			}

			m_activeAudioPool.Add(poolObject);

			return poolObject;
		}

		public void ReturnSfxPoolObject(SfxPoolObject poolObject)
		{
			if (m_activeAudioPool.Contains(poolObject))
			{
				m_activeAudioPool.Remove(poolObject);
				m_inactiveAudioPool.Push(poolObject);
				poolObject.gameObject.SetActive(false);
			}
		}

		public void SetupSfxPoolObject(SfxPoolObject poolObject, SfxData data)
		{
			AudioSource source = poolObject.AudioSource;

			source.clip = data.GetRandomClip;
			
			source.playOnAwake = data.PlayOnAwake;
			source.volume = data.Volume;
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

		public void Play(SfxData sfxData, Transform targetParent = null)
		{
			SfxPoolObject poolObject = RetrieveSfxPoolObject();
			SetupSfxPoolObject(poolObject, sfxData);

			poolObject.gameObject.SetActive(true);
			
			poolObject.AudioSource.Play();
		}

		public void PlayAtPosition(SfxData sfxData, Vector3 position, Transform targetParent = null)
		{
			SfxPoolObject poolObject = RetrieveSfxPoolObject();
			SetupSfxPoolObject(poolObject, sfxData);

			poolObject.transform.position = position;
			poolObject.gameObject.SetActive(true);

			poolObject.AudioSource.Play();
		}
	}
}
