/*:://////////////////////////////////////////////
//:: Spell Name Spectral Hand
//:: Spell FileName PHS_S_SpectralHa
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: One spectral hand
    Duration: 1 min./level (D)
    Saving Throw: None
    Spell Resistance: No

    A ghostly, glowing hand shaped from your life force materializes and moves
    as you desire, allowing you to deliver low-level, touch range spells at a
    distance. On casting the spell, you lose 1d4 hit points that return when the
    spell ends (even if it is dispelled), but not if the hand is destroyed.
    (The hit points can be healed as normal.)

    For as long as the spell lasts, any hostile touch range spell of 4th level or lower
    that you cast can be delivered by the spectral hand. To do this, cast the
    spell at yourself (which will normally fail) and it will activate on the
    hand's target. The spell gives you a +2 bonus on your melee touch attack
    roll. After it delivers a spell, or if the hand goes beyond the spell range,
    goes out of your sight, the hand returns to you and hovers.

    The hand is incorporeal and thus has damage reduction 50/+1. It has improved
    evasion (half damage on a failed Reflex save and no damage on a successful
    save), your save bonuses (minimum 0), and an AC of at least 22. Your
    Intelligence modifier applies to the hand’s AC as if it were the hand’s
    Dexterity modifier. The hand has 1 to 4 hit points, the same number that you
    lost in creating it.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, this is how it works:

    - Creates a "hand" creatures. For easy sakes, we make it so we have 4
      versions for the 4 different amounts of HP, plus 2 more for if we
      are able to empower it (thus it can go up to 6HP).
    - Damages the caster. Also applies, to the new hand object, the ghost,
      save bonuses and dexterity bonuses as noted above as normal, linked
      effects. Visual might be appopriately applied too.

    How it works:

    - Level 4 and below "touch" ranged spells can be passed though it.
      These spells currently are (with + being wizard ones):
     +- Bestow Curse (Clr 3, Sor/Wiz 4)
      - Blight, if druid cast it (Drd 4, Sor/Wiz 5)
     +- Chill Touch (Sor/Wiz 1)
     +- Contagion (Clr 3, Destruction 3, Drd 3, Sor/Wiz 4)
      - Death Knell (Clr 2, Death 2)
     +- Ghoul Touch (Sor/Wiz 2)
      - Poison (Clr 4, Drd 3)
      - Rusting Grasp (Drd 4)
     +- Shocking Grasp (Sor/Wiz 1)
     +- Touch of Fatigue (Sor/Wiz 0)
     +- Touch of Idiocy (Sor/Wiz 2)
     +- Vampiric touch (Sor/Wiz 3)
      (Note: Only allowing hostile ones, its easier, because they wouldn't
       be cast on self, unlike Mage Armor, and Virtue etc.)

    - Once cast on the caster, it checks if a hand is present and directed
      at something. If it is, then it will change the target to the person
      targeted by the hand.
      (Note: No target/No hand means spell fails, it won't target the caster,
       it might come under abuse like Vampiric Touch)
      (Note 2: It should add 2 to the melee attack, for 1 second or so, as
       the spell states)
      (Note 3: It should mvoe the hand back, until redirected, after a spell
       like this is cast)
      (Note 4: Hand must be near enough the target to actually be a valid target.
       No good just targeting and saying "go there hand" and it not being
       able to reach, eg: too far away from the spells range)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{

}
