//::///////////////////////////////////////////////
//:: Name           (demi)Lich template script
//:: FileName       tmp_m_lich
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creating A Lich
    
    "Lich" is an acquired template that can be added to any humanoid creature (referred to hereafter as the base 
    creature), provided it can create the required phylactery.
    
    A lich has all the base creature�s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature�s type changes to undead. Do not recalculate base attack bonus, saves, or skill points. 
    Size is unchanged.
    
    Hit Dice
    
    Increase all current and future Hit Dice to d12s.
    
    Armor Class
    
    A lich has a +5 natural armor bonus or the base creature�s natural armor bonus, whichever is better.
    
    Attack
    
    A lich has a touch attack that it can use once per round. If the base creature can use weapons, the 
    lich retains this ability. A creature with natural weapons retains those natural weapons. A lich fighting 
    without weapons uses either its touch attack or its primary natural weapon (if it has any). A lich armed 
    with a weapon uses its touch or a weapon, as it desires.
    
    Full Attack
    
    A lich fighting without weapons uses either its touch attack (see above) or its natural weapons (if it has any). 
    If armed with a weapon, it usually uses the weapon as its primary attack along with a touch as a natural 
    secondary attack, provided it has a way to make that attack (either a free hand or a natural weapon that it 
    can use as a secondary attack).
    
    Damage
    
    A lich without natural weapons has a touch attack that uses negative energy to deal 1d8+5 points of damage 
    to living creatures; a Will save (DC 10 + � lich�s HD + lich�s Cha modifier) halves the damage. A lich with 
    natural weapons can use its touch attack or its natural weaponry, as it prefers. If it chooses the latter, 
    it deals 1d8+5 points of extra damage on one natural weapon attack.
    
    Special Attacks
    
    A lich retains all the base creature�s special attacks and gains those described below. Save DCs are equal 
    to 10 + � lich�s HD + lich�s Cha modifier unless otherwise noted.
    
    Fear Aura (Su)
    
    Liches are shrouded in a dreadful aura of death and evil. Creatures of less than 5 HD in a 60-foot radius 
    that look at the lich must succeed on a Will save or be affected as though by a fear spell from a sorcerer 
    of the lich�s level. A creature that successfully saves cannot be affected again by the same lich�s aura 
    for 24 hours.
    
    Paralyzing Touch (Su)
    
    Any living creature a lich hits with its touch attack must succeed on a Fortitude save or be permanently 
    paralyzed. Remove paralysis or any spell that can remove a curse can free the victim (see the bestow curse 
    spell description).
    
    The effect cannot be dispelled. Anyone paralyzed by a lich seems dead, though a DC 20 Spot check or 
    a DC 15 Heal check reveals that the victim is still alive..
    
    Spells
    
    A lich can cast any spells it could cast while alive.
    
    Special Qualities
    
    A lich retains all the base creature�s special qualities and gains those described below.
    
    Turn Resistance (Ex)
    
    A lich has +4 turn resistance.
    
    Damage Reduction (Su)
    
    A lich�s undead body is tough, giving the creature damage reduction 15/bludgeoning and magic. 
    Its natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
    
    Immunities (Ex)
    
    Liches have immunity to cold, electricity, polymorph (though they can use polymorph effects on 
    themselves), and mind-affecting attacks.
    
    Abilities
    
    Increase from the base creature as follows: Int +2, Wis +2, Cha +2. Being undead, a lich has no 
    Constitution score.
    
    Skills
    
    Liches have a +8 racial bonus on Hide, Listen, Move Silently, Search, Sense Motive, and Spot 
    checks. Otherwise same as the base creature.
    
    Organization
    
    Solitary or troupe (1 lich, plus 2-4 vampires and 5-8 vampire spawn).
    
    Challenge Rating
    
    Same as the base creature + 2.
    
    Treasure
    
    Standard coins; double goods; double items.
    
    Alignment
    
    Any evil.
    
    Advancement
    
    By character class.
    
    Level Adjustment
    
    Same as the base creature +4.
    
    Lich Characters
    
    The process of becoming a lich is unspeakably evil and can be undertaken only by a willing character. 
    A lich retains all class abilities it had in life.
    
    The Lich�s Phylactery
    
    An integral part of becoming a lich is creating a magic phylactery in which the character stores its 
    life force. As a rule, the only way to get rid of a lich for sure is to destroy its phylactery. 
    Unless its phylactery is located and destroyed, a lich reappears 1d10 days after its apparent death.
    
    Each lich must make its own phylactery, which requires the Craft Wondrous Item feat. The character 
    must be able to cast spells and have a caster level of 11th or higher. The phylactery costs 120,000 gp 
    and 4,800 XP to create and has a caster level equal to that of its creator at the time of creation.
    
    The most common form of phylactery is a sealed metal box containing strips of parchment on which magical
    phrases have been transcribed. The box is Tiny and has 40 hit points, hardness 20, and a break DC of 40.
    
    Other forms of phylacteries can exist, such as rings, amulets, or similar items. 
    
    
    
    Creating A Demilich
    
    "Demilich" is a template that can be added to any lich. It uses all the lich�s statistics and 
    special abilities except as noted here. A demilich�s form is concentrated into a single portion 
    of its original body, usually its skull. Part of the process of becoming a demilich includes the 
    incorporation of costly gems into the retained body part; see Creating Soul Gems, below.
    
    Size
    
    Medium-size and Large liches become Diminutive demiliches, Huge liches become Small demiliches, 
    Gargantuan liches become Medium-size demiliches, and Colossal liches become Large demiliches.
    
    Hit Dice
    
    As lich.
    
    Speed
    
    Change to fly 180 ft. (perfect). The lich�s supernatural fly speed, if any, is also retained.
    
    AC
    
    The demilich retains the lich�s +5 natural armor bonus and gains an insight bonus to AC equal to its Hit Dice, 
    as well as a probable size adjustment to AC.
    
    Attack
    
    The demilich gains an insight bonus equal to its Hit Dice as a bonus on its touch attacks.
    
    Damage
    
    The demilich gains an enhanced touch attack over that of its previous lich form (it now uses its entire 
    flying skull to make the touch attack), including paralyzing touch. The demilich�s touch attack uses 
    negative energy to deal 10d6+20 points of damage to living creatures (no saving throw). Liches with 
    other natural attacks lose them.
    
    Special Attacks
    
    The demilich retains all the lich�s special attacks and also gains those described below.
    
    Trap the Soul (Su)
    
    A demilich can trap the souls of up to eight living creatures per day. To use this power, it selects 
    any target it can see within 300 feet. The target is allowed a Fort saving throw (DC 10 + demilich�s 
    HD + demilich�s Cha modifier). If the target makes its saving throw, it gains four negative levels 
    (this does not count as a use of trap the soul). If the target fails its save, the soul of the target 
    is instantly drawn from its body and trapped within one of the gems incorporated into the demilich�s form. 
    The gem gleams wickedly for 24 hours, indicating the captive soul within. The soulless body collapses 
    in a mass of corruption and molders in a single round, reduced to dust. If left to its own devices, 
    the demilich slowly devours the soul over 24 hours; at the end of that time the soul is completely absorbed, 
    and the victim is forever gone. If the demilich is overcome before the soul is eaten, crushing the gem 
    releases the soul, after which time it is free to seek the afterlife or be returned to its body by the 
    use of either resurrection, true resurrection, clone, or miracle. A potential victim protected by a 
    death ward spell is not immune to trap the soul, but receives a +5 bonus on its Fortitude saving throw 
    and is effective against the level loss on a successful save.
    
    Fear Aura (Su)
    
    Demiliches are shrouded in a dreadful aura of death and evil. Creatures of less than 5 HD in a 60-foot 
    radius that look at the demilich must succeed at a Will save (DC 14 + demilich�s Cha modifier) or be 
    affected as though by fear as cast by a 21st-level caster.
    
    Paralyzing Touch (Su)
    
    Any living creature a demilich touches must succeed at a Fortitude save (DC 10 + demilich�s HD + demilich�s 
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
    level, but the save DCs are equal to 10 + the demilich�s HD + the demilich�s Charisma modifier.
    
    Special Qualities
    
    The demilich retains all the lich�s special qualities and also has those described below.
    
    Magic Immunity (Ex)
    
    Demiliches are immune to all magical and supernatural effects, except as follows. A shatter spell affects 
    a demilich as if it were a crystalline creature, but deals half the damage normally indicated. A dispel 
    evil spell deals 3d6 points of damage (Fort save for half damage). Holy smite spells affect demiliches normally.
    
    Phylactery Transference (Su)
    
    Headbands, belts, rings, cloaks, and other wearable items kept in close association with the demilich�s 
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
    gems, as well as the demilich�s phylactery, are not destroyed after a demilich is downed, the demilich 
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

#include "prc_inc_template"
#include "inc_nwnx_funcs"
void AddIPs(object oPC, object oSkin, int nIsDemi, int iTestLich, int iTestDemi);

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    itemproperty ipIP;
    int bFuncs = GetPRCSwitch(PRC_NWNX_FUNCS);
    int iTestLich = GetPersistantLocalInt(oPC, "NWNX_Template_lich");
    int iTestDemi = GetPersistantLocalInt(oPC, "NWNX_Template_demilich");

    //NOTE: this maintains both Lich and DemiLich templates
    int nIsDemi = GetHasTemplate(TEMPLATE_DEMILICH, oPC);

    int nAC = 5;
    if(nIsDemi)
        nAC += nHD;
    SetCompositeBonus(oSkin, "Template_lich_ac", nAC, ITEM_PROPERTY_AC_BONUS);

    int nTurnResist = 4;
    if(nIsDemi)
        nTurnResist = 20;
    SetCompositeBonus(oSkin, "Template_lich_turnresist", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);

    if(nIsDemi)
	{
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_15_HP);
		IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGERESIST_15);
		IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGERESIST_15);
		IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
	}
    else
	{
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP);
		IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	}

    ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    // Bugfix
    ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);    

    if(nIsDemi)
    {
        //demilich specific bonuses
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGERESIST_20);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_20);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_20);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyImmunityToSpellLevel(9);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }

    if(bFuncs)
    {
        if(!iTestLich)
        {
            SetPersistantLocalInt(oPC, "NWNX_Template_lich", 1);

            PRC_Funcs_ModAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_WISDOM, 2);
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_CHARISMA, 2);

            PRC_Funcs_ModSkill(oPC, SKILL_HIDE, 8);
            PRC_Funcs_ModSkill(oPC, SKILL_LISTEN, 8);
            PRC_Funcs_ModSkill(oPC, SKILL_PERSUADE, 8);
            PRC_Funcs_ModSkill(oPC, SKILL_MOVE_SILENTLY, 8);
            PRC_Funcs_ModSkill(oPC, SKILL_SEARCH, 8);
            PRC_Funcs_ModSkill(oPC, SKILL_SPOT, 8);

            PRC_Funcs_AddFeat(oPC, FEAT_UNDEAD_HD);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_ABILITY_DECREASE);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_CRITICAL);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_DEATH);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_DISEASE);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_MIND_SPELLS);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_PARALYSIS);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_POISON);
            PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_SNEAKATTACK);

            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_LICH_FEAR_AURA);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_LICH_PARALYZING_TOUCH);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_LICH_APPEARANCE);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_LICH_MARKER);
        }
        if(nIsDemi && !iTestDemi)
        {
            SetPersistantLocalInt(oPC, "NWNX_Template_demilich", 1);

            PRC_Funcs_ModAbilityScore(oPC, ABILITY_INTELLIGENCE, 10);
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_WISDOM, 10);
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_CHARISMA, 10);

            PRC_Funcs_ModSkill(oPC, SKILL_HIDE, 12);
            PRC_Funcs_ModSkill(oPC, SKILL_LISTEN, 12);
            PRC_Funcs_ModSkill(oPC, SKILL_PERSUADE, 12);
            PRC_Funcs_ModSkill(oPC, SKILL_MOVE_SILENTLY, 12);
            PRC_Funcs_ModSkill(oPC, SKILL_SEARCH, 12);
            PRC_Funcs_ModSkill(oPC, SKILL_SPOT, 12);

            if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_1))
                PRC_Funcs_AddFeat(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_1);
            if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_2))
                PRC_Funcs_AddFeat(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_2);
            if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_3))
                PRC_Funcs_AddFeat(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_3);
            if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_1))
                PRC_Funcs_AddFeat(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_1);
            if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_2))
                PRC_Funcs_AddFeat(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_2);
            if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_3))
                PRC_Funcs_AddFeat(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_3);

            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_ALTER_SELF);
            //PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_ASTRAL_PROJECTION);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_CREATE_GREATER_UNDEAD);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_CREATE_UNDEAD);
            //PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_DEATH_KNELL);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_ENERVATION);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_GREATER_DISPEL_MAGIC);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_HARM);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_I);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_II);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_III);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_IV);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_V);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_VI);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_VII);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_VIII);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_IX);
            //PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_TELEKINESIS);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_WEIRD);
            //PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_GREATER_PLANAR_ALLY);
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_DEMILICH_MARKER);
        }
    }
    else
        DelayCommand(0.1, AddIPs(oPC, oSkin, nIsDemi, iTestLich, iTestDemi));
}

