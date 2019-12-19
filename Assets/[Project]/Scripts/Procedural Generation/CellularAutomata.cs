using System;
using UnityEngine;
using UnityEngine.Tilemaps;
using Random = UnityEngine.Random;

namespace BattleBots
{
	internal class CellularAutomata : MonoBehaviour 
	{
		[SerializeField] private Tilemap tilemap;

		[SerializeField] private Vector2Int gridSize;

		[SerializeField] private float fillPercentage;

		private bool[,] grid;

		private void Awake()
		{
			grid = new bool[gridSize.x, gridSize.y];
		}

		private void InitialiseRandomGrid()
		{
			Random.InitState(DateTime.Now.Millisecond);

			for(int i = 0; i < gridSize.y; i++)
			{
				for(int j = 0; j < gridSize.x; j++)
				{

				}
			}
		}

		private void InitialiseSeededGrid(string seed)
		{

		}
	}
}
