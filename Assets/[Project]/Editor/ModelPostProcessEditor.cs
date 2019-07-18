using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

/// <summary>
/// Editor class to automatically pick out and edit models as they come in for the benefit of the artists
/// </summary>
///
/// Daniel Beard
///
public class ModelPostImportEditor : AssetPostprocessor
{
	private void OnPostProcessModel( Mesh lImportedMesh )
	{
		//Model Tangents are ever so slightly off when calculated, we want to force import 
		ModelImporter lModelImporter = (ModelImporter)assetImporter;

		Debug.Log( "[Editor] Detected a model, converted tangent option. File: " + assetPath );
		lModelImporter.importTangents = ModelImporterTangents.Import;
	}
}

