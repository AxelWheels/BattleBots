using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

[CreateAssetMenu(fileName = "MatchSettings.asset", menuName = "Battle Bots/MatchSettings", order = 0)]
public class MatchSettings : ScriptableObject
{
    [field: SerializeField] public uint Lives { get; set; }
    [field: SerializeField] public float TimeLimit { get; set; }
    [field: SerializeField] public uint PointLimit { get; set; }
}

#if UNITY_EDITOR
[CustomEditor(typeof(MatchSettings))]
public class MatchSettingsEditor : Editor
{
    SerializedProperty lives = null;
    SerializedProperty timeLimit = null;
    SerializedProperty pointLimit = null;

    public void OnEnable()
    {
        lives = serializedObject.FindProperty("<Lives>k__BackingField");
        timeLimit = serializedObject.FindProperty("<TimeLimit>k__BackingField");
        pointLimit = serializedObject.FindProperty("<PointLimit>k__BackingField");
    }

    public override void OnInspectorGUI()
    {
        EditorGUILayout.PropertyField(lives, new GUIContent("Lives"));

        EditorGUILayout.PropertyField(timeLimit, new GUIContent("Time Limit (s)"));
        if (timeLimit.floatValue < 0.0f)
        {
            timeLimit.floatValue = 0.0f;
        }

        EditorGUILayout.PropertyField(pointLimit, new GUIContent("Point Limit"));

        serializedObject.ApplyModifiedProperties();
    }
}
#endif