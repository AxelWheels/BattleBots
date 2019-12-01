using UnityEngine;

[CreateAssetMenu(fileName = "CharacterData.asset", menuName = "BattleBots/CharacterData", order = 0)]
public class CharacterData : ScriptableObject
{
	[SerializeField, SerializeReference] private AttackData[] weapons;

	[SerializeField] private int health = 100;

	[SerializeField] private float turnSpeed = 360.0f;
	[SerializeField] protected float movementSpeed = 500f;
	[SerializeField] protected float airMovementSpeed = 300f;

	#region Properties
	public IAttackData[] Weapons => weapons;

	public int Health => health;

	public float TurnSpeed => turnSpeed;
	public float MovementSpeed => movementSpeed;
	public float AirMovementSpeed => airMovementSpeed;
	#endregion
}
