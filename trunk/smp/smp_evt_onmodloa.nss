/*:://////////////////////////////////////////////
//:: Name Module load
//:: FileName SMP_EVT_ONMODLOA
//:://////////////////////////////////////////////
    Module load file.

    Settings for spells can be found here, and are documented to what they do.

    The actual setting constants are in SMP_INC_SETTINGS. If you wish to use
    a different module load script, you can either execute this using the line:

    ExecuteScript("SMP_EVT_ONMODLOA");

    Or have the include file line at the top of your original module load, and
    copy settings you want across.

    It is a good itea to keep this for the documentation. The defaults (what is
    normally on with the spellmans content) are the uncommented ones here.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SETTINGS"

void main()
{
    // Set module settings.

    // Expertise Abuse Setting
    // * Have this on to turn off Abuse of Expertise (+5, +10 AC) when casting spells.
    SMP_SettingSetGlobalOn(SMP_SETTING_BIO_STOP_EXPERTISE_ABUSE);

    // Domain spell limit enforce
    // * Have this on, and the correct OnRest event script, to have domain spells
    //   enforced, that you can only cast 1 domain spell, the rest must be normal.
    SMP_SettingSetGlobalOn(SMP_SETTING_DOMAIN_SPELL_LIMIT_ENFORCE);


}
