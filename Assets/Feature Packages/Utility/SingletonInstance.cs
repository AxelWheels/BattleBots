using UnityEngine;

namespace Calvertechnical.Utility
{
	public abstract class SingletonInstance<T> : MonoBehaviour where T : MonoBehaviour
	{
		private static T s_instance;

		public static T Instance => s_instance;

		//On Awake of an object check if the instance is null and if not remove from the game
		protected virtual void Awake()
		{
			//Idea here is that a singleton object will have the correct type and component so we simply fetch it from the object then all singletons will behave the same when inherited from here
			if (s_instance == null)
			{
				s_instance = GetComponent<T>();
			}
			else
			{
				GameObject.Destroy(gameObject);
			}
		}
	}
}
