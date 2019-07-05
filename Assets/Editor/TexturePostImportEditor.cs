using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

/// <summary>
/// Editor class to automatically pick out and edit textures as they come in for the benefit of the artists
/// </summary>
///
/// Daniel Beard
///
public class TexturePostImportEditor : AssetPostprocessor
{
	[SerializeField]
	private string m_TextureSuffixNormal = "_N";
	[SerializeField]
	private string m_TextureSuffixPacked = "_ARM";

	private void OnPostProcessTexture( Texture2D lImportedTexture )
	{
		TextureImporter lTextureImporter = (TextureImporter)assetImporter;

		if( assetPath.Contains( m_TextureSuffixNormal ) )
		{
			//Change textures to normal maps if they are named correctly
			Debug.Log( "[Editor] Detected a normal map, converted. File: " + assetPath );
			lTextureImporter.convertToNormalmap = true;
		}
		else if( assetPath.Contains( m_TextureSuffixPacked ) )
		{
			//Automatically uncheck sRGB if we are looking at a packed texture
			Debug.Log( "[Editor] Detected a normal map, converted. File: " + assetPath );
			lTextureImporter.sRGBTexture = false;
		}
	}
}
