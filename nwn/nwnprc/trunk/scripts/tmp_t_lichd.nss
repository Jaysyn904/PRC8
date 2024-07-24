//::///////////////////////////////////////////////
//:: Name           Celestial template test script
//:: FileName       tmp_t_celest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creating A Demilich
        
    "Demilich" is a template that can be added to any lich. It uses all the lich’s statistics and 
    special abilities except as noted here. A demilich’s form is concentrated into a single portion 
    of its original body, usually its skull. Part of the process of becoming a demilich includes the 
    incorporation of costly gems into the retained body part; see Creating Soul Gems, below.

    Size

    Medium-size and Large liches become Diminutive demiliches, Huge liches become Small demiliches, 
    Gargantuan liches become Medium-size demiliches, and Colossal liches become Large demiliches.

    Hit Dice

    As lich.

    Speed

    Change to fly 180 ft. (perfect). The lich’s supernatural fly speed, if any, is also retained.

    AC

    The demilich retains the lich’s +5 natural armor bonus and gains an insight bonus to AC equal to its Hit Dice, 
    as well as a probable size adjustment to AC.

    Attack

    The demilich gains an insight bonus equal to its Hit Dice as a bonus on its touch attacks.

    Damage

    The demilich gains an enhanced touch attack over that of its previous lich form (it now uses its entire 
    flying skull to make the touch attack), including paralyzing touch. The demilich’s touch attack uses 
    negative energy to deal 10d6+20 points of damage to living creatures (no saving throw). Liches with 
    other natural attacks lose them.

    Special Attacks

    The demilich retains all the lich’s special attacks and also gains those described below.

    Trap the Soul (Su)

    A demilich can trap the souls of up to eight living creatures per day. To use this power, it selects 
    any target it can see within 300 feet. The target is allowed a Fort saving throw (DC 10 + demilich’s 
    HD + demilich’s Cha modifier). If the target makes its saving throw, it gains four negative levels 
    (this does not count as a use of trap the soul). If the target fails its save, the soul of the target 
    is instantly drawn from its body and trapped within one of the gems incorporated into the demilich’s form. 
    The gem gleams wickedly for 24 hours, indicating the captive soul within. The soulless body collapses 
    in a mass of corruption and molders in a single round, reduced to dust. If left to its own devices, 
    the demilich slowly devours the soul over 24 hours—at the end of that time the soul is completely absorbed, 
    and the victim is forever gone. If the demilich is overcome before the soul is eaten, crushing the gem 
    releases the soul, after which time it is free to seek the afterlife or be returned to its body by the 
    use of either resurrection, true resurrection, clone, or miracle. If the demilich is overcome before the 
    soul is eaten, crushing the gem releases the soul, after which time it is free to seek the afterlife or 
    be returned to its body by the use of either resurrection, true resurrection, clone, or miracle. A 
    potential victim protected by a death ward spell is not immune to trap the soul, but receives a +5 
    bonus on its Fortitude saving throw and is effective against the level loss on a successful save.

    Fear Aura (Su)

    Demiliches are shrouded in a dreadful aura of death and evil. Creatures of less than 5 HD in a 60-foot 
    radius that look at the demilich must succeed at a Will save (DC 14 + demilich’s Cha modifier) or be 
    affected as though by fear as cast by a 21st-level caster.

    Paralyzing Touch (Su)

    Any living creature a demilich touches must succeed at a Fortitude save (DC 10 + demilich’s HD + demilich’s 
    Cha modifier) or be permanently paralyzed. Remove paralysis or any spell that can remove a curse can free 
    the victim. The effect cannot be dispelled. Anyone paralyzed by a demilich seems dead, though a successful 
    Spot check (DC 20) or Heal check (DC 15) reveals that the victim is still alive.

    Spells

    The demilich can cast any spells it could cast as a lich.

    Perfect Automatic Still Spell

    The demilich can cast all the spells it knows without gestures.

    Spell-Like Abilities

    At will:alter self, astral projection, create greater undead, create undead, death knell, enervation, 
    greater dispel magic, harm (usually used to heal itself), summon monster I-IX, telekinesis, and weird; 
    2/day: greater planar ally. Demiliches use these abilities as casters of a level equal to their spellcaster 
    level, but the save DCs are equal to 10 + the demilich’s HD + the demilich’s Charisma modifier.

    Special Qualities

    The demilich retains all the lich’s special qualities and also has those described below.

    Magic Immunity (Ex)

    Demiliches are immune to all magical and supernatural effects, except as follows. A shatter spell affects 
    a demilich as if it were a crystalline creature, but deals half the damage normally indicated. A dispel 
    evil spell deals 3d6 points of damage (Fort save for half damage). Holy smite spells affect demiliches normally.

    Phylactery Transference (Su)

    Headbands, belts, rings, cloaks, and other wearable items kept in close association with the demilich’s 
    phylactery transfer all their benefits to the demilich no matter how far apart the demilich and the 
    phylactery are located. The standard limits on types of items utilized simultaneously still apply.

    Undead Traits

    Immune to poison, sleep, paralysis, stunning, disease, death effects, necromantic effects, 
    mind-affecting effects, and any effect requiring a Fortitude save unless it also works on objects. 
    Not subject to critical hits, nonlethal damage, ability damage, ability drain, or energy drain. 
    Negative energy heals. Not at risk of death from massive damage, but destroyed at 0 hit points or less. 
    Darkvision 60 ft. Cannot be raised; resurrection works only if creature is willing.

    Immunities (Ex)

    Demiliches are immune to cold, electricity, polymorph, and mind-affecting attacks.

    Turn Resistance (Ex)

    A demilich has turn resistance +20.

    Damage Reduction (Su)

    A demilich loses any previous damage reduction and instead has damage reduction 15/Epic and bludgeoning 
    (15 points of damage is subtracted from all melee attacks unless the weapon used is both an epic and a 
    bludgeoning weapon). Vorpal weapons, no matter their enhancement bonus, ignore this damage reduction but 
    do only half damage to a demilich (demiliches cannot be beheaded).

    Resistances (Ex)

    Demiliches have acid resistance 20, fire resistance 20, and sonic resistance 20.

    Saves

    Same as the lich.

    Abilities

    A demilich gains +10 to Intelligence, Wisdom, and Charisma.

    Skills

    Demiliches receive a +20 racial bonus on Hide, Listen, Move Silently, Search, Sense Motive, and Spot checks. 
    Otherwise same as the lich (this overlaps with the previous racial bonus gained by the lich; it does not stack).

    Feats

    Same as the lich.

    Epic Feats

    Demiliches gain the feats Blinding Speed, Tenacious Magic, and Automatic Quicken Spell.

    Climate/Terrain

    Same as the lich.

    Organization

    Solitary or consistory (1 demilich and 3-6 liches).

    Challenge Rating

    Same as the lich + 6.

    Treasure

    Same as the lich.

    Alignment

    Any evil.

    Advancement

    By character class.

    Demilich Characters

    The process of becoming a demilich can be undertaken only by a lich acting of its own free will. The demilich 
    retains all class abilities it had as a lich.

    Creating Soul Gems

    Liches have phylacteries that allow them to reappear 1d10 days after their apparent death, as do demiliches. 
    Demiliches also have eight soul gems, each of which acts like a phylactery in its own right. If all the soul 
    gems, as well as the demilich’s phylactery, are not destroyed after a demilich is downed, the demilich 
    reappears 1d10 days after its apparent death. The soul gems also allow the demilich to use its most 
    devastating ability, trap the soul (see above). Each demilich must make its own soul gems, which requires 
    the Craft Wondrous Item feat. The lich must be a sorcerer, wizard, or cleric of at least 21st level. 
    Each soul gem costs 120,000 gp and 4,800 XP to create and has a caster level equal to that of its creator 
    at the time of creation. Soul gems appear as egg-shaped gems of wondrous quality. They are always 
    incorporated directly into the concentrated form of the demilich. 

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    string sString = "Demi-lich template: ";
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    if(!GetHasTemplate(TEMPLATE_LICH))
    {
        SendMessageToPC(oPC, PRC_TEXT_RED+sString+"You need to gain Lich template first!");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
    {
        SendMessageToPC(oPC, PRC_TEXT_RED+sString+"Not evil");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    int nArcCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_ARCANE, oPC, TRUE);
    int nDivCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE, oPC, TRUE);
    if(nArcCasterLevel < 21 && nDivCasterLevel < 21)
    {
        SendMessageToPC(oPC, PRC_TEXT_RED+sString+"Arcane Caster Level = "+IntToString(nArcCasterLevel));
        SendMessageToPC(oPC, PRC_TEXT_RED+sString+"Divine Caster Level = "+IntToString(nDivCasterLevel));
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}