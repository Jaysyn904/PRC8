/*:://////////////////////////////////////////////
//:: Name Settings include
//:: FileName SMP_INC_SETTINGS
//:://////////////////////////////////////////////

    Things for getting/setting settings, such as:
    - Domain Spells Enforce limit (Used: On Rest event, in Spell Hook)
    - Expertise abuse (using Bioware value, turns of expertise if casting a spell)







//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On:
//::////////////////////////////////////////////*/

// If TRUE, we set a limit of 1 spell slot for domain spells/rest.
const string SMP_SETTING_DOMAIN_SPELL_LIMIT_ENFORCE = "SMP_SET_DSLE";

// If TRUE we turn of Expertise on any spellcaster
const string SMP_SETTING_BIO_STOP_EXPERTISE_ABUSE = "X2_L_STOP_EXPERTISE_ABUSE";

// SMP_INC_SETTINGS. We set sSetting to be used, to TRUE.
void SMP_SettingSetGlobalOn(string sSetting);
// SMP_INC_SETTINGS. We remove sSetting, so it will not be used.
void SMP_SettingSetGlobalOff(string sSetting);
// SMP_INC_SETTINGS. If sSetting active?
int SMP_SettingGetGlobal(string sSetting);

// Start functions

// SMP_INC_SETTINGS. We set sSetting to be used, to TRUE.
void SMP_SettingSetGlobalOn(string sSetting)
{
    SetLocalInt(GetModule(), sSetting, TRUE);
}

// SMP_INC_SETTINGS. We remove sSetting, so it will not be used.
void SMP_SettingSetGlobalOff(string sSetting)
{
    DeleteLocalInt(GetModule(), sSetting);
}

// SMP_INC_SETTINGS. If sSetting active?
int SMP_SettingGetGlobal(string sSetting)
{
    return GetLocalInt(GetModule(), sSetting);
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
