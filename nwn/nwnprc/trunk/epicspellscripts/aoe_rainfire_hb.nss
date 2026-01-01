//:://////////////////////////////////////////////
//:: FileName: "aoe_rainfire_hb"
/*   Purpose: AoE Rain of Fire's Heartbeat script.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
#include "prc_add_spell_dc"


void main()
{

    SetAllAoEInts(4054, OBJECT_SELF, GetSpellSaveDC());

    int nDamage;
    effect eDam;
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();

    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay;
    oTarget = GetFirstInPersistentObject
        (OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    while(GetIsObjectValid(oTarget))
    {
        if (oTarget != oCaster &&
        !GetIsDM(oTarget))
        {
            fDelay = PRCGetRandomDelay(0.5, 2.0);
            if(!PRCDoResistSpell(oCaster, oTarget, GetTotalCastingLevel(oCaster)+SPGetPenetr(oCaster), fDelay))
            {

                SignalEvent(oTarget,
                    EventSpellCastAt(oCaster, SPELL_INCENDIARY_CLOUD));
                nDamage = d6(1);
                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
                int nDC = GetEpicSpellSaveDC(oCaster, oTarget, SPELL_EPIC_RAINFIR);
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay))
                {
                    DelayCommand(fDelay,
                        SPApplyEffectToObject
                            (DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay,
                        SPApplyEffectToObject
                            (DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        oTarget = GetNextInPersistentObject
            (OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
