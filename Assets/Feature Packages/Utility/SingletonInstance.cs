using UnityEngine;

namespace Calvertechnical.Utility
{
	public abstract class SingletonInstance<T> : MonoBehaviour
	{
		private static SingletonInstance<T> s_instance;

		public static SingletonInstance<T> Instance => s_instance;

		//On Awake of an object check if the instance is null and if not remove from the game
		protected virtual void Awake()
		{
			if (s_instance == null)
			{
				s_instance = this;
			}
			else
			{
				GameObject.Destroy(gameObject);
			}
		}
	}
}
