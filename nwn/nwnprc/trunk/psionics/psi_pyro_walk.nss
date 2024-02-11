/*
    prc_pyro_walk

    Speed boost while costing power points

    By: Flaming_Sword
    Created: Dec 7, 2007
    Modified: Dec 7, 2007
*/

#include "prc_alterations"
#include "psi_inc_psifunc"
#include "psi_inc_ppoints"

void WalkHB(object oPC)
{
    if(GetHasSpellEffect(SPELL_FIREWALK, oPC))
    {
        if(GetCurrentPowerPoints(oPC) > 0)
        {
            LosePowerPoints(oPC, 1);
            DelayCommand(6.0, WalkHB(oPC));
        }
        else
        {
            FloatingTextStringOnCreature("*Insufficient Power Points - " + GetPersistantLocalString(oPC, "PyroString") + " Walk Deactivated*", oPC);
            DeleteLocalInt(oPC, "PyroWalk");
            PRCRemoveEffectsFromSpell(oPC, SPELL_FIREWALK);
        }
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    if(!UsePsionicFocus(oPC))
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    int nLevel = (GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC));
    string sString = GetPersistantLocalString(oPC, "PyroString");
    if(GetHasSpellEffect(SPELL_FIREWALK, oPC))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_FIREWALK);
        FloatingTextStringOnCreature("*" + sString + " Walk Deactivated*", oPC);
    }
    else
    {
        if(GetCurrentPowerPoints(oPC) > 0)
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HASTE), oPC);
            effect eLink = EffectLinkEffects(EffectMovementSpeedIncrease(99), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
            FloatingTextStringOnCreature("*" + sString + " Walk Activated*", oPC);
            WalkHB(oPC);
        }
        else
        {
            FloatingTextStringOnCreature("*Insufficient Power Points*", oPC);
        }
    }
}
