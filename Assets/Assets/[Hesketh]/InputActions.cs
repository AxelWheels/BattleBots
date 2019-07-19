// GENERATED AUTOMATICALLY FROM 'Assets/[Hesketh]/InputActions.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

namespace BattleBots
{
    public class InputActions : IInputActionCollection
    {
        private InputActionAsset asset;
        public InputActions()
        {
            asset = InputActionAsset.FromJson(@"{
    ""name"": ""InputActions"",
    ""maps"": [
        {
            ""name"": ""Pilot"",
            ""id"": ""5f0a120a-c8ba-4865-b427-9b216da22ff7"",
            ""actions"": [
                {
                    ""name"": ""Move"",
                    ""id"": ""78da55f2-c2f9-44e0-96a8-6ff2ca370ab7"",
                    ""expectedControlLayout"": ""Vector2"",
                    ""continuous"": false,
                    ""passThrough"": false,
                    ""initialStateCheck"": false,
                    ""processors"": """",
                    ""interactions"": """",
                    ""bindings"": []
                },
                {
                    ""name"": ""Shoot"",
                    ""id"": ""eeca6fa4-4697-473b-b4fe-8b72a317e85c"",
                    ""expectedControlLayout"": ""Button"",
                    ""continuous"": false,
                    ""passThrough"": false,
                    ""initialStateCheck"": false,
                    ""processors"": """",
                    ""interactions"": """",
                    ""bindings"": []
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""Keyboard"",
                    ""id"": ""4b3bb560-a9ff-4be5-a379-68a60179881d"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""up"",
                    ""id"": ""2ccff606-084f-4875-a8af-30616224bc3f"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""down"",
                    ""id"": ""99c28790-bab7-49c3-b86e-9268d2f4b4af"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""left"",
                    ""id"": ""a024bc58-46cd-40a1-b3e1-1ae6c13cbcea"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""right"",
                    ""id"": ""c14da2b2-af7f-4358-b557-1972eeecde2e"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": """",
                    ""id"": ""6e5d2199-7af6-4550-bd0d-d03f407359cf"",
                    ""path"": ""<Gamepad>/leftStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Controller"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false,
                    ""modifiers"": """"
                },
                {
                    ""name"": """",
                    ""id"": ""583143af-bba6-482e-8aa1-46904c32a69d"",
                    ""path"": ""<Keyboard>/space"",
                    ""interactions"": ""Hold"",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Shoot"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false,
                    ""modifiers"": """"
                },
                {
                    ""name"": """",
                    ""id"": ""d7bfb169-5a47-45c0-8bfa-aed10d3c2e5e"",
                    ""path"": ""<Gamepad>/rightShoulder"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Controller"",
                    ""action"": ""Shoot"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false,
                    ""modifiers"": """"
                }
            ]
        },
        {
            ""name"": ""Mech"",
            ""id"": ""72d41553-243b-426a-a392-dd8b08878d07"",
            ""actions"": [
                {
                    ""name"": ""Move"",
                    ""id"": ""3d122b5c-bba7-4dfb-8425-75f8a7d4e11f"",
                    ""expectedControlLayout"": """",
                    ""continuous"": false,
                    ""passThrough"": false,
                    ""initialStateCheck"": false,
                    ""processors"": """",
                    ""interactions"": """",
                    ""bindings"": []
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""Keyboard"",
                    ""id"": ""839bfdcc-c753-443a-85e6-159a4843d687"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""up"",
                    ""id"": ""fc99ba97-3607-4964-a6bb-147364731eed"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""down"",
                    ""id"": ""e6df6814-13e7-4d32-9812-67dee2c21ecb"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""left"",
                    ""id"": ""9439eb82-dff6-422a-b71b-9deb533becc8"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": ""right"",
                    ""id"": ""f5abe55c-240f-4b04-8792-5ec61ff2db8e"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": "";Keyboard + Mouse"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true,
                    ""modifiers"": """"
                },
                {
                    ""name"": """",
                    ""id"": ""2475754d-cc48-491b-84d4-97eefbfc6224"",
                    ""path"": ""<Gamepad>/leftStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Controller"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false,
                    ""modifiers"": """"
                }
            ]
        }
    ],
    ""controlSchemes"": [
        {
            ""name"": ""Keyboard + Mouse"",
            ""basedOn"": """",
            ""bindingGroup"": ""Keyboard + Mouse"",
            ""devices"": [
                {
                    ""devicePath"": ""<Keyboard>"",
                    ""isOptional"": false,
                    ""isOR"": false
                },
                {
                    ""devicePath"": ""<Mouse>"",
                    ""isOptional"": false,
                    ""isOR"": false
                }
            ]
        },
        {
            ""name"": ""Controller"",
            ""basedOn"": """",
            ""bindingGroup"": ""Controller"",
            ""devices"": [
                {
                    ""devicePath"": ""<Gamepad>"",
                    ""isOptional"": false,
                    ""isOR"": false
                }
            ]
        }
    ]
}");
            // Pilot
            m_Pilot = asset.GetActionMap("Pilot");
            m_Pilot_Move = m_Pilot.GetAction("Move");
            m_Pilot_Shoot = m_Pilot.GetAction("Shoot");
            // Mech
            m_Mech = asset.GetActionMap("Mech");
            m_Mech_Move = m_Mech.GetAction("Move");
        }

