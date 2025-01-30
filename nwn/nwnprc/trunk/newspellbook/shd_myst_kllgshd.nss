/*
13/02/19 by Stratovarius

Killing Shadows

Apprentice, Eyes of Darkness 
Level/School: 3rd/Transmutation 
Range: 30 ft. 
Effect: Cone 
Duration: Instantaneous 
Saving Throw: Will half 
Spell Resistance: Yes

Your eyes turn black and shoot forth a shadowy cone of punishment.

Creatures within a cone of killing shadows take 1d8 points of damage per caster level (maximum 10d8), or half that amount on a successful Will save.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    location lTargetLocation = PRCGetSpellTargetLocation();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        int nDie = PRCMin(myst.nShadowcasterLevel, 10); 
    
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while(GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
            {
                SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
                //Get the distance between the target and caster to delay the application of effects
                float fDelay = GetDistanceBetween(oShadow, oTarget)/20.0;
                //Make SR check, and appropriate saving throw(s).
                if((!PRCDoResistSpell(oShadow, oTarget, myst.nPen) && (oTarget != oShadow)) || myst.bIgnoreSR)
                {
                    int nDamage = MetashadowsDamage(myst, 8, nDie);
                    
                    // Cut it in half on success
                    if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
                        nDamage /= 2;                    

                    //Apply delayed effects
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M_PURPLE), oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_MAGICAL), oTarget));
                }
            }
        
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);   
        }
    }
}