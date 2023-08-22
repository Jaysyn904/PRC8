/*:://////////////////////////////////////////////
//:: Spell Name Mage’s Sword
//:: Spell FileName PHS_S_MagesSword
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 7
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: One sword
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    This spell brings into being a shimmering, swordlike plane of force. The
    sword strikes at any opponent within its range. The sword attacks a target
    once each round. Its attack bonus is equal to your caster level + your Int
    bonus or your Cha bonus (for wizards or sorcerers, respectively) with an
    additional +3 enhancement bonus. It deals 4d6+3 points of damage, with a
    threat range of 19-20 and a critical multiplier of x2.

    If the sword goes beyond the spell range from you, if it goes out of your
    sight, or if you are not directing it, the sword returns to you and hovers.

    Each round after the first, you can use a standard action to switch the
    sword to a new target. If you do not, the sword continues to attack the
    previous round’s target.

    The sword cannot be attacked or harmed by physical attacks, but dispel
    magic, disintegrate, a sphere of annihilation, or a rod of cancellation
    affects it. The sword’s AC is 13 (10, +0 size bonus for Medium object, +3
    deflection bonus).

    If an attacked creature has spell resistance, the resistance is checked
    the first time Mage’s sword strikes it. If the sword is successfully
    resisted, the spell is dispelled. If not, the sword has its normal full
    effect on that creature for the duration of the spell.

    Focus: A miniature platinum sword with a grip and pommel of copper and
    zinc. It costs 250 gp to construct.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It will use a new On Hit: Spell Cast At script to check spell resistance.

    It summons the sword, it attacks, fair enough. It will, due to NwN's real-time
    engine, move automatically to new targets within 8M of the caster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGES_SWORD)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare visual effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_MAGES_SWORD, FALSE);

    // Create the sword.
    object oSword = CreateObject(OBJECT_TYPE_CREATURE, PHS_CREATURE_RESREF_MAGES_SWORD, lTarget);

    // Assign its new master
    AddHenchman(oCaster, oSword);

    // Apply the duration VFX
    PHS_ApplyDurationAndVFX(oSword, eVis, eDur, fDuration);

    // And add its appropriate attack bonus via. Leveling the creature up to level
    // 20 (each level = +1 natural attack!).
    int nStat;
    // Check if it was cast from an item
    if(GetIsObjectValid(GetSpellCastItem()))
    {
        // Minimum bonus stat needed to cast the spell
        nStat = 7;
    }
    else
    {
        // Else normal ability
        nStat = PHS_LimitInteger(PHS_GetAppropriateAbilityBonus(), 20);
    }

    // Apply level up
    if(nStat > 1)
    {
        int nCnt;
        int nPackage = GetCreatureStartingPackage(oSword);
        for(nCnt = 1; nCnt < nStat; nCnt++)
        {
            // Always stop if it doesn't work.
            if(LevelUpHenchman(oSword, CLASS_TYPE_MAGICAL_FORCE, FALSE, nPackage) == 0)
            {
                // Debug
                SendMessageToPC(oCaster, "Debug: Uh-oh, magical sword didn't level...");
                break;
            }
        }
    }
}
