using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class SoundController : MonoBehaviourSingleton<SoundController>
{
    [SerializeField] private AudioMixer masterMixer = null;
    [SerializeField] private AudioMixerGroup masterMixerGroup = null;
    [SerializeField] private AudioMixerGroup musicMixerGroup = null;
    [SerializeField] private AudioMixerGroup effectsMixerGroup = null;
    [SerializeField] private AnimationCurve musicCurve = null;

    [SerializeField] private int sourcesToPreload = 0;

    [SerializeField] private float pitchVariation = 0.05f;

    [SerializeField] private float collectInterval = 0.5f;

    private float collectTime = 0.0f;

    private List<GameObject> audioSourceObjects = new List<GameObject>();

    public override void Awake()
    {
        base.Awake();

        CreateAudioSources();
    }

    private void Start()
    {
        SetEffectsVolume(0.6f);
        SetMasterVolume(0.6f);
        SetMusicVolume(0.6f);
    }

    private void Update()
    {
        if (collectTime <= 0)
        {
            CollectAudioSources();

            collectTime = collectInterval;
        }
        else
        {
            collectTime -= Time.unscaledDeltaTime;
        }
    }

    private void CollectAudioSources()
    {
        for (int i = 0; i < audioSourceObjects.Count; i++)
        {
            if (audioSourceObjects[i] != null)
            {
                if (!audioSourceObjects[i].GetComponent<AudioSource>().isPlaying)
                {
                    audioSourceObjects[i].transform.parent = transform;
                }
            }
            else
            {
                //Source has accidentally been destroyed
                audioSourceObjects.RemoveAt(i);

                CreateNewSource();
            }
        }
    }

    public void PlaySound(AudioClip lClip, Transform lParent, Vector3 lLocalOffset, bool lPitchVariation, float lVolume)
    {
        GameObject lSource = GetAvailableSource();

        lSource.transform.parent = lParent;
        lSource.transform.localPosition = lLocalOffset;

        if (lPitchVariation)
        {
            lSource.GetComponent<AudioSource>().pitch += Random.Range(-pitchVariation, pitchVariation);
        }

        lSource.GetComponent<AudioSource>().volume = lVolume;
        lSource.GetComponent<AudioSource>().PlayOneShot(lClip);
    }

    public void PlaySound(AudioClip lClip, Transform lParent, bool lPitchVariation, float lVolume)
    {
        GameObject lSource = GetAvailableSource();

        lSource.transform.parent = lParent;
        lSource.transform.localPosition = Vector3.zero;

        if (lPitchVariation)
        {
            lSource.GetComponent<AudioSource>().pitch += Random.Range(-pitchVariation, pitchVariation);
        }

        lSource.GetComponent<AudioSource>().volume = lVolume;
        lSource.GetComponent<AudioSource>().PlayOneShot(lClip);
    }

    public void PlaySound(AudioClip lClip, Vector3 lPosition, bool lPitchVariation, float lVolume)
    {
        GameObject lSource = GetAvailableSource();

        lSource.transform.position = lPosition;

        if (lPitchVariation)
        {
            lSource.GetComponent<AudioSource>().pitch += Random.Range(-pitchVariation, pitchVariation);
        }

        lSource.GetComponent<AudioSource>().volume = lVolume;
        lSource.GetComponent<AudioSource>().PlayOneShot(lClip);
    }

    private void CreateAudioSources()
    {
        for (int i = 0; i < sourcesToPreload; i++)
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

        lObject.GetComponent<AudioSource>().outputAudioMixerGroup = masterMixerGroup;

        audioSourceObjects.Add(lObject);

        return lObject;
    }

    private GameObject GetAvailableSource()
    {
        for (int i = 0; i < audioSourceObjects.Count; i++)
        {
            if (!audioSourceObjects[i].GetComponent<AudioSource>().isPlaying)
            {
                return audioSourceObjects[i];
            }
        }

        //Create a new component if unable to find an available one
        return CreateNewSource();
    }

    public void SetMasterVolume(float lValue)
    {
        float lTemp = musicCurve.Evaluate(lValue);
        lTemp *= 100;
        lTemp -= 80;
        masterMixer.SetFloat("MasterVolume", lTemp);
    }

    public void SetEffectsVolume(float lValue)
    {
        float lTemp = musicCurve.Evaluate(lValue);
        lTemp *= 100;
        lTemp -= 80;
        masterMixer.SetFloat("EffectsVolume", lTemp);
    }

    public void SetMusicVolume(float lValue)
    {
        float lTemp = musicCurve.Evaluate(lValue);
        lTemp *= 100;
        lTemp -= 80;
        masterMixer.SetFloat("MusicVolume", lTemp);
    }
}
