//::///////////////////////////////////////////////
//:: PRC Binder pact-management NUI constants
//:: prc_nui_bnd_cst
//:://////////////////////////////////////////////

// Public integration constants.  The stock Binder conversations remain in
// place; callers may opt into this window by executing PRC_BINDER_NUI_OPEN_SCRIPT.
const string PRC_BINDER_NUI_WINDOW_ID    = "prc_binder_pacts";
const string PRC_BINDER_NUI_OPEN_SCRIPT  = "prc_nui_bnd_open";
const string PRC_BINDER_NUI_EVENT_SCRIPT = "prc_nui_bnd_evnt";
const string PRC_BINDER_NUI_OPEN_BUTTON  = "spellbookBinderPactsButton";

const string PRC_BINDER_NUI_HOME_BIND_LIST  = "binderHomeBindList";
const string PRC_BINDER_NUI_HOME_BOUND_LIST = "binderHomeBoundList";
const string PRC_BINDER_NUI_CHOICE_LIST     = "binderChoiceList";
const string PRC_BINDER_NUI_CONTINUE_BUTTON = "binderContinue";
const string PRC_BINDER_NUI_RESET_BUTTON    = "binderReset";
const string PRC_BINDER_NUI_CANCEL_BUTTON   = "binderCancel";
const string PRC_BINDER_NUI_CLOSE_BUTTON    = "binderClose";

// Short, unrelated virtual-list bind names avoid client-side prefix aliasing.
const string PRC_BINDER_NUI_BIND_NAMES_BIND   = "bp_bn";
const string PRC_BINDER_NUI_BIND_COUNT_BIND   = "bp_bc";
const string PRC_BINDER_NUI_BOUND_NAMES_BIND  = "bp_xn";
const string PRC_BINDER_NUI_BOUND_COUNT_BIND  = "bp_xc";
const string PRC_BINDER_NUI_CHOICE_NAMES_BIND = "bp_cn";
const string PRC_BINDER_NUI_CHOICE_COUNT_BIND = "bp_cc";

const int PRC_BINDER_NUI_STAGE_HOME          = 0;
const int PRC_BINDER_NUI_STAGE_EXPLOIT       = 1;
const int PRC_BINDER_NUI_STAGE_METHOD        = 2;
const int PRC_BINDER_NUI_STAGE_AUGMENT       = 3;
const int PRC_BINDER_NUI_STAGE_NABERIUS      = 4;
const int PRC_BINDER_NUI_STAGE_ASTAROTH      = 5;
const int PRC_BINDER_NUI_STAGE_BIND_CONFIRM  = 6;
const int PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM = 7;
const int PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL = 8;

const int PRC_BINDER_NUI_METHOD_NORMAL = 1;
const int PRC_BINDER_NUI_METHOD_RUSHED = 2;
const int PRC_BINDER_NUI_METHOD_RAPID  = 3;

const int PRC_BINDER_NUI_RITUAL_BIND  = 1;
const int PRC_BINDER_NUI_RITUAL_EXPEL = 2;
