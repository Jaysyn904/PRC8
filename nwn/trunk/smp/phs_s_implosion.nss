/*:://////////////////////////////////////////////
//:: Spell Name Implosion
//:: Spell FileName PHS_S_Implosion
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M range. Fort and SR negates. 1 corporal creature/round, up to 4 rounds.

    "You can target a particular creature only once with each casting of the
    spell. When cast, it automatically targets the 3 nearest seen targets to the
    orignal, within the spells range, for the other targets. To stop concentration,
    move or cancle the castings of the spell."
    Implosion has no effect on creatures in gaseous form or on incorporeal
    creatures.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cool spell.

    It does add a new casting of this, up to 4 creatures (nearest to the
    original target, seen, and within 8M). If less then 4 exsist, then less
    then that are cast.

    They are cheat-cast, and added to the action queue after a ClearAllActions
    which means they cannot be abused. To stop 4 more being added, checks are
    made on the target object for "they were targeted by implosion before", if
    true, the spell is not a new one.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_IMPLOSION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCnt, nAttacked;
    string sReference = "IMPLOSION_TARGET" + ObjectToString(oCaster);
    int bTargeted = GetLocalInt(oTarget, sReference);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_FNF_IMPLOSION);
    effect eDeath = EffectDeath(TRUE);

    // Apply AOE to the target, dispite saves
    PHS_ApplyVFX(oTarget, eVis);

    // Apply death to them
    // Reaction type check
    if(!GetIsReactionTypeFriendly(oTarget) && !PHS_GetIsIncorporeal(oTarget))
    {
        // Spell resistance + immunity
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Fortitude save
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH))
            {
                // Apply death
                PHS_ApplyInstant(oTarget, eDeath);
            }
        }
        // Check local variable for "They are the target of a second or more implosion
        // spell". Only done if not in a no PvP area!
        if(!bTargeted)
        {
            // More targets!
            // Stop what we were going to do
            ClearAllActions();
            // Loop
            nCnt = 1;
            oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, nCnt);
            // Loop until we have 3 more we have selected (And note: can check only
            // up to 50 creatures for lag reasons)
            while(GetIsObjectValid(oTarget) && nAttacked < 3 && nCnt <= 50)
            {
                // Make sure they are an enemy, are seen, and are within 8M.
                if(GetIsEnemy(oTarget) && GetObjectSeen(oTarget) &&
                   GetDistanceToObject(oTarget) <= 8.0 &&
                  !PHS_GetIsIncorporeal(oTarget))
                {
                    // Set local
                    SetLocalInt(oTarget, sReference, TRUE);
                    DelayCommand(18.0, DeleteLocalInt(oTarget, sReference));
                    // Add to target queue one casting, and increase amount cast at
                    // - Caster level + metamagic are none-exsistant for this spell.
                    ActionCastSpellAtObject(PHS_SPELL_IMPLOSION, oTarget, METAMAGIC_NONE, TRUE);
                    nAttacked++;
                }
                nCnt++;
                oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, nCnt);
            }
        }
    }
    // Make 100% we can re-target implosion on this target
    DeleteLocalInt(oTarget, sReference);
}
