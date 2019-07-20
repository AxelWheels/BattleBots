using UnityEngine;

public class MonoBehaviourSingleton<T> : MonoBehaviour where T : MonoBehaviour
{
	[SerializeField] protected bool dontDestroyOnLoad = false;

	private static T instance;

	private static object m_Lock = new object();

	public static T Instance
	{
		get
		{
			if(isQuitting)
			{
				Debug.LogWarning("Instance already created of " + typeof(T) + ", returning null.");
				return null;
			}

			lock(m_Lock)
			{
				if(instance == null)
				{
					instance = (T)FindObjectOfType(typeof(T));

					if(FindObjectsOfType(typeof(T)).Length > 1)
					{
						Debug.LogError("There is more than one singleton in this scene");
						return instance;
					}

					if(instance == null)
					{
						GameObject singleton = new GameObject();
						instance = singleton.AddComponent<T>();
						singleton.name = "Singleton " + typeof(T).ToString();

						Debug.Log("Singleton needed so was created with DDOL");
					}
					else
					{
						Debug.LogError("Singleton already exists at " + instance.gameObject.name);
					}
				}
				return Instance;
			}
		}
	}

	protected static bool isQuitting = false;

	public virtual void Awake()
	{
		if (dontDestroyOnLoad)
		{
			DontDestroyOnLoad(gameObject);
		}
	}

	public virtual void OnDestroy()
	{
		isQuitting = true;
	}

}
