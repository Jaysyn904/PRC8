/* Body Lamp Dazzle racial ability for Ashrati
   Dazzle enemies*/
#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        location lTarget = GetLocation(oPC);
        effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC) + GetHitDice(oPC)/2;
        //Get the first target in the radius around the caster
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
        while(GetIsObjectValid(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            if(oPC != oTarget && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                effect eDazzle = SupernaturalEffect(EffectDazzle());
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, 60.0);
            }
            //Get the next target in the specified area around the caster
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
        }
}

