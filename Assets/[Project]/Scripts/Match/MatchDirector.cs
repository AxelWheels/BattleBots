using UnityEngine;

namespace BattleBots
{
	internal class MatchDirector : MonoBehaviour 
	{
        private SpawnPoint[] spawnPoints = new SpawnPoint[0];

        protected virtual void Awake()
        {
            spawnPoints = FindObjectsOfType<SpawnPoint>();
        }
	}
}
