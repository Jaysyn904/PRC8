/*:://////////////////////////////////////////////
//:: Spell Name Baleful Polymorph
//:: Spell FileName PHS_S_BaleflPoly
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 5, Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature
    Duration: Permanent
    Saving Throw: Fortitude negates, Will partial; see text
    Spell Resistance: Yes

    As polymorph, except that you change the subject into a Small or smaller
    animal of no more than 1 HD. If this is cast at a non-party member, the target
    recieves a +4 save bonus, for it being fatal.

    Small animals include:
    - Rat, Parrot, Seagull, Snake

    If the spell succeeds, the subject must also make a Will save. If this
    second save fails, the creature gains the new Wisdom, intelligence and
    Charisma of the new form.

    Even if the second save suceeds, the target is unable to cast spells, but
    does retain its orignal hit dice and classes.

    Shapechangers, Incorporeal or gaseous creatures are immune to being
    polymorphed, and Shapeshifter classes can revert back to thier normal form
    even if all the saves were failed, after one round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Rating: 3: But requires polymorph entries. Toad and Rat will be 2 of them,
    maybe more. It will be permament - ouch

    Not too sure...hmm...

    An enemy polymorph spell. Can change it and just make it an un-cancleable
    polymorph (which can be dispelled) which is obivously quite powerful.

    Shifters are immune to the cancle part.

    - Rat
    - Parrot
    - Seagull
    - Snake

    Maybe:
    - Toad (?)
//:://////////////////////////////////////////////
//:: Spell Turning Notes
//:://////////////////////////////////////////////
    This does apply. After Spell Resistance is checked on the target (IE: If
    they are naturally immune, especially via immunity to this specific spell)
    we check for spell turning.

    If it is sucessful, the caster makes the SR and save check against the
    effect.

    If they both have it, then it does as the rules say - % chance of being
    the affected one.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Do effects of spell (here for Spell turning)
void DoBalefulEffects(object oTarget, int nPolymorph, int nSpellSaveDC, object oCaster = OBJECT_SELF);

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nPolymorph = PHS_GetLocalConstant(oCaster, "PHS_BALEFUL_POLYMORPH_CHOICE");
    int bLocked = TRUE;

    // Default to Rat
    if(nPolymorph == -1)
    {
        nPolymorph = 1;
    }

    // PvP
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal Spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BALEFUL_POLYMORPH, TRUE);

        // Do a spell reistance check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Spell turning!
            int nSpellTurning = PHS_SpellTurningCheck(oCaster, oTarget, PHS_ArrayGetSpellLevel(PHS_SPELL_BALEFUL_POLYMORPH, GetLastSpellCastClass()));

            // 1 = No effect
            if(nSpellTurning == 1)
            {
                // Stop
                return;
            }
            else if(nSpellTurning == 2)
            {
                // Affect the caster only, full power.
                DoBalefulEffects(oCaster, nPolymorph, nSpellSaveDC);
            }
            else if(nSpellTurning == 3)
            {
// Affects the caster OR the target, a % type thing. Set on local that can be
// retrieved. If damaging, part damage each. If not, % chance to affect either.
                // Get the %. This one it is a chance of affecting us...
                int nFraction = FloatToInt(GetLocalFloat(oCaster, PHS_SPELL_TURNING_FRACTION) * 100);

                // Check
                // - If the d100 is LESS then nFaction, it is GOOD for the target -
                //   thus we affect the caster. Else, affect the target normally.
                if(d100() <= nFraction)
                {
                    DoBalefulEffects(oCaster, nPolymorph, nSpellSaveDC);
                }
                else
                {
                    DoBalefulEffects(oTarget, nPolymorph, nSpellSaveDC);
                }
            }
            else //if(nSpellTurning == 4)
            {
                // 4 = Spell affects both people equally at full effect.
                DoBalefulEffects(oCaster, nPolymorph, nSpellSaveDC);
                DoBalefulEffects(oTarget, nPolymorph, nSpellSaveDC);
            }
        }
    }
}

// Do effects of spell (here for Spell turning)
void DoBalefulEffects(object oTarget, int nPolymorph, int nSpellSaveDC, object oCaster = OBJECT_SELF)
{
    int bContinue = TRUE;
    if(oTarget == oCaster)
    {
        bContinue = PHS_SpellResistanceCheck(oCaster, oTarget);
    }
    if(bContinue)
    {
        // If they are not a friend (in the same faction) we take 4 away from the DC
        if(!GetFactionEqual(oTarget))
        {
            nSpellSaveDC -= 4;
        }

        // They can auto cancle if they are a shapechanger.
        int bLocked = (PHS_GetIsShapechangerSubtype(oTarget) == FALSE);

        // Declare effects
        effect eVis = EffectVisualEffect(PHS_VFX_IMP_BALEFUL_POLYMORPH);
        effect ePolymorph = EffectPolymorph(nPolymorph, bLocked);

        // Fortitude save negates
        if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
        {
            // Gaseous and so on are polymorph immune
            if(!PHS_ImmuneToPolymorph(oTarget))
            {
                // Apply polymorph effects
                PHS_ApplyPolymorphPermanentAndVFX(oTarget, eVis, ePolymorph);

                // If they fail a will save, we also apply penalties to thier
                // Intelligence, will and Charisma.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                {
                    // Penalties applied...somehow, on the hide probably...

                }
            }
        }
    }
}
