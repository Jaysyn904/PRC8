/////////////////////////////////////////////////////////////////
// Screaming Flask
// sp_scrmngfl.nss
/////////////////////////////////////////////////////////////////
/*
Screaming Flask: This container is made from thick
leather with a cap sewn on tight and fitted with a ripcord.
Pulling the cord rips open the flask and activates the alchemical
substance within. The flask emits a high-pitched shriek
in a 15-foot cone. Anything in the cone takes ld8 points of
sonic damage and is deafened for 1 minute (Fortitude DC
15 negates). */

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        effect eDeaf = EffectDeaf();
        location lLoc = PRCGetSpellTargetLocation();
        int nDam;
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        
        while(GetIsObjectValid(oTarget))
        {
                nDam = d8(1);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_SONIC), oTarget);
                
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_SONIC))
                {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, TurnsToSeconds(1));
                }
                
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 11.0, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
}