/*
18/02/19 by Stratovarius

Life Fades, Greater

Master, Breath of Twilight 
Level/School: 7th/Necromancy 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One living creature/level in a 20-ft.-radius spread 
Duration: Instantaneous 
Saving Throw: Fortitude partial 
Spell Resistance: Yes

Draining shadows erupt around your foes, funneling their essence and energy into the Plane of Shadow.

Your touch deals 1d6 points of damage per caster level (maximum 20d6) and causes the subject to become exhausted for 1 round per caster level
(a Fortitude save reduces the damage by half and decreases the exhaustion to fatigue). 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        int nDie = PRCMin(myst.nShadowcasterLevel, 20); 
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
                //Get the distance between the target and caster to delay the application of effects
                float fDelay = GetDistanceBetween(oShadow, oTarget)/20.0;
                //Make SR check, and appropriate saving throw(s).
                if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen))
                {
                    int nDamage = MetashadowsDamage(myst, 6, nDie);
                    myst.eLink = EffectFatigue();
                    
                    // Cut it in half on success
                    if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
                    {
                        nDamage /= 2;              
                        myst.eLink = EffectExhausted();
                    }    

                    //Apply delayed effects
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY), oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_MAGICAL), oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel));
                }
            }
            //Select the next target within the spell shape.
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTargetLocation, TRUE, OBJECT_TYPE_CREATURE); 
        }      
    }
}