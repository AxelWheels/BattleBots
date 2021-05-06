using System;
using UnityEngine;
using UnityEngine.Tilemaps;
using Random = UnityEngine.Random;

namespace BattleBots
{
	internal class CellularAutomata : MonoBehaviour 
	{
		[SerializeField] private Tilemap tilemap;
		[SerializeField] private TileBase tileBase;

		[SerializeField] private Vector2Int gridSize;

		[SerializeField, Range(0,100)] private int fillPercentage;
		[SerializeField] private int customSeed = 0;
		[SerializeField] private int golIterations;

		private bool[,] grid;

		private void Awake()
		{
			grid = new bool[gridSize.x, gridSize.y];

			GenerateGrid();
		}

		public void GenerateGrid()
		{
			if (customSeed != 0)
			{
				InitialiseSeededGrid(customSeed);
			}
			else
			{
				InitialiseRandomGrid();
			}

			GameOfLifeGeneration();
			DrawTiles();
		}


		private void InitialiseRandomGrid()
		{
			InitialiseSeededGrid(DateTime.Now.Millisecond);
		}

		private void InitialiseSeededGrid(int seed)
		{
			Random.InitState(seed);

			for (int i = 0; i < gridSize.y; i++)
			{
				for (int j = 0; j < gridSize.x; j++)
				{
					grid[i, j] = Random.Range(0f, 100f) <= fillPercentage;
				}
			}
		}

		private void GameOfLifeGeneration()
		{
			for (int i = 0; i < golIterations; i++)
			{
				bool[,] tempGrid = grid;

				for (int j = 1; j < gridSize.y - 1; j++)
				{
					for (int k = 1; k < gridSize.x - 1; k++)
					{
						//GoL rules 
						//1. (grid[j,k] && neighbours < 2) == dead
						//2. (grid[j, k] && (neighbours == 2 || neighbours == 3)) == live
						//3. (grid[j, k] && neighbours > 3) == dead
						//4. (!grid[j, k] && neighbours == 3) == live

						int neighbours = FindNeighbours(tempGrid, j, k);

						if (grid[j,k])
						{
							grid[j, k] = (neighbours == 2 || neighbours == 3);
						}
						else
						{
							grid[j, k] = neighbours == 3;
						}
					}
				}
			}
		}

		private int FindNeighbours(bool [,] gridTarget, int x, int y)
		{
			int count = 0;

			// Check cell on the right.
			if (x != gridSize.x - 1)
				if (gridTarget[x + 1, y])
					count++;

			// Check cell on the bottom right.
			if (x != gridSize.x - 1 && y != gridSize.y - 1)
				if (gridTarget[x + 1, y + 1])
					count++;

			// Check cell on the bottom.
			if (y != gridSize.y - 1)
				if (gridTarget[x, y + 1])
					count++;

			// Check cell on the bottom left.
			if (x != 0 && y != gridSize.y - 1)
				if (gridTarget[x - 1, y + 1])
					count++;

			// Check cell on the left.
			if (x != 0)
				if (gridTarget[x - 1, y])
					count++;

			// Check cell on the top left.
			if (x != 0 && y != 0)
				if (gridTarget[x - 1, y - 1])
					count++;

			// Check cell on the top.
			if (y != 0)
				if (gridTarget[x, y - 1])
					count++;

			// Check cell on the top right.
			if (x != gridSize.x - 1 && y != 0)
				if (gridTarget[x + 1, y - 1])
					count++;

			return count;
		}

		private void GenerateRooms()
		{
			for (int i = 0; i < gridSize.y; i++)
			{
				for (int j = 0; j < gridSize.x; j++)
				{

				}
			}
		}

		private void DrawTiles()
		{
			tilemap.ClearAllTiles();

			Vector3Int position = Vector3Int.zero;

			for (int i = 0; i < gridSize.y; i++)
			{
				for (int j = 0; j < gridSize.x; j++)
				{
					if (grid[i,j])
					{
						position.x = i;
						position.y = j;

						tilemap.SetTile(position, tileBase);
					}
				}
			}
		}
	}
}