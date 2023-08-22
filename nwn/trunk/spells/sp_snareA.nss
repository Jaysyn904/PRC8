//::///////////////////////////////////////////////
//:: Name      Snare
//:: FileName  sp_snare.nss
//:://////////////////////////////////////////////
/**@file Level:   Rgr 2, Drd 3
Components:       V, S, DF
Range:            Touch
Target:           Area with a 2 ft. diameter + 2 ft./level
Duration:         Until triggered or broken
Saving Throw:     None
Spell Resistance: No

This spell enables you to make a snare that functions
as a magic trap. When you cast this spell, 
a cordlike object blends with its surroundings 
(Search DC 23 for a character with the trapfinding 
ability to locate). One end of the snare is tied in a
loop that contracts around one or more of the limbs of
any creature stepping inside the circle.

When triggered, the cordlike object tightens around 
the creature, dealing no damage but causing it to
be entangled.

The snare is magical. To escape, a trapped creature must 
make a DC 23 Strength check that is a full-round action. 
A successful escape from the snare breaks the loop
and ends the spell. 

Author:    Tenjac
Created:   8/9/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void StrengthCheck(object oTarget, object oCreator);

#include "prc_inc_spells"

void main()
{
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    effect eLink = EffectLinkEffects(EffectEntangle(), EffectVisualEffect(VFX_DUR_ENTANGLE));

    if(oTarget != oCreator)
    {
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        DestroyObject(OBJECT_SELF);

        StrengthCheck(oTarget, oCreator);
    }
}

void StrengthCheck(object oTarget, object oCreator)
{
    int nStrBonus = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nRoll = d20(1) + nStrBonus;
    effect eTest;

    if(GetIsPC(oTarget))
    {
        SendMessageToPC(oTarget, "Strength check vs DC 23: " + IntToString(nRoll));
    }

    //DC23 STR check
    if(nRoll >22)
    {
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if (GetEffectCreator(eTest) == oCreator)
            {
                if(GetEffectSpellId(eTest) == SPELL_SNARE)
                {
                    RemoveEffect(oTarget, eTest);
                }
            }
            eTest = GetNextEffect(oTarget);
        }
    }
    else DelayCommand(6.0f, StrengthCheck(oTarget, oCreator));
}