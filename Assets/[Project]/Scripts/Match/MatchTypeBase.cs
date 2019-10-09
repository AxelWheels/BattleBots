using System.Collections.Generic;
using UnityEngine;

namespace BattleBots
{
	/// <summary>
	/// Base class for creating match types
	/// </summary>
	public abstract class MatchTypeBase : MonoBehaviour
	{
		[SerializeField] private string matchStartSound;
		[SerializeField] private string announcerStartSound;
		[SerializeField] private string matchEndSound;
		[SerializeField] private string announcerEndSound;

		[SerializeField] private float countdownTime = 0;
		[SerializeField] private float endMatchTime = 0;

		public MatchSettings GameModeData { get; private set; }

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
