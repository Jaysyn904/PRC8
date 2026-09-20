//::///////////////////////////////////////////////
//:: PRC Maneuver Readying NUI constants
//:: prc_nui_mr_const
//:://////////////////////////////////////////////

const string PRC_MANEUVER_READY_NUI_WINDOW_ID = "prc_maneuver_ready";
const string PRC_MANEUVER_READY_NUI_BUTTON = "spellbookReadyManeuversButton";

const string PRC_MANEUVER_READY_DRAFT_VAR = "PRC_ManeuverReady_Draft";
const string PRC_MANEUVER_READY_BASELINE_VAR = "PRC_ManeuverReady_Baseline";
const string PRC_MANEUVER_READY_ACTIVE_VAR = "PRC_ManeuverReady_Active";
const string PRC_MANEUVER_READY_CLASS_VAR = "PRC_ManeuverReady_Class";
const string PRC_MANEUVER_READY_LEVEL_VAR = "PRC_ManeuverReady_Level";
const string PRC_MANEUVER_READY_MODE_VAR = "PRC_ManeuverReady_Mode";
const string PRC_MANEUVER_READY_GEOMETRY_VAR = "PRC_ManeuverReady_Geometry";
const string PRC_MANEUVER_READY_REBUILD_TOKEN_VAR = "PRC_ManeuverReady_RebuildToken";
const string PRC_MANEUVER_READY_COOLDOWN_GENERATION_VAR_BASE = "PRC_ManeuverReady_CooldownGen_";

const string PRC_MANEUVER_READY_KNOWN_MAP_VAR = "PRC_ManeuverReady_KnownMap";
const string PRC_MANEUVER_READY_KNOWN_NAMES_VAR = "PRC_ManeuverReady_KnownNames";
const string PRC_MANEUVER_READY_PLAN_MAP_VAR = "PRC_ManeuverReady_PlanMap";
const string PRC_MANEUVER_READY_PLAN_NAMES_VAR = "PRC_ManeuverReady_PlanNames";

const string PRC_MANEUVER_READY_LEVEL_BUTTON = "maneuverReadyLevel_";
const string PRC_MANEUVER_READY_KNOWN_LIST_BUTTON = "maneuverReadyKnownList";
const string PRC_MANEUVER_READY_PLAN_LIST_BUTTON = "maneuverReadyPlanList";
const string PRC_MANEUVER_READY_CLEAR_BUTTON = "maneuverReadyClear";
const string PRC_MANEUVER_READY_SAVE_BUTTON = "maneuverReadySave";
const string PRC_MANEUVER_READY_CANCEL_BUTTON = "maneuverReadyCancel";

// Keep list bind names short and unrelated so adjacent virtual-list cells do
// not alias on clients with the older NUI binding implementation.
const string PRC_MANEUVER_READY_KNOWN_NAMES_BIND = "mr_kn_name";
const string PRC_MANEUVER_READY_KNOWN_COUNT_BIND = "mr_kn_count";
const string PRC_MANEUVER_READY_PLAN_NAMES_BIND = "mr_pl_name";
const string PRC_MANEUVER_READY_PLAN_COUNT_BIND = "mr_pl_count";

const int PRC_MANEUVER_READY_MODE_NORMAL = 1;

// feat.2da rows used by the three base initiator class controls.
const int PRC_MANEUVER_READY_FEAT_CRUSADER = 1823;
const int PRC_MANEUVER_READY_FEAT_SWORDSAGE = 1899;
const int PRC_MANEUVER_READY_FEAT_WARBLADE = 1960;
const int PRC_MANEUVER_RECOVER_FEAT_SWORDSAGE = 3110;

// A Swordsage level-0 click queues the stock recovery feat and supplies the
// maneuver that its impact script should recover instead of opening a dialog.
const string PRC_MANEUVER_RECOVER_PENDING_VAR = "PRC_ManeuverRecover_Pending";
const string PRC_MANEUVER_RECOVER_PENDING_GENERATION_VAR = "PRC_ManeuverRecover_Generation";