void AddIPs(object oPC, object oSkin, int nIsDemi, int iTestLich, int iTestDemi)
{
    itemproperty ipIP;
    int nAbilityBonus;
    if(!nIsDemi && !iTestLich)
        nAbilityBonus = 2;
    else if(nIsDemi && iTestLich && !iTestDemi)
        nAbilityBonus = 10;
    else if(nIsDemi && !iTestLich && !iTestDemi)
        //since it doesnt specifically say it overlaps, assume it stacks
        nAbilityBonus = 12;
    SetCompositeBonus(oSkin, "Template_lich_int", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
    SetCompositeBonus(oSkin, "Template_lich_wis", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
    SetCompositeBonus(oSkin, "Template_lich_cha", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

    int nSkillBonus;
    if(!nIsDemi && !iTestLich)
        nSkillBonus = 8;
    else if(nIsDemi && iTestLich && !iTestDemi)
        nSkillBonus = 12;
    else if(nIsDemi && !iTestLich && !iTestDemi)
        nSkillBonus = 20;
    SetCompositeBonus(oSkin, "Template_lich_Hide",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oSkin, "Template_lich_Listen",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "Template_lich_Persuade", nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Template_lich_Silent",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    SetCompositeBonus(oSkin, "Template_lich_Search",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "Template_lich_Spot",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);

    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNDEAD_HD);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_ABILITY_DECREASE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_CRITICAL);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DEATH);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DISEASE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_MIND_SPELLS);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_PARALYSIS);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_POISON);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_SNEAKATTACK);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    if(DEBUG) DoDebug("You have feat Undead HD = "+IntToString(GetHasFeat(FEAT_UNDEAD_HD, oPC)));
	
	SetSubRace(oPC, "Undead (Augmented Humanoid)");

    if(nIsDemi && !iTestDemi)
    {
        //demilich specific bonuses
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_STILL_I);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_STILL_II);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_STILL_III);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

        if(GetHasFeat(FEAT_EPIC_AUTOMATIC_QUICKEN_3, oPC))
        {
            //aready has auto quicken III, cant be upgraded more
        }
        else if(GetHasFeat(FEAT_EPIC_AUTOMATIC_QUICKEN_2, oPC))
        {
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_III);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        }
        else if(GetHasFeat(FEAT_EPIC_AUTOMATIC_QUICKEN_1, oPC))
        {
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_II);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        }
        else
        {
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_I);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        }

        //spell-like abilities
        //at will:
            //alter self,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_ALTER_SELF);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //astral projection,

            //create greater undead,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_CREATE_GREATER_UNDEAD);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //create undead,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_CREATE_UNDEAD);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //death knell,

            //enervation,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_ENERVATION);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //greater dispel magic,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_GREATER_DISPEL_MAGIC);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //harm (usually used to heal itself),
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_HARM);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster I,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_I);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster II,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_II);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster III,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_III);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster IV,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_IV);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster V,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_V);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster VI,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_VI);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster VII,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_VII);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster VIII,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_VIII);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //summon monster IX,
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_SUMMON_CREATURE_IX);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
            //telekinesis,

            //weird;
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_WEIRD);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        //2/day: 
            //greater planar ally.
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_GREATER_PLANAR_ALLY);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    }
    if(!iTestLich && !iTestDemi)
    {
        //appearance
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_APPEARANCE);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //touch/natural attack & paralysing touch
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_PARALYZING_TOUCH);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //fear aura
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_FEAR_AURA);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //marker feat
        if(nIsDemi)
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_DEMILICH_MARKER);
        else
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_MARKER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}