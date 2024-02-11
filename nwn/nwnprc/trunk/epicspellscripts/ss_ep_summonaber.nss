//:://////////////////////////////////////////////
//:: FileName: "ss_ep_summonaber"
/*   Purpose: Summon Aberration - summons a semi-random aberration for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oCaster = OBJECT_SELF;
    if(GetCanCastSpell(oCaster, SPELL_EPIC_SUMABER))
    {
        string sSummon;
        switch(d10())
        {
            case  1:
            case  2:
            case  3: sSummon = "ep_summonaberat1"; break;
            case  4:
            case  5:
            case  6: sSummon = "ep_summonaberat2"; break;
            case  7:
            case  8: sSummon = "ep_summonaberat3"; break;
            case  9: sSummon = "ep_summonaberat4"; break;
            case 10: sSummon = "ep_summonaberat5"; break;
        }

        effect eSummon = ExtraordinaryEffect(EffectSummonCreature(sSummon, VFX_FNF_SUMMON_EPIC_UNDEAD, 1.0f));
        //Apply the summon visual and summon the aberration.
        MultisummonPreSummon();
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), HoursToSeconds(20));

        DelayCommand(0.5, AugmentSummonedCreature(sSummon));
    }
    PRCSetSchool();
}