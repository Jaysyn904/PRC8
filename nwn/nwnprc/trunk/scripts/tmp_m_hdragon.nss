//::///////////////////////////////////////////////
//:: Name           Half-Dragon template script
//:: FileName       tmp_m_hdragon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Half-Dragon

Half-dragon creatures are always more formidable than others of their kind that do not have dragon blood, and their appearance betrays their nature�scales, elongated features, reptilian eyes, and exaggerated teeth and claws. Sometimes they have wings. 

Creating A Half-Dragon

"Half-dragon" is an inherited template that can be added to any living, corporeal creature (referred to hereafter as the base creature).
A half-dragon uses all the base creature�s statistics and special abilities except as noted here.

Size and Type
The creature�s type changes to dragon. Size is unchanged. Do not recalculate base attack bonus or saves.

Hit Dice
Increase base creature�s racial HD by one die size, to a maximum of d12. Do not increase class HD.

Speed
A half-dragon that is Large or larger has wings and can fly at twice its base land speed (maximum 120 ft.) with average maneuverability. A half-dragon that is Medium or smaller does not have wings.

Armor Class
Natural armor improves by +4.

Attack
A half-dragon has two claw attacks and a bite attack, and the claws are the primary natural weapon. If the base creature can use weapons, the half-dragon retains this ability. A half-dragon fighting without weapons uses a claw when making an attack action. When it has a weapon, it usually uses the weapon instead.

Full Attack
A half-dragon fighting without weapons uses both claws and its bite when making a full attack. If armed with a weapon, it usually uses the weapon as its primary attack and its bite as a natural secondary attack. If it has a hand free, it uses a claw as an additional natural secondary attack.

Damage
Half-dragons have bite and claw attacks. If the base creature does not have these attack forms, use the damage values in the table below. Otherwise, use the values below or the base creature�s damage values, whichever are greater.

Half-Dragon DamageSize Bite Damage Claw Damage
Fine                   1           �
Diminutive             1d2         1
Tiny                   1d3         1d2
Small                  1d4         1d3
Medium                 1d6         1d4
Large                  1d8         1d6
Huge                   2d6         1d8
Gargantuan             3d6         2d6
Colossal               4d6         3d6

Special Attacks
A half-dragon retains all the special attacks of the base creature and gains a breath weapon based on the dragon variety (see table), usable once per day. A half-dragon�s breath weapon deals 6d8 points of damage. A successful Reflex save (DC 10 + 1/2 half-dragon�s racial HD + half-dragon�s Con modifier) reduces damage by half.

Half-Dragon Special Attacks:
Dragon Variety  Breath Weapon
Black           60-foot line of acid
Blue            60-foot line of lightning
Green           30-foot cone of corrosive (acid) gas
Red             30-foot cone of fire
White           30-foot cone of cold
Brass           60-foot line of fire
Bronze          60-foot line of lightning
Copper          60-foot line of acid
Gold            30-foot cone of fire
Silver          30-foot cone of cold

Special Qualities
A half-dragon has all the special qualities of the base creature, plus darkvision out to 60 feet and low-light vision. A half-dragon has immunity to sleep and paralysis effects, and an additional immunity based on its dragon variety.

Half-Dragon Immunities:
Dragon Variety Immunity
Black          Acid
Blue           Electricity
Green          Acid
Red            Fire
White          Cold
Brass          Fire
Bronze         Electricity
Copper         Acid
Gold           Fire
Silver         Cold

Abilities
Increase from the base creature as follows: Str +8, Con +2, Int +2, Cha +2.

Skills
A half-dragon gains skill points as a dragon and has skill points equal to (6 + Int modifier) � (HD + 3). Do not include Hit Dice from class levels in this calculation�the half-dragon gains dragon skill points only for its racial Hit Dice, and gains the normal amount of skill points for its class levels. Treat skills from the base creature�s list as class skills, and other skills as cross-class.

Environment
Same as either the base creature or the dragon variety.

Challenge Rating
Same as the base creature + 2 (minimum 3).

Alignment
Same as the dragon variety.

Level Adjustment
Same as base creature +3.

*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: 25/04/10
//:://////////////////////////////////////////////

#include "pnp_shft_poly"
#include "prc_inc_template"
#include "prc_inc_natweap"
#include "inc_nwnx_funcs"

