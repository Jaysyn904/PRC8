//::///////////////////////////////////////////////
//:: Trap Engineer
//:: prc_ft_trapeng.nss
//:://////////////////////////////////////////////
//::
//:: If you successfully disable a trap using this 
//:: feat, you gain a +2 bonus on Search and Disarm 
//:: Trap for one hour. You also gain a +4 bonus on 
//:: Reflex saves to avoid traps, and a +4 dodge 
//:: bonus to Armor Class against attacks made by traps.
//::
//:://///////////////////////////
//:: Created By: Stratovarius
//:: Created On: Nov 11, 2018
//::////////////////////////////////////////////////////////////

#include "prc_inc_nwscript"

void main()
{
    //Declare major variables
    int nDC;
    object oCaster = OBJECT_SELF;
    object oTrap = PRCGetSpellTargetObject();
    int nType = GetObjectType(oTrap);

    if(GetDistanceToObject(oTrap) <= 10.0)
    {
        nDC = GetTrapDisarmDC(oTrap);
        if(GetIsSkillSuccessful(oCaster, SKILL_DISABLE_TRAP, nDC))
        {
            FloatingTextStringOnCreature("Trap Engineer successful", oCaster, FALSE);
            SetTrapDisabled(oTrap);
            effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SEARCH, 2), EffectSkillIncrease(SKILL_DISABLE_TRAP, 2));
            eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 4, SAVING_THROW_TYPE_TRAP));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oCaster, HoursToSeconds(1));
        }
    }
    else
        FloatingTextStringOnCreature("You are too far away from the trap", oCaster, FALSE);

}