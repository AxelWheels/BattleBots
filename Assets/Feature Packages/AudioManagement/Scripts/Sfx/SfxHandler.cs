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

		public void ClearActiveAudio()
		{
			foreach (var poolObject in m_activeAudioPool)
			{
				poolObject.StopAudio();
			}
		}

		/// <summary>
		/// TODO: Extend to apply different audio component effects to setup
		/// </summary>
		/// <param name="poolObject"></param>
		/// <param name="sfxData"></param>
		public void SetupSfxPoolObject(SfxPoolObject poolObject, SfxData sfxData)
		{
			AudioSource source = poolObject.AudioSource;

			source.clip = sfxData.RandomClip;
			
			source.volume = sfxData.Volume;
			source.pitch = sfxData.Pitch;
			source.priority = sfxData.Priority;
			source.panStereo = sfxData.StereoPan;
			source.spatialBlend = sfxData.SpatialBlend;
			source.reverbZoneMix = sfxData.ReverbZoneMix;

			source.playOnAwake = sfxData.PlayOnAwake;
			source.mute = sfxData.Mute;
			source.loop = sfxData.Loop;
			source.bypassEffects = sfxData.BypassEffects;
			source.bypassListenerEffects = sfxData.BypassListenerEffects;
			source.bypassReverbZones = sfxData.BypassReverbZone;

			source.outputAudioMixerGroup = sfxData.Mixer.outputAudioMixerGroup;
		}

		public void Play(SfxData sfxData, Vector3 position, bool isLocalPos = false, Transform targetParent = null)
		{
			if (!CanPlaySfx(sfxData))
			{
				return;
			}

			SfxPoolObject poolObject = RetrieveSfxPoolObject();
			SetupSfxPoolObject(poolObject, sfxData);

			poolObject.transform.SetParent(targetParent);

			if (isLocalPos)
			{
				poolObject.transform.localPosition = position;
			}
			else
			{
				poolObject.transform.position = position;
			}

			poolObject.gameObject.SetActive(true);
			
			poolObject.AudioSource.Play();
		}

		//CHeck against Sfx Limits to see if the sound can be played again
		public bool CanPlaySfx(SfxData sfxData)
		{
			if (sfxData.SfxLimit <= 0)
			{
				return true;
			}
			
			int currentPlayCount = 0;

			foreach (var objectPool in m_activeAudioPool)
			{
				if (objectPool.Data == sfxData)
				{
					currentPlayCount++;
				}
			}

			return currentPlayCount > sfxData.SfxLimit;
		}
	}
}