//Adds total elemental immunity for the majority of dragon types.
void ElImmune(object oPC ,object oSkin ,int bResisEle ,int iType)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(iType,bResisEle),oSkin));
}

//Adds poison immunity for certain dragon types.
//also adds immunity to level drain for shadow dragons.
void PoisImmu(object oPC ,object oSkin ,int bResisEle ,int pImmune)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(pImmune),oSkin));
}

//Adds disease immunity for certain dragon types.
void DisImmu(object oPC ,object oSkin ,int bResisEle ,int dImmune)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(dImmune),oSkin));
}

//Adds specific spell immunities for certain dragon types.
void SpellImmu(object oPC ,object oSkin ,int bResisEle ,int iSpell)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(iSpell),oSkin));
}

//Adds more spell immunities for certain dragon types.
void SpellImmu2(object oPC ,object oSkin ,int bResisEle ,int iSpel2)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(iSpel2),oSkin));
}

//Adds resistance 10 to cold and fire damage.
void SmallResist(object oPC ,object oSkin ,int bResisEle ,int sResis)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,sResis),oSkin));
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,sResis),oSkin));
}

//Adds immunity 50% to sonic and fire damage.
void LargeResist(object oPC ,object oSkin ,int bResisEle ,int lResis)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,lResis),oSkin));
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SONIC,lResis),oSkin));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    itemproperty ipIP;
	
	int nNWNxEE = GetPRCSwitch(PRC_NWNXEE_ENABLED);
	int nPRCx	= GetPRCSwitch(PRC_PRCX_ENABLED);
    int bFuncs = (nNWNxEE && nPRCx);
	
    int iTest = GetPersistantLocalInt(oPC, "NWNX_Template_hdragon");
    int nSubTemplate = GetPersistantLocalInt(oPC, "HalfDragon_Template");
    int nWingType, iType, lResis, pImmune, dImmune, iSpell, iSpel2, sResis;
    int nMarker, ipMarker; //marker feats

    if(nSubTemplate == 0)
        return;

    switch(nSubTemplate)
    {
        case TEMPLATE_HDRAGON_CHROMATIC_BLACK:     ipMarker = IP_CONST_FEAT_HD_CHROMATICBLACK_MARKER;     nMarker = FEAT_HD_CHROMATICBLACK_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_BLACK;  iType = IP_CONST_DAMAGETYPE_ACID; break;
        case TEMPLATE_HDRAGON_CHROMATIC_BLUE:      ipMarker = IP_CONST_FEAT_HD_CHROMATICBLUE_MARKER;      nMarker = FEAT_HD_CHROMATICBLUE_MARKER;      nWingType = PRC_WING_TYPE_DRAGON_BLUE;   iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
        case TEMPLATE_HDRAGON_CHROMATIC_GREEN:     ipMarker = IP_CONST_FEAT_HD_CHROMATICGREEN_MARKER;     nMarker = FEAT_HD_CHROMATICGREEN_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_GREEN;  iType = IP_CONST_DAMAGETYPE_ACID; break;
        case TEMPLATE_HDRAGON_CHROMATIC_RED:       ipMarker = IP_CONST_FEAT_HD_CHROMATICRED_MARKER;       nMarker = FEAT_HD_CHROMATICRED_MARKER;                                                iType = IP_CONST_DAMAGETYPE_FIRE; break;
        case TEMPLATE_HDRAGON_CHROMATIC_WHITE:     ipMarker = IP_CONST_FEAT_HD_CHROMATICWHITE_MARKER;     nMarker = FEAT_HD_CHROMATICWHITE_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_WHITE;  iType = IP_CONST_DAMAGETYPE_COLD; break;
        case TEMPLATE_HDRAGON_GEM_AMETHYST:        ipMarker = IP_CONST_FEAT_HD_GEMAMETHYST_MARKER;        nMarker = FEAT_HD_GEMAMETHYST_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_BLUE;                                           pImmune = IP_CONST_IMMUNITYMISC_POISON; break;
        case TEMPLATE_HDRAGON_GEM_CRYSTAL:         ipMarker = IP_CONST_FEAT_HD_GEMCRYSTAL_MARKER;         nMarker = FEAT_HD_GEMCRYSTAL_MARKER;         nWingType = PRC_WING_TYPE_DRAGON_SILVER; iType = IP_CONST_DAMAGETYPE_COLD; break;
        case TEMPLATE_HDRAGON_GEM_EMERALD:         ipMarker = IP_CONST_FEAT_HD_GEMEMERALD_MARKER;         nMarker = FEAT_HD_GEMEMERALD_MARKER;         nWingType = PRC_WING_TYPE_DRAGON_GREEN;  iType = IP_CONST_DAMAGETYPE_SONIC; break;
        case TEMPLATE_HDRAGON_GEM_SAPPHIRE:        ipMarker = IP_CONST_FEAT_HD_GEMSAPPHIRE_MARKER;        nMarker = FEAT_HD_GEMSAPPHIRE_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_BLUE;   iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
        case TEMPLATE_HDRAGON_GEM_TOPAZ:           ipMarker = IP_CONST_FEAT_HD_GEMTOPAZ_MARKER;           nMarker = FEAT_HD_GEMTOPAZ_MARKER;           nWingType = PRC_WING_TYPE_DRAGON_BLUE;   iType = IP_CONST_DAMAGETYPE_COLD; break;
        case TEMPLATE_HDRAGON_LUNG_CHIANGLUNG:     ipMarker = IP_CONST_FEAT_HD_LUNGCHIANGLUNG_MARKER;     nMarker = FEAT_HD_LUNGCHIANGLUNG_MARKER;                                                                                      iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; break;
        case TEMPLATE_HDRAGON_LUNG_LILUNG:         ipMarker = IP_CONST_FEAT_HD_LUNGLILUNG_MARKER;         nMarker = FEAT_HD_LUNGLILUNG_MARKER;                                                                                          iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; break;
        case TEMPLATE_HDRAGON_LUNG_LUNGWANG:       ipMarker = IP_CONST_FEAT_HD_LUNGLUNGWANG_MARKER;       nMarker = FEAT_HD_LUNGLUNGWANG_MARKER;                                                iType = IP_CONST_DAMAGETYPE_FIRE;       iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; break;
        case TEMPLATE_HDRAGON_LUNG_PANLUNG:        ipMarker = IP_CONST_FEAT_HD_LUNGPANLUNG_MARKER;        nMarker = FEAT_HD_LUNGPANLUNG_MARKER;                                                                                         iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; break;
        case TEMPLATE_HDRAGON_LUNG_SHENLUNG:       ipMarker = IP_CONST_FEAT_HD_LUNGSHENLUNG_MARKER;       nMarker = FEAT_HD_LUNGSHENLUNG_MARKER;                                                iType = IP_CONST_DAMAGETYPE_ELECTRICAL; iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; pImmune = IP_CONST_IMMUNITYMISC_POISON; break;
        case TEMPLATE_HDRAGON_LUNG_TIENLUNG:       ipMarker = IP_CONST_FEAT_HD_LUNGTIENLUNG_MARKER;       nMarker = FEAT_HD_LUNGTIENLUNG_MARKER;                                                                                        iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; break;
        case TEMPLATE_HDRAGON_LUNG_TUNMILUNG:      ipMarker = IP_CONST_FEAT_HD_LUNGTUNMILUNG_MARKER;      nMarker = FEAT_HD_LUNGTUNMILUNG_MARKER;                                                                                       iSpell = SPELL_DROWN; iSpel2 = SPELL_MASS_DROWN; break;
        case TEMPLATE_HDRAGON_METALLIC_BRASS:      ipMarker = IP_CONST_FEAT_HD_METALLICBRASS_MARKER;      nMarker = FEAT_HD_METALLICBRASS_MARKER;      nWingType = PRC_WING_TYPE_DRAGON_BRASS;  iType = IP_CONST_DAMAGETYPE_FIRE; break;
        case TEMPLATE_HDRAGON_METALLIC_BRONZE:     ipMarker = IP_CONST_FEAT_HD_METALLICBRONZE_MARKER;     nMarker = FEAT_HD_METALLICBRONZE_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_BRONZE; iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
        case TEMPLATE_HDRAGON_METALLIC_COPPER:     ipMarker = IP_CONST_FEAT_HD_METALLICCOPPER_MARKER;     nMarker = FEAT_HD_METALLICCOPPER_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_COPPER; iType = IP_CONST_DAMAGETYPE_ACID; break;
        case TEMPLATE_HDRAGON_METALLIC_GOLD:       ipMarker = IP_CONST_FEAT_HD_METALLICGOLD_MARKER;       nMarker = FEAT_HD_METALLICGOLD_MARKER;       nWingType = PRC_WING_TYPE_DRAGON_GOLD;   iType = IP_CONST_DAMAGETYPE_FIRE; break;
        case TEMPLATE_HDRAGON_METALLIC_SILVER:     ipMarker = IP_CONST_FEAT_HD_METALLICSILVER_MARKER;     nMarker = FEAT_HD_METALLICSILVER_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_SILVER; iType = IP_CONST_DAMAGETYPE_COLD; break;
        case TEMPLATE_HDRAGON_OBSCURE_BATTLE:      ipMarker = IP_CONST_FEAT_HD_OBSCUREBATTLE_MARKER;      nMarker = FEAT_HD_OBSCUREBATTLE_MARKER;      nWingType = PRC_WING_TYPE_DRAGON_COPPER; iType = IP_CONST_DAMAGETYPE_SONIC; break;
        case TEMPLATE_HDRAGON_OBSCURE_BROWN:       ipMarker = IP_CONST_FEAT_HD_OBSCUREBROWN_MARKER;       nMarker = FEAT_HD_OBSCUREBROWN_MARKER;       nWingType = PRC_WING_TYPE_DRAGON_BRONZE; iType = IP_CONST_DAMAGETYPE_ACID; break;
        case TEMPLATE_HDRAGON_OBSCURE_CHAOS:       ipMarker = IP_CONST_FEAT_HD_OBSCURECHAOS_MARKER;       nMarker = FEAT_HD_OBSCURECHAOS_MARKER;       nWingType = PRC_WING_TYPE_DRAGON_COPPER;                                         iSpell = IP_CONST_IMMUNITYSPELL_CONFUSION; break;
        case TEMPLATE_HDRAGON_OBSCURE_DEEP:        ipMarker = IP_CONST_FEAT_HD_OBSCUREDEEP_MARKER;        nMarker = FEAT_HD_OBSCUREDEEP_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_BRONZE;                                         iSpell = IP_CONST_IMMUNITYSPELL_CHARM_PERSON_OR_ANIMAL; sResis = IP_CONST_DAMAGERESIST_10; break;
        case TEMPLATE_HDRAGON_OBSCURE_ETHEREAL:    ipMarker = IP_CONST_FEAT_HD_OBSCUREETHEREAL_MARKER;    nMarker = FEAT_HD_OBSCUREETHEREAL_MARKER;    nWingType = PRC_WING_TYPE_DRAGON_WHITE; break;
        case TEMPLATE_HDRAGON_OBSCURE_FANG:        ipMarker = IP_CONST_FEAT_HD_OBSCUREFANG_MARKER;        nMarker = FEAT_HD_OBSCUREFANG_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_COPPER; break;
        case TEMPLATE_HDRAGON_OBSCURE_HOWLING:     ipMarker = IP_CONST_FEAT_HD_OBSCUREHOWLING_MARKER;     nMarker = FEAT_HD_OBSCUREHOWLING_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_COPPER; iType = IP_CONST_DAMAGETYPE_SONIC; break;
        case TEMPLATE_HDRAGON_OBSCURE_OCEANUS:     ipMarker = IP_CONST_FEAT_HD_OBSCUREOCEANUS_MARKER;     nMarker = FEAT_HD_OBSCUREOCEANUS_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_BLUE;   iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
        case TEMPLATE_HDRAGON_OBSCURE_PYROCLASTIC: ipMarker = IP_CONST_FEAT_HD_OBSCUREPYROCLASTIC_MARKER; nMarker = FEAT_HD_OBSCUREPYROCLASTIC_MARKER;                                                                                  lResis = IP_CONST_DAMAGEIMMUNITY_50_PERCENT; break;
        case TEMPLATE_HDRAGON_OBSCURE_RADIANT:     ipMarker = IP_CONST_FEAT_HD_OBSCURERADIANT_MARKER;     nMarker = FEAT_HD_OBSCURERADIANT_MARKER;     nWingType = PRC_WING_TYPE_DRAGON_GOLD; break;
        case TEMPLATE_HDRAGON_OBSCURE_RUST:        ipMarker = IP_CONST_FEAT_HD_OBSCURERUST_MARKER;        nMarker = FEAT_HD_OBSCURERUST_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_BRONZE; break;
        case TEMPLATE_HDRAGON_OBSCURE_SHADOW:      ipMarker = IP_CONST_FEAT_HD_OBSCURESHADOW_MARKER;      nMarker = FEAT_HD_OBSCURESHADOW_MARKER;      nWingType = PRC_WING_TYPE_DRAGON_BLACK;                                          pImmune = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN; break;
        case TEMPLATE_HDRAGON_OBSCURE_SONG:        ipMarker = IP_CONST_FEAT_HD_OBSCURESONG_MARKER;        nMarker = FEAT_HD_OBSCURESONG_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_BLUE;   iType = IP_CONST_DAMAGETYPE_ELECTRICAL; pImmune = IP_CONST_IMMUNITYMISC_POISON; break;
        case TEMPLATE_HDRAGON_OBSCURE_STYX:        ipMarker = IP_CONST_FEAT_HD_OBSCURESTYX_MARKER;        nMarker = FEAT_HD_OBSCURESTYX_MARKER;        nWingType = PRC_WING_TYPE_DRAGON_GREEN;                                          pImmune = IP_CONST_IMMUNITYMISC_POISON; dImmune = IP_CONST_IMMUNITYMISC_DISEASE; break;
        case TEMPLATE_HDRAGON_OBSCURE_TARTERIAN:   ipMarker = IP_CONST_FEAT_HD_OBSCURETARTERIAN_MARKER;   nMarker = FEAT_HD_OBSCURETARTERIAN_MARKER;   nWingType = PRC_WING_TYPE_DRAGON_SILVER; break;
        default: nWingType = PRC_WING_TYPE_DRAGON_RED; break;
    }

    //wings
    DoWings(oPC, nWingType);

    if(bFuncs && !iTest)
    {
        SetPersistantLocalInt(oPC, "NWNX_Template_hdragon", 1);
        //ability mods
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_STRENGTH, 8);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_CHARISMA, 2);
        //feats
        PRC_Funcs_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_CREATURE);
        //breath weapon
        PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_HALF_DRAGON_BREATH);
        //low-light vision
        PRC_Funcs_AddFeat(oPC, FEAT_LOWLIGHTVISION);
        //darkvision
        PRC_Funcs_AddFeat(oPC, FEAT_DARKVISION);
        //draconic immunities - sleep, paralysis
        PRC_Funcs_AddFeat(oPC, FEAT_IMMUNITY_TO_SLEEP);
        PRC_Funcs_AddFeat(oPC, FEAT_DRAGON_IMMUNE_PARALYSIS);
        //marker feat
        PRC_Funcs_AddFeat(oPC, nMarker);
    }
    else if(!bFuncs && !iTest)
    {
        //ability mods
        SetCompositeBonus(oSkin, "Template_hdragon_str", 8, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
        SetCompositeBonus(oSkin, "Template_hdragon_con", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
        SetCompositeBonus(oSkin, "Template_hdragon_int", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        SetCompositeBonus(oSkin, "Template_hdragon_cha", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
        //feats
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //breath weapon
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_HDRAGON_BREATHWEAPON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //low-light vision
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //darkvision
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_DARKVISION);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //draconic immunities - sleep, paralysis
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_TO_SLEEP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_DRAGON_IMMUNE);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //marker feat
        ipIP = PRCItemPropertyBonusFeat(ipMarker);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //Race feat
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_DRAGON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);        
    }
    //naturalAC
    SetCompositeBonus(oSkin, "Template_hdragon_natAC", 4, ITEM_PROPERTY_AC_BONUS);
    //natural weapons
    int nSize = PRCGetCreatureSize(oPC);
    //bite
    string sResRef = "prc_rdd_bite_";
    sResRef += GetAffixForSize(nSize);
    AddNaturalSecondaryWeapon(oPC, sResRef);
    //claws
    sResRef = "prc_claw_1d6l_";
    sResRef += GetAffixForSize(nSize);
    AddNaturalPrimaryWeapon(oPC, sResRef, 2);

    if (iType>0)   ElImmune   (oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,iType);
    if (pImmune>0) PoisImmu   (oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,pImmune);
    if (dImmune>0) DisImmu    (oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,dImmune);
    if (iSpell>0)  SpellImmu  (oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,iSpell);
    if (iSpel2>0)  SpellImmu2 (oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,iSpel2);
    if (sResis>0)  SmallResist(oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,sResis);
    if (lResis>0)  LargeResist(oPC,oSkin,IP_CONST_DAMAGEIMMUNITY_100_PERCENT,lResis);
}