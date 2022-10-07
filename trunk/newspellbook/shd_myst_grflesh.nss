/*
18/02/19 by Stratovarius

Flesh Fails, Greater

Master, Breath of Twilight 
Level/School: 8th/Necromancy 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One living creature/level in a 20-ft.-radius spread 
Duration: Instantaneous 
Saving Throw: None 
Spell Resistance: Yes
Your foes suddenly find their bodies infused with shadowstuff, weakening them greatly.

This mystery functions like the mystery flesh fails, except that you can affect multiple subjects, and you deal either 6 points of Strength damage, 
6 points of Dexterity damage, or 4 points of Constitution damage. You must deal the same kind of ability damage to all subjects.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        int nAbil = ABILITY_STRENGTH;
        int nDam = 6;
        if (myst.nMystId == MYST_GR_FLESH_FAILS_DEX)
            nAbil = ABILITY_DEXTERITY;
        else if (myst.nMystId == MYST_GR_FLESH_FAILS_CON)
        {
            nAbil = ABILITY_CONSTITUTION;
            nDam = 4;
        } 
        
        location lTargetLocation = PRCGetSpellTargetLocation();
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_VAMPIRIC_DRAIN_PRC), lTargetLocation);
    
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while(GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
            {
                SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
                ApplyAbilityDamage(oTarget, nAbil, nDam, DURATION_TYPE_PERMANENT, TRUE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_WEAKNESS), oTarget);
            }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);               
        }
    }
}