using UnityEngine;

[System.Serializable]
public class SoundClip
{
    public string Name;
    public AudioClip Clip;
    public float Volume;
}

[CreateAssetMenu(fileName = "SoundData.asset", menuName = "Onyx/Create SoundData Object", order = 0)]
public class SoundData : ScriptableObject
{
    [SerializeField]
    private SoundClip[] m_Sounds;

    public AudioClip GetSound(string lClip)
    {
        for (int i = 0; i < m_Sounds.Length; i++)
        {
            if (m_Sounds[i].Name == lClip)
            {
                return m_Sounds[i].Clip;
            }
        }

        //Return null - this should be picked up and dealt with
        return null;
    }

    public float GetVolume(string lClip)
    {
        for (int i = 0; i < m_Sounds.Length; i++)
        {
            if (m_Sounds[i].Name == lClip)
            {
                return m_Sounds[i].Volume;
            }
        }

        //Return a low volume just in case
        return 0.1f;
    }
}
