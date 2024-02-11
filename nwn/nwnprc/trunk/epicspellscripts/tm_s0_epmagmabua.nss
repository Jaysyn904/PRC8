/////////////////////////////////////////////////
// Magma Burst: On Enter
// tm_s0_epMagmaBu.nss
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

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    //Declare major variables
    int nDamage;
    effect eDam;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect( VFX_IMP_FLAME_S );
    float fDelay;

    //Declare the spell shape, size and the location.
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        fDelay = PRCGetRandomDelay(0.5, 2.0);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
        if(!PRCDoResistSpell(oCaster, oTarget, GetTotalCastingLevel(oCaster)+SPGetPenetr(oCaster), fDelay))
        {
            //Roll damage.
            nDamage = d8(10);

            //Adjust damage for Fort Save:  How does one avoid lava and not leave the area?
            // Flying, I guess:  To bad NWN doesn't have a "Z" Axis. :D
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_FIRE, oCaster))
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
            SetLocalInt(oTarget, "MagmaBurst", 1);
        }
    }
    PRCSetSchool();
}