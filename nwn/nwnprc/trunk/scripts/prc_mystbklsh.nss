//Mystic Backlash Spell Script
//prc_mystbklsh
//by ebonfowl 5/5/2022
//Dedicated to Edgar, the real ebonfowl

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    float fDur = RoundsToSeconds(GetLocalInt(oPC, "MysticBacklashBonus"));
    int nBacklash = GetLocalInt(oPC, "MysticBacklashBonus");
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    int nDC = 10 + nBacklash + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
    effect eVis = EffectVisualEffect(VFX_IMP_SILENCE);
    
    //Kill the script if you don't have an adequate spell available
    if(!GetLocalInt(oPC, "MysticBacklashBonus"))
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    //Do touch attack and spell effects
    if(iAttackRoll)
    {
        if  (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
            SetLocalInt(oTarget, "DoMysticBacklash", nBacklash);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            DelayCommand(fDur, DeleteLocalInt(oTarget, "DoMysticBacklash"));
        }
        else if (GetHasMettle(oTarget, SAVING_THROW_WILL))
        {
			// This script does nothing if it has Mettle and makes a save, bail
			return;
		}
        else
        {
            SetLocalInt(oTarget, "DoMysticBacklash", nBacklash);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            DelayCommand(6.0f, DeleteLocalInt(oTarget, "DoMysticBacklash"));
        }
    }
}