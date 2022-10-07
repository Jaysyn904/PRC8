/////////////////////////////////////////////////
// Magma Burst: On Heartbeat
// tm_s0_epMagmaBuB.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Initial explosion (20d8) reflex save, then AoE of lava (10d8),
// fort save.  If more then 5 rnds in the cloud cumulative, you turn to stone
// as the lava hardens (fort save).
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////

#include "inc_epicspells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oAoE = OBJECT_SELF;
    object oCaster = GetAreaOfEffectCreator();

    if(!GetIsObjectValid(oCaster))
    {
        DestroyObject(oAoE);
        return;
    }

    //Declare major variables
    int nDamage;
    effect eDam;
    float fDelay;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    object oTarget = GetFirstInPersistentObject(oAoE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            fDelay = PRCGetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d8(10);

            //Adjust damage for Fort Save:  How does one avoid lava and not leave the area?
            // Flying, I guess:  To bad NWN doesn't have a "Z" Axis. :D
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(oCaster, oTarget, SPELL_EPIC_MAGMA_B) , // B- ch to nDC
                                 SAVING_THROW_TYPE_FIRE, oCaster))
            {
                // Apply effects to the currently selected target.
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            else
            {
               nDamage = nDamage / 2;
               if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                    // This script does nothing if it has Mettle, bail
                    nDamage = 0;
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }

            int nMagmaBurstCounter = GetLocalInt(oTarget, "MagmaBurst");
            if(nMagmaBurstCounter >= 1)
            {
                int nCounterIncrease = nMagmaBurstCounter +1;
                SetLocalInt(oTarget, "MagmaBurst", nCounterIncrease);
                if(nCounterIncrease >= 5)
                    PRCDoPetrification(GetTotalCastingLevel(oCaster), oAoE, oTarget, PRCGetSpellId(), GetEpicSpellSaveDC(oCaster, oTarget));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(oAoE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    PRCSetSchool();
}