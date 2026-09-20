//::///////////////////////////////////////////////
//:: PRC psionic configuration NUI constants
//:: prc_nui_psi_cst
//:://////////////////////////////////////////////
// Constants-only by design: the shared /sb view/event/router can include this
// file without pulling the psionics implementation into every NUI consumer.

const string PRC_NUI_PSI_WINDOW_ID = "prc_psi_cfg";
const string PRC_NUI_PSI_OPEN_BUTTON = "spellbookPsiConfig";
const string PRC_NUI_PSI_OPEN_SCRIPT = "prc_nui_psi_op";
const string PRC_NUI_PSI_VIEW_SCRIPT = "prc_nui_psi_vw";
const string PRC_NUI_PSI_EVENT_SCRIPT = "prc_nui_psi_ev";

const string PRC_NUI_PSI_GENERATION_VAR = "PRC_PsiNui_Generation";
const string PRC_NUI_PSI_EDITOR_KIND_VAR = "PRC_PsiNui_EditKind";
const string PRC_NUI_PSI_EDITOR_INDEX_VAR = "PRC_PsiNui_EditIndex";
const string PRC_NUI_PSI_GEOMETRY_VAR = "PRC_PsiNui_Geometry";
const string PRC_NUI_PSI_REBUILD_TOKEN_VAR = "PRC_PsiNui_RebuildToken";
const string PRC_NUI_PSI_DEFAULT_CONFIRM_VAR = "PRC_PsiNui_DefaultConfirm";

const int PRC_NUI_PSI_EDIT_PROFILE = 0;
const int PRC_NUI_PSI_EDIT_QUICK = 1;

const int PRC_NUI_PSI_ACTION_NONE = 0;
const int PRC_NUI_PSI_ACTION_HANDLED = 1;
const int PRC_NUI_PSI_ACTION_REFRESH = 2;

const string PRC_NUI_PSI_ID_PREFIX = "psiCfg";
const string PRC_NUI_PSI_USE_BUTTON = "psiCfgUse_";
const string PRC_NUI_PSI_EDIT_KIND_BUTTON = "psiCfgKind_";
const string PRC_NUI_PSI_EDIT_INDEX_BUTTON = "psiCfgIndex_";
const string PRC_NUI_PSI_OPTION_DOWN_BUTTON = "psiCfgOptDown_";
const string PRC_NUI_PSI_OPTION_UP_BUTTON = "psiCfgOptUp_";
const string PRC_NUI_PSI_CLEAR_BUTTON = "psiCfgClear_";
const string PRC_NUI_PSI_VALUE_MODE_BUTTON = "psiCfgValueMode_";
const string PRC_NUI_PSI_AUTOMETA_BUTTON = "psiCfgAutometa_";
const string PRC_NUI_PSI_MAX_BUTTON = "psiCfgMax_";
const string PRC_NUI_PSI_SURGE_BUTTON = "psiCfgSurge_";
const string PRC_NUI_PSI_OVERCHANNEL_BUTTON = "psiCfgOver_";
const string PRC_NUI_PSI_DEFAULT_BUTTON = "psiCfgDefaults_";
const string PRC_NUI_PSI_DEFAULT_CONFIRM_BUTTON = "psiCfgDefaultsConfirm_";
const string PRC_NUI_PSI_DEFAULT_CANCEL_BUTTON = "psiCfgDefaultsCancel_";
const string PRC_NUI_PSI_LEGACY_BUTTON = "psiCfgLegacy_";
const string PRC_NUI_PSI_CLOSE_BUTTON = "psiCfgClose_";
const string PRC_NUI_PSI_GENERATION_MARKER = "_g";

// Quick selections are encoded as 101..107 in NUI element ids.  The live PRC
// local remains -1..-7 exactly as expected by GetCurrentUserAugmentationProfile.
const int PRC_NUI_PSI_QUICK_ACTION_BASE = 100;
