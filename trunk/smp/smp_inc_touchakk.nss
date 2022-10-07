/*:://////////////////////////////////////////////
//:: Name Spell Touch Attack functions
//:: FileName SMP_INC_TOUCHAKK
//:://////////////////////////////////////////////
    All functions used for touch attacks

    Things like:

    // The caller will perform a Melee Touch Attack on oTarget
    // This is not an action, and it assumes the caller is already within range of
    // oTarget
    // * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
    int TouchAttackMelee(object oTarget, int bDisplayFeedback=TRUE)

    // The caller will perform a Ranged Touch Attack on oTarget
    // * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
    int TouchAttackRanged(object oTarget, int bDisplayFeedback=TRUE)

    ARMOR CLASS
    Your Armor Class (AC) represents how hard it is for opponents to land a
    solid, damaging blow on you. It’s the attack roll result that an opponent
    needs to achieve to hit you. Your AC is equal to the following: 10 + armor
    bonus + shield bonus + Dexterity modifier + size modifier

    Note that armor limits your Dexterity bonus, so if you’re wearing armor, you
    might not be able to apply your whole Dexterity bonus to your AC.

    Sometimes you can’t use your Dexterity bonus (if you have one). If you can’t
    react to a blow, you can’t use your Dexterity bonus to AC. (If you don’t
    have a Dexterity bonus, nothing happens.)

    Other Modifiers: Many other factors modify your AC.
    Enhancement Bonuses: Enhancement effects make your armor better.
    Deflection Bonus: Magical deflection effects ward off attacks and improve your AC.
    Natural Armor: Natural armor improves your AC.
    Dodge Bonuses: Some other AC bonuses represent actively avoiding blows. These bonuses are called dodge bonuses. Any situation that denies you your Dexterity bonus also denies you dodge bonuses. (Wearing armor, however, does not limit these bonuses the way it limits a Dexterity bonus to AC.) Unlike most sorts of bonuses, dodge bonuses stack with each other.

    Touch Attacks: Some attacks disregard armor, including shields and natural
                   armor. In these cases, the attacker makes a touch attack roll
                   (either ranged or melee). When you are the target of a touch
                   attack, your AC doesn’t include any armor bonus, shield bonus,
                   or natural armor bonus. All other modifiers, such as your
                   size modifier, Dexterity modifier, and deflection bonus (if
                   any) apply normally.


    Touch Spells in Combat: Many spells have a range of touch. To use these
    spells, you cast the spell and then touch the subject, either in the same
    round or any time later. In the same round that you cast the spell, you may
    also touch (or attempt to touch) the target. You may take your move before
    casting the spell, after touching the target, or between casting the spell
    and touching the target. You can automatically touch one friend or use the
    spell on yourself, but to touch an opponent, you must succeed on an attack
    roll.

    Touch Attacks: Touching an opponent with a touch spell is considered to be
    an armed attack and therefore does not provoke attacks of opportunity.
    However, the act of casting a spell does provoke an attack of opportunity.
    Touch attacks come in two types: melee touch attacks and ranged touch
    attacks. You can score critical hits with either type of attack. Your
    opponent’s AC against a touch attack does not include any armor bonus,
    shield bonus, or natural armor bonus. His size modifier, Dexterity modifier,
    and deflection bonus (if any) all apply normally.

    Holding the Charge: If you don’t discharge the spell in the round when you
    cast the spell, you can hold the discharge of the spell (hold the charge)
    indefinitely. You can continue to make touch attacks round after round. You
    can touch one friend as a standard action or up to six friends as a full-round
    action. If you touch anything or anyone while holding a charge, even
    unintentionally, the spell discharges. If you cast another spell, the touch
    spell dissipates. Alternatively, you may make a normal unarmed attack (or an
    attack with a natural weapon) while holding a charge. In this case, you
    aren’t considered armed and you provoke attacks of opportunity as normal for
    the attack. (If your unarmed attack or natural weapon attack doesn’t provoke
    attacks of opportunity, neither does this attack.) If the attack hits, you
    deal normal damage for your unarmed attack or natural weapon and the spell
    discharges. If the attack misses, you are still holding the charge.

    Note:
    RAY Touch attacks can cause criticals, or at least, thats what I have
    decerned from the text. You should also be able to take Weapon Focus: Ray,
    and Improved Critical: Ray and Weapon Specilisation: Ray, but I will not, and
    never, add these. The critical one most cirtainly is impossible.

    Note 2: Anything can be a critical hit.

    Note 3: Does the Bioware functions count concealment? If not, need to add a bit.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

// Constants for specific types of touch attack
const int SMP_TOUCH_MELEE   = 1;
const int SMP_TOUCH_RANGED  = 2;
const int SMP_TOUCH_RAY     = 3;

// SMP_INC_TOUCHAKK. This performs a melee touch attack on oTarget.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
// * nType - SMP_TOUCH_RAY, SMP_TOUCH_MELEE, SMP_TOUCH_RANGED
//    * constants in SMP_INC_TouchAkk
int SMP_SpellTouchAttack(int nType, object oTarget, int bDisplayFeedback = TRUE);

// SMP_INC_TOUCHAKK. This performs a melee touch attack on oTarget.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
// * nType - SMP_TOUCH_RAY, SMP_TOUCH_MELEE, SMP_TOUCH_RANGED
//    * constants in SMP_INC_TouchAkk
int SMP_SpellTouchAttack(int nType, object oTarget, int bDisplayFeedback = TRUE)
{
    int nTouch;
    if(nType == SMP_TOUCH_MELEE)
    {
        // Perform the melee touch attack
        nTouch = TouchAttackMelee(oTarget, bDisplayFeedback);
    }
    else if(nType == SMP_TOUCH_RANGED)
    {
        // Perform the ranged ray touch attack
        nTouch = TouchAttackRanged(oTarget, bDisplayFeedback);
    }
    else if(nType == SMP_TOUCH_RAY)
    {
        // Perform the ranged (ray) touch attack
        nTouch = TouchAttackRanged(oTarget, bDisplayFeedback);
    }
    else // Defualt to melee
    {
        // Perform the melee touch attack
        nTouch = TouchAttackMelee(oTarget, bDisplayFeedback);
    }

    // Return the result (0, 1, 2)
    return nTouch;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
