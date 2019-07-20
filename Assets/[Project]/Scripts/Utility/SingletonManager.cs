using UnityEngine;

public class MonoBehaviourSingleton<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T m_Instance;

    private static object m_Lock = new object();

    public static T Instance
    {
        get
        {
            if (isQuitting)
            {
                Debug.LogWarning("Instance already created of " + typeof(T) + ", returning null.");
                return null;
            }

            lock (m_Lock)
            {
                if (m_Instance == null)
                {
                    m_Instance = (T)FindObjectOfType(typeof(T));

                    if (FindObjectsOfType(typeof(T)).Length > 1)
                    {
                        Debug.LogError("Major error, there's more than one Singleton in this project. Quit/Reopen should fix.");
                        return m_Instance;
                    }

                    if (m_Instance == null)
                    {
                        GameObject singleton = new GameObject();
                        m_Instance = singleton.AddComponent<T>();
                        singleton.name = "Singleton " + typeof(T).ToString();

                        DontDestroyOnLoad(singleton);

                        Debug.Log("Singleton needed so was created with DDOL");
                    }
                    else
                    {
                        //Debug.Log( "Singleton already exists at " + m_Instance.gameObject.name );
                    }
                }
                return m_Instance;
            }
        }
    }

    private static bool isQuitting = false;

    public void OnDestroy()
    {
        isQuitting = true;
    }

}
