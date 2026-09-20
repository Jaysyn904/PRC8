//::///////////////////////////////////////////////
//:: PRC Incarnum Loadout NUI constants
//:: prc_nui_moi_cst
//:://////////////////////////////////////////////

const string PRC_MOI_LOADOUT_NUI_WINDOW_ID = "prc_moi_loadout";
const string PRC_MOI_LOADOUT_OPEN_BUTTON = "spellbookIncarnumLoadout";

// Persistent default.  The marker is written last so a partial write is never
// treated as a usable rest plan.  Entry arrays share one exact size.
const string PRC_MOI_LOADOUT_VERSION_VAR = "PRC_MoiLoadout_Version";
const int PRC_MOI_LOADOUT_VERSION = 1;
const string PRC_MOI_LOADOUT_CLASS_ARRAY = "PRC_MoiLoadout_Class";
const string PRC_MOI_LOADOUT_CHAKRA_ARRAY = "PRC_MoiLoadout_Chakra";
const string PRC_MOI_LOADOUT_MELD_ARRAY = "PRC_MoiLoadout_Meld";
const string PRC_MOI_LOADOUT_INVEST_ARRAY = "PRC_MoiLoadout_Invest";
const string PRC_MOI_LOADOUT_EXPANDED_ARRAY = "PRC_MoiLoadout_Expanded";
const string PRC_MOI_LOADOUT_BIND_ARRAY = "PRC_MoiLoadout_Bind";
const string PRC_MOI_LOADOUT_TOTEM_ARRAY = "PRC_MoiLoadout_Totem";
const string PRC_MOI_LOADOUT_ASPECT_ARRAY = "PRC_MoiLoadout_Aspect";
// Optional in legacy version-1 saves.  A missing array means every saved row
// is an ordinary shaped soulmeld.
const string PRC_MOI_LOADOUT_KIND_ARRAY = "PRC_MoiLoadout_Kind";

const int PRC_MOI_LOADOUT_KIND_SOULMELD = 0;
const int PRC_MOI_LOADOUT_KIND_RECEPTACLE = 1;

// Completed-rest coordination.  The generation prevents a delayed executor
// from applying an older rest after a newer one has already completed.
const string PRC_MOI_LOADOUT_REST_GENERATION_VAR = "PRC_MoiLoadout_RestGeneration";

// Editor-only state.  Draft entries are JSON objects with compact keys:
// c class/source, k raw shaping chakra, m meld/receptacle, i raw essentia,
// e expanded claim, b physical bind, t Totem bind, a Astral Vambraces aspect,
// and q entry kind.  Missing q is an ordinary soulmeld for legacy drafts.
const string PRC_MOI_LOADOUT_DRAFT_VAR = "PRC_MoiLoadout_Draft";
const string PRC_MOI_LOADOUT_ACTIVE_VAR = "PRC_MoiLoadout_Active";
const string PRC_MOI_LOADOUT_STAGE_VAR = "PRC_MoiLoadout_Stage";
const string PRC_MOI_LOADOUT_CLASS_VAR = "PRC_MoiLoadout_ClassSelect";
const string PRC_MOI_LOADOUT_CHAKRA_VAR = "PRC_MoiLoadout_ChakraSelect";
const string PRC_MOI_LOADOUT_GEOMETRY_VAR = "PRC_MoiLoadout_Geometry";
const string PRC_MOI_LOADOUT_REBUILD_TOKEN_VAR = "PRC_MoiLoadout_RebuildToken";
const string PRC_MOI_LOADOUT_GENERATION_VAR = "PRC_MoiLoadout_Generation";

const int PRC_MOI_LOADOUT_STAGE_SHAPE = 1;
const int PRC_MOI_LOADOUT_STAGE_INVEST = 2;
const int PRC_MOI_LOADOUT_STAGE_BIND = 3;

