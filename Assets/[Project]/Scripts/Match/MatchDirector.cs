using UnityEngine;
using System.Collections.Generic;
using UnityEngine.InputSystem.Plugins.PlayerInput;

namespace BattleBots
{
	internal class MatchDirector : MonoBehaviour 
	{
        [SerializeField] private MatchSettings settings = null;
        [SerializeField] private GameObject pawn = null;

        private SpawnPoint[] spawnPoints = new SpawnPoint[0];
        private float duration = 0.0f;
        private List<GameObject> pawns = new List<GameObject>();

        public bool InProgress { get; private set; } = false;

        public float RemainingTime => settings.TimeLimit <= 0.0f ? float.PositiveInfinity : settings.TimeLimit - duration;

        [ContextMenu("Begin")]
        public void Begin()
        {
            InProgress = true;
            duration = 0.0f;

            int spawnPointIndex = 0;
            pawns.Clear();

            // Temp
            PlayerInput[] players = FindObjectsOfType<PlayerInput>();
            foreach (PlayerInput player in players)
            {
                GameObject instance = Instantiate(pawn, spawnPoints[(int)Mathf.Repeat(spawnPointIndex, spawnPoints.Length)].transform.position, spawnPoints[(int)Mathf.Repeat(spawnPointIndex, spawnPoints.Length)].transform.rotation);
                PawnLogic[] pawnLogics = instance.GetComponentsInChildren<PawnLogic>(true);
                foreach (PawnLogic logic in pawnLogics)
                {
                    logic.PlayerInput = player;
                }

                pawns.Add(instance);

                instance.transform.GetChild(0).gameObject.SetActive(true);
            }
        }

        [ContextMenu("Finish")]
        public void Finish()
        {
            InProgress = false;

            foreach (GameObject pawn in pawns)
            {
                Destroy(pawn);
            }
        }

        protected virtual void Awake()
        {
            spawnPoints = FindObjectsOfType<SpawnPoint>();
        }

        protected virtual void Update()
        {
            if (InProgress)
            {
                duration += Time.deltaTime;

                if (RemainingTime <= 0.0f)
                {
                    Finish();
                }
            }
        }

        protected virtual void OnGUI()
        {
            if (InProgress)
            {
                if (GUI.Button(new Rect(10, 10, 100, 30), new GUIContent("Finish")))
                {
                    Finish();
                }
            }
            else
            {
                if (GUI.Button(new Rect(10, 10, 100, 30), new GUIContent("Begin")))
                {
                    Begin();
                }
            }
        }
	}
}
