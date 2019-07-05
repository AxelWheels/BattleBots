using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class SoundController : SingletonManager<SoundController>
{
	[SerializeField]
	private AudioMixer m_MasterMixer;
	[SerializeField]
	private AudioMixerGroup m_MasterMixerGroup;
	[SerializeField]
	private AudioMixerGroup m_MusicMixerGroup;
	[SerializeField]
	private AudioMixerGroup m_EffectsMixerGroup;
	[SerializeField]
	private AnimationCurve m_MusicCurve;

	[SerializeField]
	private int m_SourcesToPreload;

	[SerializeField]
	private float m_PitchVariation = 0.05f;

	[SerializeField]
	private float m_CollectInterval = 0.5f;

	private float m_CollectTime = 0.0f;

	private List<GameObject> m_AudioSourceObjects = new List<GameObject>();

	private void Awake()
	{
		CreateAudioSources();
	}

	private void Start()
	{
		SetEffectsVolume( 0.6f );
		SetMasterVolume( 0.6f );
		SetMusicVolume( 0.6f );
	}

	private void Update()
	{
		if( m_CollectTime <= 0 )
		{
			CollectAudioSources();

			m_CollectTime = m_CollectInterval;
		}
		else
		{
			m_CollectTime -= Time.unscaledDeltaTime;
		}
	}

	private void CollectAudioSources()
	{
		for( int i = 0; i < m_AudioSourceObjects.Count; i++ )
		{
			if( m_AudioSourceObjects[i] != null )
			{
				if( !m_AudioSourceObjects[i].GetComponent<AudioSource>().isPlaying )
				{
					m_AudioSourceObjects[i].transform.parent = transform;
				}
			}
			else
			{
				//Source has accidentally been destroyed
				m_AudioSourceObjects.RemoveAt( i );

				CreateNewSource();
			}
		}
	}

	public void PlaySound( AudioClip lClip, Transform lParent, Vector3 lLocalOffset, bool lPitchVariation, float lVolume )
	{
		GameObject lSource = GetAvailableSource();

		lSource.transform.parent = lParent;
		lSource.transform.localPosition = lLocalOffset;

		if( lPitchVariation )
		{
			lSource.GetComponent<AudioSource>().pitch += Random.Range( -m_PitchVariation, m_PitchVariation );
		}

		lSource.GetComponent<AudioSource>().volume = lVolume;
		lSource.GetComponent<AudioSource>().PlayOneShot( lClip );
	}

	public void PlaySound( AudioClip lClip, Transform lParent, bool lPitchVariation, float lVolume )
	{
		GameObject lSource = GetAvailableSource();

		lSource.transform.parent = lParent;
		lSource.transform.localPosition = Vector3.zero;

		if( lPitchVariation )
		{
			lSource.GetComponent<AudioSource>().pitch += Random.Range( -m_PitchVariation, m_PitchVariation );
		}

		lSource.GetComponent<AudioSource>().volume = lVolume;
		lSource.GetComponent<AudioSource>().PlayOneShot( lClip );
	}

	public void PlaySound( AudioClip lClip, Vector3 lPosition, bool lPitchVariation, float lVolume )
	{
		GameObject lSource = GetAvailableSource();

		lSource.transform.position = lPosition;

		if( lPitchVariation )
		{
			lSource.GetComponent<AudioSource>().pitch += Random.Range( -m_PitchVariation, m_PitchVariation );
		}

		lSource.GetComponent<AudioSource>().volume = lVolume;
		lSource.GetComponent<AudioSource>().PlayOneShot( lClip );
	}

	private void CreateAudioSources()
	{
		for( int i = 0; i < m_SourcesToPreload; i++ )
		{
			CreateNewSource();
		}
	}

	private GameObject CreateNewSource()
	{
		GameObject lObject = new GameObject();

		lObject.name = "AudioSource";
		lObject.transform.localPosition = Vector3.zero;
		lObject.transform.parent = transform;
		lObject.AddComponent<AudioSource>();

		lObject.GetComponent<AudioSource>().outputAudioMixerGroup = m_MasterMixerGroup;

		m_AudioSourceObjects.Add( lObject );

		return lObject;
	}

	private GameObject GetAvailableSource()
	{
		for( int i = 0; i < m_AudioSourceObjects.Count; i++ )
		{
			if( !m_AudioSourceObjects[i].GetComponent<AudioSource>().isPlaying )
			{
				return m_AudioSourceObjects[i];
			}
		}

		//Create a new component if unable to find an available one
		return CreateNewSource();
	}

	public void SetMasterVolume( float lValue )
	{
		float lTemp = m_MusicCurve.Evaluate( lValue );
		lTemp *= 100;
		lTemp -= 80;
		m_MasterMixer.SetFloat( "MasterVolume", lTemp );
	}

	public void SetEffectsVolume( float lValue )
	{
		float lTemp = m_MusicCurve.Evaluate( lValue );
		lTemp *= 100;
		lTemp -= 80;
		m_MasterMixer.SetFloat( "EffectsVolume", lTemp );
	}

	public void SetMusicVolume( float lValue )
	{
		float lTemp = m_MusicCurve.Evaluate( lValue );
		lTemp *= 100;
		lTemp -= 80;
		m_MasterMixer.SetFloat( "MusicVolume", lTemp );
	}
}
