using UnityEngine;

namespace BattleBots
{
    public class SpawnPoint : MonoBehaviour
    {
        private float unactiveTime = 3.0f;
        private float activeTimer = 0.0f;

        public bool Active { get; private set; } = true;

        public void Deactivate()
        {
            Active = false;

            activeTimer = unactiveTime;
        }

        private void Update()
        {
            if (!Active)
            {
                activeTimer -= Time.deltaTime;

                if (activeTimer < 0)
                {
                    Active = true;
                }
            }
        }
    }
}
