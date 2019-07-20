using UnityEngine;

namespace BattleBots
{
	internal class MatchDirector : MonoBehaviour 
	{
        [SerializeField] private GameModeData gameMode = null;

        private SpawnPoint[] spawnPoints = new SpawnPoint[0];

        protected virtual void Awake()
        {
            spawnPoints = FindObjectsOfType<SpawnPoint>();
        }
	}
}
