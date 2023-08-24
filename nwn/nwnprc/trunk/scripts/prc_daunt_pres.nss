////////////////////////////////////////////////////////////////////
// Daunting Presence
// prc_daunt_pres.nss
////////////////////////////////////////////////////////////////////
/** @file DAUNTING PRESENCE [GENERAL]
You are skilled at inducing fear in your opponents.
Prerequisites: Cha 13, base attack bonus +1.
Benefit: You may take a standard action to awe an opponent.
If the opponent fails a Will saving throw (DC 10 + 1/2 your character
level + your Cha modifier), it is shaken for 10 minutes. This is a 
mind-affecting ability.

Special: A fighter may select Daunting Presence as one of
his fighter bonus feats.
*/
//////////////////////////////////////////////////////
// Tenjac   5/16/08
//////////////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nHD = GetHitDice(oPC);
            nHD = nHD/2;
                    
        int nDC = (10 + nHD + GetAbilityModifier(ABILITY_CHARISMA, oPC));
        
        //Must have intelligence score... since everything in NWN does, we have to fudge a little
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, TurnsToSeconds(10));
                }
        }
}