//::///////////////////////////////////////////////
//:: Wall of Fire: Heartbeat
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

#include "inv_inc_invfunc"

void main()
{
    SetAllAoEInts(INVOKE_VFX_PER_WALLPERILFIRE,OBJECT_SELF, GetSpellSaveDC());

    object oCaster = GetAreaOfEffectCreator();
    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if(!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Declare major variables
    int nDamage;
    effect eDam;
    int nCasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster, nCasterLvl);
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    //cap the extra damage
    nCasterLvl = PRCMin(nCasterLvl, 20);

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_WALL_OF_PERILOUS_FLAME));
            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                //Roll damage.
                nDamage = d6(4) + nCasterLvl;

                //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                int nDC = GetInvocationSaveDC(oTarget, oCaster, INVOKE_WALL_OF_PERILOUS_FLAME);
				
				if (GetHasFeat(FEAT_ABFOC_WALL_OF_PERILOUS_FLAME, oCaster)) nDC += 2;
				
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage/2, DAMAGE_TYPE_FIRE), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage/2, DAMAGE_TYPE_MAGICAL), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
