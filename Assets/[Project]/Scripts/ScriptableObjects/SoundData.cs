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
    [SerializeField] private SoundClip[] sounds = new SoundClip[0];

    public AudioClip GetSound(string clip)
    {
        for (int i = 0; i < sounds.Length; i++)
        {
            if (sounds[i].Name == clip)
            {
                return sounds[i].Clip;
            }
        }

        throw new System.Exception("AudioClip not Found!");
    }

    public float GetVolume(string clip)
    {
        for (int i = 0; i < sounds.Length; i++)
        {
            if (sounds[i].Name == clip)
            {
                return sounds[i].Volume;
            }
        }

        //Return a low volume just in case
        return 0.1f;
    }
}
