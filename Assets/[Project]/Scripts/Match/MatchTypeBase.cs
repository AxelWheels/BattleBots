using System.Collections.Generic;
using UnityEngine;

namespace BattleBots
{
	/// <summary>
	/// Base class for creating match types
	/// </summary>
	public abstract class MatchTypeBase : MonoBehaviour
	{
		[SerializeField] private string m_MatchStartSound;
		[SerializeField] private string m_AnnouncerStartSound;
		[SerializeField] private string m_MatchEndSound;
		[SerializeField] private string m_AnnouncerEndSound;

		[SerializeField] private float m_CountdownTime = 0;
		[SerializeField] private float m_EndMatchTime = 0;

		public GameModeData GameModeData { get; private set; }

		public bool InProgress { get; private set; } = false;

		public int PlayersLeft { get; set; } = 4;

		public float TimeLeft { get; private set; } = float.MaxValue;

		public delegate void MatchStartedDelegate();
		public delegate void MatchEndedDelegate();

		public event MatchStartedDelegate OnMatchStarted;
		public event MatchEndedDelegate OnMatchEnded;

		protected virtual void StartMatch()
		{
			InProgress = true;

			OnMatchStarted?.Invoke();
		}
		protected virtual void EndMatch()
		{
			OnMatchEnded?.Invoke();
		}
		protected abstract void SetupMatch(int lNumberOfPlayers);

		protected abstract void CheckEndConditions();

	}
}
