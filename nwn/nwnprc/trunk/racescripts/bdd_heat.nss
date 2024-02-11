// Outdoor heatstroke
void Heat();

#include "prc_inc_spells"

void Heat()
{
    effect eImpact = EffectVisualEffect(/*VFX_IMP_DUST_EXPLOSION*/VFX_IMP_SUNSTRIKE);
    object oTarget = GetFirstObjectInArea(GetObjectByTag("bdd_basinrim"));
    while (GetIsObjectValid(oTarget))
    {
        if (PRCGetIsAliveCreature(oTarget) && !GetHasFeat(FEAT_HEAT_ENDURANCE, oTarget) && GetIsPC(oTarget))
        {
             int nDC = 15 + GetLocalInt(oTarget, "HeatstrokeCount");
             if (GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) > 0) nDC += 4;
             
             if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
             {
                 effect eHeat = EffectFatigue();
                 if (GetLocalInt(oTarget, "Fatigued")) eHeat = EffectExhausted();
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4()), oTarget);
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeat, oTarget, HoursToSeconds(12));
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                 SetLocalInt(oTarget, "Fatigued", TRUE);
                 AssignCommand(oTarget, SpeakString("The blazing sun saps energy from your limbs. Best to find shelter, and quickly."));
             }
             SetLocalInt(oTarget, "HeatstrokeCount", GetLocalInt(oTarget, "HeatstrokeCount")+1);
        }         
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInArea(GetObjectByTag("bdd_basinrim"));
    }
    
    DelayCommand(90.0, Heat());
}

void main()
{
    if (!GetLocalInt(GetModule(), "BDDHeat")) Heat();   
    SetLocalInt(GetModule(), "BDDHeat", TRUE);
}