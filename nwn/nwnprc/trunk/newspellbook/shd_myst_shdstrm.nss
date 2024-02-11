/*
16/02/19 by Stratovarius

Shadow Storm

Initiate, Elemental Shadows 
Level/School: 6th/Evocation [Electricity, Cold] 
Range: Medium (100 ft. + 10 ft./level) 
Targets: One primary target, plus one secondary target/ level (each of which must be within 30 ft. of the primary target) 
Duration: Instantaneous 
Saving Throw: Reflex half 
Spell Resistance: Yes

From a sudden rift into the Plane of Shadow, a cold wind begins to blow. Torrents of shadow arc out, draining the life from nearby creatures.

This mystery creates a blast of electricity and cold energy, much like some of the most fearsome weather found on the Plane of Shadow. The 
storm strikes one target initially, then arcs to other targets. The storm deals 1d6 points of damage per caster level (maximum 20d6). Half 
of this damage is electricity damage, and the other half is cold damage. After it strikes, the storm arcs (like the spell chain lightning) 
to a number of secondary targets equal to your caster level (maximum twenty). The secondary arcs each strike one target and deal half as 
much damage as the primary one did (round down).
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oFirstTarget = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oFirstTarget, (METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        int nDie = min(myst.nShadowcasterLevel, 20); 
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.nSaveDC = GetShadowcasterDC(oShadow);
        effect eCold = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_COLD);
        effect eElec = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oShadow, BODY_NODE_HAND);
        effect eFreezing = EffectBeam(VFX_BEAM_COLD, oShadow, BODY_NODE_HAND);
        object oHolder;
        int nDamage;
        
        // Only creatures, and PvP check.
        if(spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oFirstTarget, myst.nPen))
            {                
                nDamage = MetashadowsDamage(myst, 6, nDie);
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oFirstTarget, myst.nSaveDC, SAVING_THROW_TYPE_ELECTRICITY);
                if(nDamage > 0)
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oFirstTarget, nDamage/2, DAMAGE_TYPE_COLD), oFirstTarget);
                    DelayCommand(0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oFirstTarget, nDamage/2, DAMAGE_TYPE_ELECTRICAL), oFirstTarget));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oFirstTarget);
                    DelayCommand(0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oFirstTarget));
                }
            }    
        }       
    
        //Apply the lightning stream effect to the first target, connecting it with the caster
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oFirstTarget, 0.5, FALSE);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreezing, oFirstTarget, 0.5, FALSE);
        //Reinitialize the lightning effect so that it travels from the first target to the next target
        eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);        
        eFreezing = EffectBeam(VFX_BEAM_COLD, oFirstTarget, BODY_NODE_CHEST);

        //Get the first target in the spell shape
        float fDelay = 0.2;
        int nCnt = 0;    
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget) && nCnt < myst.nShadowcasterLevel)
        {
            //Make sure the caster's faction is not hit and the first target is not hit
            if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow) && oTarget != oShadow)
            {
                //Connect the new lightning stream to the older target and the new target
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 0.5, FALSE));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreezing, oTarget, 0.5, FALSE));

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
                //Do an SR check
                if (!PRCDoResistSpell(oShadow, oTarget, myst.nPen, fDelay))
            {
                int nDC = GetShadowcasterDC(oShadow);
                nDamage = MetashadowsDamage(myst, 6, nDie)/2; // Half damage to secondary
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY);
                if(nDamage > 0)
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage/2, DAMAGE_TYPE_COLD), oTarget);
                    DelayCommand(0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage/2, DAMAGE_TYPE_ELECTRICAL), oTarget));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget);
                    DelayCommand(0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oTarget));
                }
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);        
                eFreezing = EffectBeam(VFX_BEAM_COLD, oHolder, BODY_NODE_CHEST);
            }

            fDelay = fDelay + 0.1f;
        }
        //Count the number of targets that have been hit.
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            nCnt++;

        //Get the next target in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }      
    }
}