        ~InputActions()
        {
            UnityEngine.Object.Destroy(asset);
        }

        public InputBinding? bindingMask
        {
            get => asset.bindingMask;
            set => asset.bindingMask = value;
        }

        public ReadOnlyArray<InputDevice>? devices
        {
            get => asset.devices;
            set => asset.devices = value;
        }

        public ReadOnlyArray<InputControlScheme> controlSchemes
        {
            get => asset.controlSchemes;
        }

        public bool Contains(InputAction action)
        {
            return asset.Contains(action);
        }

        public IEnumerator<InputAction> GetEnumerator()
        {
            return asset.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public void Enable()
        {
            asset.Enable();
        }

        public void Disable()
        {
            asset.Disable();
        }

        // Pilot
        private InputActionMap m_Pilot;
        private IPilotActions m_PilotActionsCallbackInterface;
        private InputAction m_Pilot_Move;
        private InputAction m_Pilot_Shoot;
        public struct PilotActions
        {
            private InputActions m_Wrapper;
            public PilotActions(InputActions wrapper) { m_Wrapper = wrapper; }
            public InputAction @Move { get { return m_Wrapper.m_Pilot_Move; } }
            public InputAction @Shoot { get { return m_Wrapper.m_Pilot_Shoot; } }
            public InputActionMap Get() { return m_Wrapper.m_Pilot; }
            public void Enable() { Get().Enable(); }
            public void Disable() { Get().Disable(); }
            public bool enabled { get { return Get().enabled; } }
            public InputActionMap Clone() { return Get().Clone(); }
            public static implicit operator InputActionMap(PilotActions set) { return set.Get(); }
            public void SetCallbacks(IPilotActions instance)
            {
                if (m_Wrapper.m_PilotActionsCallbackInterface != null)
                {
                    Move.started -= m_Wrapper.m_PilotActionsCallbackInterface.OnMove;
                    Move.performed -= m_Wrapper.m_PilotActionsCallbackInterface.OnMove;
                    Move.canceled -= m_Wrapper.m_PilotActionsCallbackInterface.OnMove;
                    Shoot.started -= m_Wrapper.m_PilotActionsCallbackInterface.OnShoot;
                    Shoot.performed -= m_Wrapper.m_PilotActionsCallbackInterface.OnShoot;
                    Shoot.canceled -= m_Wrapper.m_PilotActionsCallbackInterface.OnShoot;
                }
                m_Wrapper.m_PilotActionsCallbackInterface = instance;
                if (instance != null)
                {
                    Move.started += instance.OnMove;
                    Move.performed += instance.OnMove;
                    Move.canceled += instance.OnMove;
                    Shoot.started += instance.OnShoot;
                    Shoot.performed += instance.OnShoot;
                    Shoot.canceled += instance.OnShoot;
                }
            }
        }
        public PilotActions @Pilot
        {
            get
            {
                return new PilotActions(this);
            }
        }

        // Mech
        private InputActionMap m_Mech;
        private IMechActions m_MechActionsCallbackInterface;
        private InputAction m_Mech_Move;
        public struct MechActions
        {
            private InputActions m_Wrapper;
            public MechActions(InputActions wrapper) { m_Wrapper = wrapper; }
            public InputAction @Move { get { return m_Wrapper.m_Mech_Move; } }
            public InputActionMap Get() { return m_Wrapper.m_Mech; }
            public void Enable() { Get().Enable(); }
            public void Disable() { Get().Disable(); }
            public bool enabled { get { return Get().enabled; } }
            public InputActionMap Clone() { return Get().Clone(); }
            public static implicit operator InputActionMap(MechActions set) { return set.Get(); }
            public void SetCallbacks(IMechActions instance)
            {
                if (m_Wrapper.m_MechActionsCallbackInterface != null)
                {
                    Move.started -= m_Wrapper.m_MechActionsCallbackInterface.OnMove;
                    Move.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnMove;
                    Move.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnMove;
                }
                m_Wrapper.m_MechActionsCallbackInterface = instance;
                if (instance != null)
                {
                    Move.started += instance.OnMove;
                    Move.performed += instance.OnMove;
                    Move.canceled += instance.OnMove;
                }
            }
        }
        public MechActions @Mech
        {
            get
            {
                return new MechActions(this);
            }
        }
        private int m_KeyboardMouseSchemeIndex = -1;
        public InputControlScheme KeyboardMouseScheme
        {
            get
            {
                if (m_KeyboardMouseSchemeIndex == -1) m_KeyboardMouseSchemeIndex = asset.GetControlSchemeIndex("Keyboard + Mouse");
                return asset.controlSchemes[m_KeyboardMouseSchemeIndex];
            }
        }
        private int m_ControllerSchemeIndex = -1;
        public InputControlScheme ControllerScheme
        {
            get
            {
                if (m_ControllerSchemeIndex == -1) m_ControllerSchemeIndex = asset.GetControlSchemeIndex("Controller");
                return asset.controlSchemes[m_ControllerSchemeIndex];
            }
        }
        public interface IPilotActions
        {
            void OnMove(InputAction.CallbackContext context);
            void OnShoot(InputAction.CallbackContext context);
        }
        public interface IMechActions
        {
            void OnMove(InputAction.CallbackContext context);
        }
    }
}
