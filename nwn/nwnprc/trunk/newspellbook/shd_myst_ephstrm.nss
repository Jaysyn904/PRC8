/*
18/02/19 by Stratovarius

Ephemeral Storm

Master, Breath of Twilight 
Level/School: 9th/Evocation 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One living creature/2 levels, no two of which are more than 20 ft. apart 
Duration: Instantaneous
Saving Throw: Fortitude partial 
Spell Resistance: Yes

The air explodes with shadowy tendrils that slice like blades.

Targets of ephemeral storm must make a Fortitude save or die. Those who succeed take 5d6 points of damage.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        effect eDeath = SupernaturalEffect(EffectDeath(TRUE));
        effect eImplode= EffectVisualEffect(VFX_DUR_ANTILIFE_SHELL);
        effect eVis = EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY);
        //Apply the implode effect
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eImplode, PRCGetSpellTargetLocation(), 3.0);
        int nCount = 0;
        //Get the first target in the shape
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
        while (GetIsObjectValid(oTarget) && 11 > nCount)
        {
            int nRacialType = MyPRCGetRacialType(oTarget);
            // Has to be alive
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow) && !(nRacialType == RACIAL_TYPE_UNDEAD || (nRacialType == RACIAL_TYPE_CONSTRUCT && !GetIsWarforged(oTarget))))
            {
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
               float fDelay = PRCGetRandomDelay(0.4, 1.2);
               //Make SR check
               if (!PRCDoResistSpell(oShadow, oTarget, myst.nPen, fDelay))
               {
                    //Make Reflex save
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_DEATH, oShadow, fDelay))
                    {
                        DeathlessFrenzyCheck(oTarget);
                        
                        //Apply death effect and the VFX impact
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                    else
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(5), DAMAGE_TYPE_MAGICAL), oTarget));
               }
               nCount++; //Only count living creatures
            }
           //Get next target in the shape
           oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
        }
    }
}