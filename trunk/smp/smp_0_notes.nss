void main(){}
/*  NOTES ON THINGS:

    RANGES:
    1.67  | 5 Feet
    3.33  | 10 Feet
    5.0   | 15 Feet
    6.67  | 20 feet
    8.33  | 25 Feet  - Roughly "Close" range
    10.0  | 30 Feet
    11.67 | 35 Feet
    13.33 | 40 Feet
    15.0  | 45 Feet
    16.67 | 50 Feet
    18.33 | 55 Feet
    20.0  | 60 Feet  - Roughly "Medium" range
    21.67 | 65 Feet
    23.33 | 70 Feet
    25.0  | 75 Feet
    26.67 | 80 Feet
    28.33 | 85 Feet
    30.0  | 90 Feet
    31.67 | 95 Feet
    33.33 | 100 Feet
    35.0  | 105 Feet
    36.67 | 110 Feet
    38.33 | 115 Feet
    40.0  | 120 Feet - Roughly "Long" range.

    Please make sure, for all new spells, stuff in this thread is looked at

    http://boards1.wizards.com/showthread.php?s=&threadid=63970

    > Main changes:
      - Conjuration (Not teleporting ones) do not have SR checks (they actually conjure energy)
      - Ice storm can be extended (Second round does 5d6 damage again)


    There is no such thing as /magic, /good, /evil and so on. These were introduced
    as new rules for damage resistance. They will be transfered into NwN's 3E
    ruleset as best as possible.

    Oh, added Eldernurin's Buffeting code, and modified for use, for use in
    many spells where people are "pushed back".

    --------------
    Tatics:

    - Polymorph an enemy creature (polymorph any object) then attempt to kill
    them, disable them with dominate monster, or so on. Thier races and special
    attacks change!

    - As a sorceror, take advantage of the spells whicha allow the emulation of
    other spells, or a variety of effects - Telekinesis, Polymorph Any Object,
    Shadow conjuration, Limited Wish...

    - Make summon monsters...do special stuff, like walk onto trapped areas,

    -------------


    Add for spell turning:

//:://////////////////////////////////////////////
//:: Spell Turning Notes
//:://////////////////////////////////////////////


//////////// SCROLLS AND WANDS /////////////////////////////////////////////////
    Scrolls and wands are, of course, going to have to be created.

    Scrolls are usually the lowest caster level possible for them, so sometimes
    a variable amount.

    Bioware also added some other levels, like every 5 or 10 or so.

    Item tag == item resref.

    Tags: PHS_X_0000_11,
    X = S (Scroll), W (Wand), R (Rod/Stave, same thing), etc
    0000 = 4 digit number for the spells.2da reference for the spell. Note that
    anything under 1000 will be, for example, 0021, not just 21.
    11 = Caster level. 01-40
//////////// SCROLLS AND WANDS /////////////////////////////////////////////////

    Use to hit anyone (except special Party PvP cases), and no one in No PvP
    -- GetIsReactionTypeFriendly() --
    This means:
    - Will hit anyone normally (Full PvP)
    - Will not hit "Friendly" people in Party PvP, or No PvP (in Player list)
    - Neutrality is ignored, and is as if they were hostile.
    - Will not hit anyone in No PvP, everyone is considered friendly

    Use to hit only enemies, and no one in No PvP
    -- GetIsReactionTypeHostile() --
    - Will only hit enemies
    - Will not hit anyone in No PvP
    - Will not hit neutrals (That is party members, and anyone not
      in a party in full PvP)

    You can apply multiple effects of the same spell - they do both get applied.
    Some effects do not stack, however!

    Also, you can apply 2 effects seperatly, and they will wear out seperatly,
    so as for Colour Spray, the Blindness and the Sleep can be applied seperatly
    and thus be resisted seperatly, and also run out seperatly.

    VFX_IMP_ACID_L doesn't exsist!
    VFX_IMP_POISON_L is the same as VFX_IMP_POISON_S

    Each spell needs (Checklist):
    - Correct Spell Hook
    - Signal Spell Cast At Event against the creature
    - At *least* !PHS_TotalSpellImmunity(oTarget) in there somewhere. It is
      not needed if PHS_SpellResistanceCheck() is there instead.

    Remember, for the lines in the .2da, add 16777216 + (tlk entry number) for
    the name and descriptions.
    88,000 - 97,999 -- Spellmans Project
    88,000+ are special things (such as text strings on heads).
    89,000+ are spell names and descriptions.
    94K?+ might be item descriptions, names etc.

    Oh, and it goes:
    - Name (even) Description (odd) most of the time.
    - SRD spells will be first (minus removed ones).
      - 89000 - 89101 so far
    - Other spells will come after in any good order (noted here)
*/

//Color used by saving throws.
const string COLOR_BLUE         = "<cfÌþ>";

//Color used for electric damage.
const string COLOR_DARK_BLUE    = "<c fþ>";

//Color used for negative damage.
const string COLOR_GRAY         = "<c&#8482;&#8482;&#8482;>";

//Color used for acid damage.
const string COLOR_GREEN        = "<c þ >";

//Color used for the player's name, and cold damage.
const string COLOR_LIGHT_BLUE   = "<c&#8482;þþ>";

//Color used for system messages.
const string COLOR_LIGHT_GRAY   = "<c°°°>";

//Color used for sonic damage.
const string COLOR_LIGHT_ORANGE = "<cþ&#8482; >";

//Color used for a target's name.
const string COLOR_LIGHT_PURPLE = "<cÌ&#8482;Ì>";

//Color used for attack rolls and physical damage.
const string COLOR_ORANGE       = "<cþf >";

//Color used for spell casts, as well as magic damage.
const string COLOR_PURPLE       = "<cÌwþ>";

//Color used for fire damage.
const string COLOR_RED          = "<cþ  >";

//Color used for positive damage.
const string COLOR_WHITE        = "<cþþþ>";

//Color used for healing, and sent messages.
const string COLOR_YELLOW       = "<cþþ >";
