using UnityEngine;

namespace BattleBots
{
	[System.Serializable]
	[CreateAssetMenu(fileName = "RangedData.asset", menuName = "BattleBots/RangedData")]
	internal class RangedData : AttackData 
	{
		[SerializeField] protected float projectileSpeed;

		public float ProjectileSpeed => projectileSpeed;
	}
}
