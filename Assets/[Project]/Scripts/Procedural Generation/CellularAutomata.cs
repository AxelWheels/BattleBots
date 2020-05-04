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

			GridGOL();
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

		private void GridGOL()
		{
			for (int i = 0; i < golIterations; i++)
			{
				bool[,] tempGrid = grid;

				for (int j = 1; j < gridSize.y - 1; j++)
				{
					for (int k = 1; k < gridSize.x - 1; k++)
					{
						int neighbours = 0;

						for (int x = j - 1; x <= j + 1; x++)
						{
							for (int y = k - 1; y <= k + 1; y++)
							{
								if (tempGrid[x,y])
								{
									neighbours++;
								}
							}
						}

						if (!tempGrid[j, k])
						{
							grid[j, k] = neighbours == 3 || neighbours >= 5;
						}
						else
						{
							grid[j, k] = !(neighbours < 2 || neighbours > 3);
						}
					}
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