const string PRC_MOI_LOADOUT_STEP_BUTTON = "moiLoadoutStep_";
const string PRC_MOI_LOADOUT_CLASS_BUTTON = "moiLoadoutClass_";
const string PRC_MOI_LOADOUT_CHAKRA_BUTTON = "moiLoadoutChakra_";
const string PRC_MOI_LOADOUT_MELD_BUTTON = "moiLoadoutMeld_";
const string PRC_MOI_LOADOUT_CLEAR_SLOT_BUTTON = "moiLoadoutClearSlot";
const string PRC_MOI_LOADOUT_INVEST_DOWN_BUTTON = "moiLoadoutInvestDown_";
const string PRC_MOI_LOADOUT_INVEST_UP_BUTTON = "moiLoadoutInvestUp_";
const string PRC_MOI_LOADOUT_EXPANDED_BUTTON = "moiLoadoutExpanded_";
const string PRC_MOI_LOADOUT_BIND_NONE_BUTTON = "moiLoadoutBindNone_";
const string PRC_MOI_LOADOUT_BIND_SLOT_BUTTON = "moiLoadoutBindSlot_";
const string PRC_MOI_LOADOUT_BIND_TOTEM_BUTTON = "moiLoadoutBindTotem_";
const string PRC_MOI_LOADOUT_BIND_DTOTEM_BUTTON = "moiLoadoutBindDTotem_";
const string PRC_MOI_LOADOUT_ASTRAL_DOWN_BUTTON = "moiLoadoutAstralDown_";
const string PRC_MOI_LOADOUT_ASTRAL_UP_BUTTON = "moiLoadoutAstralUp_";
const string PRC_MOI_LOADOUT_CAPTURE_BUTTON = "moiLoadoutCapture";
const string PRC_MOI_LOADOUT_CLEAR_DRAFT_BUTTON = "moiLoadoutClearDraft";
const string PRC_MOI_LOADOUT_CLEAR_SAVED_BUTTON = "moiLoadoutClearSaved";
const string PRC_MOI_LOADOUT_SAVE_BUTTON = "moiLoadoutSave";
const string PRC_MOI_LOADOUT_CANCEL_BUTTON = "moiLoadoutCancel";
const string PRC_MOI_LOADOUT_GENERATION_MARKER = "_g";

const int PRC_MOI_LOADOUT_MAX_ENTRIES = 112;
const int PRC_MOI_LOADOUT_MAX_PER_CLASS = 21;

// Optional Incarnum Blade blademeld editor.  Its saved default is deliberately
// separate from the normal soulmeld plan because pure Incarnum Blades are not
// meldshapers and never enter that rest lifecycle.
const string PRC_MOI_BLADE_NUI_WINDOW_ID = "prc_moi_blademeld";
const string PRC_MOI_BLADE_OPEN_BUTTON = "spellbookBlademelds";

// Persistent default.  Choice values are raw CHAKRA_* constants.  The version
// marker is cleared first and written last so partial data never becomes a
// usable completed-rest plan.
const string PRC_MOI_BLADE_VERSION_VAR = "PRC_MoiBlade_Version";
const string PRC_MOI_BLADE_FIRST_VAR = "PRC_MoiBlade_First";
const string PRC_MOI_BLADE_SECOND_VAR = "PRC_MoiBlade_Second";
const int PRC_MOI_BLADE_VERSION = 1;

// Completed-rest coordination.  Source distinguishes the pure-class path
// from an apply queued behind soulmeld restoration or a legacy conversation.
const string PRC_MOI_BLADE_REST_GENERATION_VAR = "PRC_MoiBlade_RestGeneration";
const string PRC_MOI_BLADE_REST_SOURCE_VAR = "PRC_MoiBlade_RestSource";
const int PRC_MOI_BLADE_REST_SOURCE_PURE = 1;
const int PRC_MOI_BLADE_REST_SOURCE_QUEUE = 2;
const int PRC_MOI_BLADE_REST_SOURCE_CONVERSATION = 3;

// Editor-only state.
const string PRC_MOI_BLADE_ACTIVE_VAR = "PRC_MoiBlade_Active";
const string PRC_MOI_BLADE_DRAFT_FIRST_VAR = "PRC_MoiBlade_DraftFirst";
const string PRC_MOI_BLADE_DRAFT_SECOND_VAR = "PRC_MoiBlade_DraftSecond";
const string PRC_MOI_BLADE_GEOMETRY_VAR = "PRC_MoiBlade_Geometry";
const string PRC_MOI_BLADE_GENERATION_VAR = "PRC_MoiBlade_Generation";
const string PRC_MOI_BLADE_REBUILD_TOKEN_VAR = "PRC_MoiBlade_RebuildToken";
const string PRC_MOI_BLADE_APPLY_MODE_VAR = "PRC_MoiBlade_ApplyMode";
const int PRC_MOI_BLADE_APPLY_MODE_REBIND = 1;

const string PRC_MOI_BLADE_CHAKRA_BUTTON = "moiBladeChakra_";
const string PRC_MOI_BLADE_SAVE_BUTTON = "moiBladeSave";
const string PRC_MOI_BLADE_CLEAR_BUTTON = "moiBladeClear";
const string PRC_MOI_BLADE_REBIND_BUTTON = "moiBladeRebind";
const string PRC_MOI_BLADE_CLOSE_BUTTON = "moiBladeClose";
const string PRC_MOI_BLADE_GENERATION_MARKER = "_g";
