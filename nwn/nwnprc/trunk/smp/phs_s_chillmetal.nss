/*:://////////////////////////////////////////////
//:: Spell Name Chill Metal
//:: Spell FileName PHS_S_ChillMetal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Cold]
    Level: Drd 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: Metal equipment of one enemy creature per two
              levels, within a 10-M. radius.
    Duration: 7 rounds
    Saving Throw: Will negates
    Spell Resistance: Yes

    Chill metal makes metal extremely cold, damaging the holding creature.

    A creature takes cold damage if its equipment is chilled. It takes full
    damage if it is holding a metal weapon, using a shield and wearing metal
    armor. It takes half damage if it is only carrying a shield and metal weapon,
    or armor with no shield or metal weapon, or take 1/4 damage if it is holding
    just a metal weapon or just a metal shield. The creature takes minimum damage
    (1 point or 2 points; see the table) even if it isn't wearing anything metal.

    On the first round of the spell, the metal becomes chilly and uncomfortable
    to touch but deals no damage. The same effect also occurs on the last round
    of the spell’s duration. During the second (and also the next-to-last) round,
    icy coldness causes pain and damage. In the third, fourth, and fifth rounds,
    the metal is freezing cold, causing more damage, as shown on the table below.

    Round   Metal Temperature   Damage
    1       Cold                None
    2       Icy                 1d4 points
    3-5     Freezing            2d4 points
    6       Icy                 1d4 points
    7       Cold                None

    Chill metal counters and dispels heat metal.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, ok, ok...affects enemies only

    Easy enough, it does this:

    - May target allies if they have Heat Metal on them, because it will dispel it.
    - If it is an enemy, it will chill only if they are not already being chilled.
    - Will apply a duration effect, and do a heartbeat effect lasting 7 rounds.

    Like ACid arrow. Damage:

    - Full: Using a metal weapon, a shield, and metal armor
    - Half: Just armor, or a shield and a metal weapon (or two metal weapons, duh!)
    - Quarter: Just a metal weapon or just a shield
    - Minimum: No metal weapon, shield or armor on.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Put in 1 to start. Works from nRound goes to 7.
// Does damage each round based on equipment.
void DoChillEffect(int nRound, object oTarget, object oCaster, int nMetaMagic);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;

    // Duration is 7 rounds always
    float fDuration = RoundsToSeconds(7);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDispel = EffectVisualEffect(VFX_IMP_DISPEL);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_CHILL_METAL);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 10M radius.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // Get the distance between the explosion and the target to calculate delay
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

        // Check if an ally
        if(GetIsFriend(oTarget))
        {
            // Dispels heat metal
            if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_HEAT_METAL, oTarget, fDelay))
            {
                // Fire cast spell at event for the specified target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CHILL_METAL, FALSE);

                // Dispel VFX
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eDispel));
            }
        }
        // PvP Check
        else if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget) &&
        // Not got the spell effect too
           !GetHasSpellEffect(PHS_SPELL_CHILL_METAL, oTarget))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CHILL_METAL);

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Will save negates
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_COLD, oCaster, fDelay))
                {
                    DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration));
                    // We start on round 2, so put in 1
                    DelayCommand(fDelay + 6.0, DoChillEffect(1, oTarget, oCaster, nMetaMagic));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

// Put in 1 to start. Works from nRound goes to 7.
// Does damage each round based on equipment.
void DoChillEffect(int nRound, object oTarget, object oCaster, int nMetaMagic)
{
    if(GetIsObjectValid(oTarget) && GetIsObjectValid(oCaster) &&
       GetHasSpellEffect(PHS_SPELL_CHILL_METAL, oTarget))
    {
        // Will only do damage on rounds 2 to 6.
        int nCurrentRound = nRound + 1;

        // Get rounds
        if(nCurrentRound > 2)
        {
            // Get percent of damage to take. Could be 1 or 2, or all of it.

            // We get 25% less per weapon slot, or 50% less per armor.
            float fPercent = 0.0;
            object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
            // 4 or more is metal armor - chain shirt is meta, studded leather is not.
            if(PHS_GetArmorType(oItem) >= 4)
            {
                fPercent += 0.5;
            }
            int nCnt;
            //int    INVENTORY_SLOT_RIGHTHAND = 4;
            //int    INVENTORY_SLOT_LEFTHAND  = 5;
            for(nCnt = INVENTORY_SLOT_RIGHTHAND; nCnt <= INVENTORY_SLOT_LEFTHAND; nCnt++)
            {
                // Check hand weapons
                oItem = GetItemInSlot(nCnt, oTarget);
                // Need a shield (any) or it to be a metal weapon.
                if(PHS_GetIsMetalWeapon(oItem) ||
                   PHS_GetIsShield(oItem))
                {
                    fPercent += 0.25;
                }
            }
            // We time damage by fPercent, noting that if fPercent is 0, we
            // just do minimum damage

            int nDam, nDice;
            // Get possible damage.
            if(nCurrentRound == 2 || nCurrentRound == 6)
            {
                nDice = 1;
            }
            else
            {
                nDice = 2;
            }
            // Check percent of damage
            if(fPercent != 0.0)
            {
                nDam = FloatToInt(IntToFloat(PHS_MaximizeOrEmpower(4, 1, nMetaMagic)) * fPercent);
            }
            else
            {
                nDam = nDice;
            }
            // Do damage, if any
            if(nDam <= nDice)// Should never be true
            {
                nDam = nDice;
            }

            // Do damage and VFX
            effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
            PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_COLD);
        }
        // If we are at 5 or less (if we are at 6, when it next fires, it'll be round 7!)
        if(nCurrentRound <= 5)
        {
            DelayCommand(6.0, DoChillEffect(nCurrentRound, oTarget, oCaster, nMetaMagic));
        }
    }
}
