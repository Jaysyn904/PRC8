/*:://////////////////////////////////////////////
//:: Name Spell Visual effect Constants
//:: FileName SMP_INC_VISUALS
//:://////////////////////////////////////////////
    This is the visuals missing from Bioware's constants list, and new ones,
    from visualeffects.2da file.

    Oh, and now includes the spells.2da visuals, especially projectiles.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/


/*  First: Projectiles and spells.2da entries
--------------------------------------------------------------------------------

    Ok, basically, this is a list of all projectiles, effects, etc. by Bioware:

    Bioware only:
    ConjAnim (Where the caster puts his hands before impact script)
    hand - Hands are out normally, waving around
    head - Hands are up in the air waving around
    **** - Should act like hand

    CastAnim (Where the caster puts his hands after impact script)
    area -
    touch - One hand outstretched, touching something
    self -
    out - Both hands outwards, like Magic Missile
    up - Both hands upwards, for mainly divine calling spells/call lightning
    attack - Attack with the currently equipped weapon.
    creature - For "Suck Brain", the Mindflayer thing, it attacks/attaches the creature.

    **** - Should act as out.

    SS = Suitable sound.

    Most of these with 01 next to them go up to 03, or should do.

    CONJURATION (BEFORE impact script):
    ------------
    ConjHeadVisual (On the head/above the head of the caster)
    ------
    (Most use "up" and "head" as the casting and conjuring animations)
    vco_mehedelec01 - Electricity above head (SS: sco_mehedelec01)
    vco_mehanelec02 - Like above. Ethereal Visage.
    vco_mehanelec03 - Like above, Premonition
    vco_mehanheal02 - Healing (Mass Heal)
    vco_mehanheal03 - Healing, woo. (Heal, critical)
    vco_mehedodd01 - Doom
    vco_mehanodd02 - Gate
    vco_mehanodd03 - Summon Monster IX (9)
    vco_mehansonc02 - Energy drain (?!) Power word kill
    vco_mehedholy01 - Hammer of the Gods (and healing ones)
    vco_mehanholy02 - Turn Undead!
    vco_mehanholy03 - Divine Power.

    vco_smhannatr01 - Grease (Nature stuff)
    vco_smhanmind01 - Invisibility sphere/Mind blank/Prot Spells.

    vco_mehanmind02 - Time Stop, true seeing.
    vco_mehanevil03 - Meteor Swarm, Destruction.
    vco_mehedevil01 - Unholy Aura.

    vco_swar3blue - Cold coneness.
    vco_mehancold03 - Ice Storm.
    vco_mehanfire01 - Energy Buffer

    vco_mehedodd01 - Odd, for Battletide.

    vco_smhannatr01 - For Vice Mine impeed movement.


    ------
    ConjHandVisual (On/infront of the hands of the caster)
    ------
    (Most use "hand" and "area, touch, self, out" as the casting and conjuring animations)

    ME ones...

    vco_mebalacid01 - Acid hands (Green). (SS: sco_mebalacid01)
    vco_mehancold03 - Cold hands (Blue) (SS: vco_mehancold03) (Note: Magic missile)
    vco_mebalelec01 - Electric 1 (Blue/White) hands. (SS: sco_mebalelec01)
    vco_mebalelec02 - Electric 2 (Blue/White) hands. (SS: sco_mebalelec02)
    vco_mehanevil01 - Evil 1 (Negative Red) hands. (SS: sco_mehanevil01)
    vco_mehanevil02 - Evil 2 (Negative Red) hands, used along with GrndVisual vco_lgrinevil01. Same sound as above.
    vco_mehanevil03 - Evil 3 (Negative Red) hands. (SS: sco_mehanevil03)
    vco_mebalfire01 - Fire 1. (Red flames) hands, (SS: sco_mebalfire01) (No 02 version)
    vco_mehanfire03 - Fire 3  Bigger. (Red flame) hands, (SS: sco_mehanfire03)
    vco_mehanodd01  - Odd hands 1 (Bulls_Strength) (SS: sco_mehanodd01
    vco_mehanodd02  - Odd hands 2 (Blindness/Deafness) (SS: sco_mehanodd02)
    vco_mehanodd03  - Odd hands 3 (Summon Monster IV) (SS: sco_mehanodd03)
    vco_mebalsonc01 - Sonic (White stuff) hands (SS: sco_mebalsonc01)


    SM ones...

    vco_smbalfire01 - Fire 1. (Red flames) hands, (SS: sco_mebalfire01) (No 02 version)
    vco_smhanfire03 - Fire 3  Bigger. (Red flame) hands, (SS: sco_mehanfire03)
    vco_smhanholy1  - Holy (Yellow) hands. (SS: sco_mehanholy01)
    vco_smhanheal01 - Heal 1 (Lesser healing) (Blue/White) hands (SS: sco_mehanheal01)
    There is no 02 version, but there is a sound for it: (SS: sco_mehanheal02)
    vco_smhanheal03 - Heal 3 (Better healing) (Blue/White) hands (SS: sco_mehanheal03)
    vco_smhanmind01 - Mind 1 (Purply) hands. (SS: sco_mehanmind01) (Charm, mind spells)
    vco_smhanmind01 - Mind 2 (Purply) hands. (SS: sco_mehanmind02) ( " " )
    vco_smhannatr01 - Nature 1 (Green/Brown) hands (SS: sco_mehannatr01)
    vco_smhannatr02 - Nature 2 (Green/Brown) hands (SS: sco_mehannatr02)





    ------
    ConjGrndVisual (On the ground around the caster)
    ------
    (Can be used with any animations, its on the ground duh!)


    CASTING (AFTER impact script):
    ------------
    CastHeadVisual (On the head/above the head of the caster)
    ------


    ------
    CastHandVisual (On/infront of the hands of the caster)
    ------


    ------
    CastGrndVisual (On the ground around the caster)
    ------


    Projectiles: From the casters hands to the location/target.
    ------
    ProjModel    -  ProjType  - ProjSpwnPoint -  ProjSound  - ProjOrientation
    ------
                 -            -               -             -


    ------


    And these are required ones/ones done by the spellmans team:
    ------

--------------------------------------------------------------------------------
    Second: Sounds: List of sounds from the spells.2da, at the moment.

    Odd ones:
    spr_beholdbeam - Maybe a casting sound, but very long, and unused. Not a VFX either.


    ConjSoundVFX (Sound when conjuring the spell - before impact script)
    ------
    A-Z
    Note: Should break a few of these rules and use any for any spell/visual, if
          suitable.

    Odd one for create dead
    sco_grndskul - "Ground" skulls for the spell visual, Create Dead/Greater undead

    "large" versions? Not many spells use these, mainly only one per sound.
    sco_lgrinelec01 - Electrical, different to above (Globe of Invunrability)
    sco_lgrinevil01 - Evil summoning (Finger of Death, Energy Drain etc)
    sco_lgrinfire01 - Firey (Elemental Swarm)
    sco_lgrinheal01 - Healing (Mass Heal, Heal)
    sco_lgrinholy01 - Holy (Raise Dead)
    sco_lgrinmind01 - Mind affecting (Mass Charm)
    sco_lgrinodd01  - Odd - more summoning type of thing (Mass Blindness/Deafness)

    (Seem to be mainly large "Ground" spells, and as above, one per sound?)
    sco_lgsprelec01 - Electrical (Invisibility Purge)
    sco_lgsprevil01 - Evil (Cloudkill)
    sco_lgsprfire01 - Fire (Incendiary cloud)
    sco_lgsprholy01 - Holy (Ressurection)
    sco_lgsprmind01 - Mind (Dominate Monster)
    sco_lgsprnatr01 - Nature (Storm of Vengance)
    sco_lgsprodd01  - Odd (Greater Planar Binding)

    (Seems to be large "Up" versions, and as above, one per sound?)
    sco_lgupelec01 - Electircal (Mordenkainens Sword, Black Blade)
    sco_lgupevil01 - Evil (Gate)
    sco_lgupfire01 - Fire (Meteor Swarm)
    sco_lgupholy01 - Holy (Greater Restoration, Undeath to Death)
    sco_lgupmind01 - Mind (Ethereal Visage, Mordenkainen's Disjunction)
    sco_lgupnatr01 - Nature (Natures balance, Sunbeam)
    sco_lgupnatr01 - Nature (Natures balance, Sunbeam)
    sco_lgupsonc01 - Sonic (NO SPELLS USE THIS!)

    - Usually is an AOE spell of some kind.
    sco_mebalacid01 - Acidic Sound for conjuring. (Acid Fog)
    sco_mebalelec01 - Electric sound for conjuring. (Hold animal)
    sco_mebalfire01 - Firery sound for conjuring. (Delayed Fireball Blast)
    sco_mebalodd01  - "Odd" sound for conjuring. (Lesser Planar Binding)
    sco_mebalsonc01 - Sonic sound for conjuring. (Glymph of Warding)

    - Usually used with "ConjGrndVisual" stated.
    sco_megrdevil01 - "Evil/Devil" sound for conjuring. (Evards Black Tentacles)
    sco_megrdfire01 - Fire sound for conjuring. (Wall of Fire)
    sco_megrdholy01 - Holy sound (Word of Faith)
    sco_megrdmind01 - Mind sound (Greater Dispelling)
    sco_megrdnatr01 - Nature sound (Ultravision, Energy Buffer..although not appropriate always)
    sco_megrdodd01  - "odd" sound. (Bane, Tensers Transformation, Summon Monster...)

    - Usually used with a "ConjHandVisual" stated.
    sco_mehanacid03 - Acidic conjuring sound (Acid Arrow)
    sco_mehancold03 - Cold conjuring sound (it is icy) (Magic Missile?!, Ice storm)
    sco_mehanelec01 - Electrical. Longest length, and impact "Buzz"
    sco_mehanelec02 - Electrical. Faster version of above (Haste)
    sco_mehanelec03 - Electrical. Really buzzy. (Ball lightning, Minor Globe)
    sco_mehanevil01 - Evil/Negative, lowest power sound (Negative energy ray)
    sco_mehanevil02 - Evil/Negative, more odd power sound  (Healing sting, Vampiric Touch)
    sco_mehanevil03 - Evil/Negative, strongest power sound (Inflict Wounds)
    sco_mehanfire01 - Fire (Flame Lash, Flame Arrow)
    sco_mehanfire03 - Fire (Fireball)
    sco_mehanheal02 - Healing (Not used, should be used for lesser healing spells, they use 01!)
    sco_mehanheal03 - Healing (Cure Critical Wounds, Serious Wounds)
    sco_mehanholy01 - Holy, Sorta the lowest (Bless)
    sco_mehanholy02 - Holy, Sorta the medium (Prayer, Turn Undead)
    sco_mehanholy03 - Holy, Sorta the best (Searing Light, Restoration)
    sco_mehanmind01 - Mind Affecting, Sorta the lowest (Mind Blank, Lesser, Lesser Dispel, Death Ward)
    sco_mehanmind02 - Mind Affecting, Sorta the medium (Confusion, Charm Monster)
    sco_mehanmind03 - Mind Affecting, Sorta the highest (Prismatic Spray, thats it)
    sco_mehannatr01 - "Nature" sound, sorta lowest (Druidic spells, Freedom of movement, Barkskin)
    sco_mehannatr02 - "Nature" sound, sorta medium (Endure Elements, Contagion)
    sco_mehannatr03 - "Nature" sound, sorta high (Awaken, Polymorph)
    sco_mehanodd01  - Odd sound, sorta odd (Owls Insight, Foxs Cunning, some Summon Creatures, Bless weapon)
    sco_mehanodd02  - Odd sound, sorta odd (Sphere Of Chaos, Enervation, Blindness/Deafness)
    sco_mehanodd03  - Odd sound, sorta odd (Only Summon Creature IV!)
    sco_mehalsonc01 - Sonic sound, kinda windy. (NO SPELLS USE THIS! See below)
        NOTE: A Spelling Mistake, making it "sco_meBalsonc01" means these spells
          dont use an effect: (Animate Dead, Glymph of Warding)
    sco_mehalsonc02 - Sonic sound, kinda adds some buzz. (NO SPELLS USE THIS!)
    sco_mehalsonc03 - Sonic sound, kinda fast and ghostly. (NO SPELLS USE THIS!)

    These are for use above the head, and usually a little longer lasting.
    sco_mehedelec01 - Electrical. (Call Lightning, nothing else)
    sco_mehedevil01 - Evil/Negative. (NO SPELLS USE THIS!)
    sco_mehedholy01 - Holy. (Hammer of the Gods, Sunburst)
    sco_mehedodd01  - Odd. (Doom, Battletide)
    sco_mehedsonc01 - Sonic. (Clairaudience and Clairvoyance only)

    These have no "me" or "hed" or "han" or anything, must be used for cirtain
    spells. Stil conjuration
    sco_positive - Long, positive kinda sound, dingling... (NO SPELLS USE THIS!)
    sco_swar3blue - Kinda cold. Cone of Cold/Bombardment/Earthquake Conjuration VFX
    sco_wraith - Evilish, Phantasmal Killer only.

    ------
    ConjSoundMale (Male voice for saying spell words)
    ConjSoundFemale (Female voice for saying spell words)
    ------
    (NOTE: The female version just replaces the "m" at the end with "f")
    vs_chant_conj_hm - Conjuration Spell School.
    vs_chant_ench_lm

    ------
    CastSound (Sound when casting the spell - after impact script, eg: Cones)
    ------
    These are all Cast sounds, and thusly, are sometimes longer (for cones
    normally).
    sar_conecold - Cold blast. Cone (of) Cold.
    sar_conedisea - Disease flies, Cone of Disease.
    sar_conefire - Fire blast, Cone of Fire, Burning Hands, Hellhound Fire Breath.
    sar_conepois - Poision blast, Cone of Poison
    sar_conepris - Prismatic Spray blast, and Prismatic Dragon Breath (same VFX)
    sar_conespar - Color Spray blast, and also Gem Spray.
    sar_dragcold - Dragon Breath, Cold. It should be "sca" but seems to be used as "scr"
    sca_coneacid01 - Acid Blast. Cone of Acid. Mestils Acid Breath
    sca_conefire - EXACTLY the same as "sar_conefire".
    sca_conesonc01 - Sonic Blast. Cone of Sonic.
    sca_dragacid - Dragon Breath, Acid
    sca_dragcold - Dragon Breath, Cold
    sca_dragelec - Dragon Breath, Electricity
    sca_dragfire - Dragon Breath, Fire
    sca_draggas  - Dragon Breath, Gas
    sca_dragmind - Dragon Breath, Mind (Sleep/Fear)
    sca_dragodd  - Dragon Breath, Odd (Slow, Weaken)
    sca_outholy01 - Holy, Out (up?) (Dismissal, Remove Disease, Banishment)
    sca_outmind01 - Mind version, (NO SPELL USES THIS!)
    sca_outnatr01 - Nature Version, (Spike Growth, Battletide, Butterfly Spray, Entangle)
    sca_outneg    - Negative Version, (Summon Shadow, Energy Drain, etc)
    sca_outsonic  - Sonic version. (Dispel Magic, Magic Missile (and storms), Ball Lightning)

    Oddly, under sco_ (conjuration sounds) there are the gazes, used as casting
    sounds!
    sco_gazeevil - Evil gaze (Death, Destroy Chaos/Good/Evil/Law)
    sco_gazemind - Mind gaze (Charm/Confusion/Daze/Dominate/Fear/Stunned)
    sco_gazeodd  - Odd gaze (Doom/Paralysis)

    Cessate effects (can be still used, I guess)
    sce_negative - Negative Cessate
    sce_neutral  - Neutral Cessate
    sce_positive - Positive Cessate

--------------------------------------------------------------------------------
*/


// Second, missing bioware ones (not sure they work, but they will be here)
// which may have been updated and forgotten or never added to the constants
// list.

// The constants are all actually prefixed SMP_, but these below are Bioware
// ones without constants!

// Scene constants are permanent (or moving part, of course) tiles, such as
// water, towers and so on...
const int SMP_SCENE_WEIRD                   = 323;
const int SMP_SCENE_TOWER                   = 347;
const int SMP_SCENE_TEMPLE                  = 348;
const int SMP_SCENE_LAVA                    = 349;
const int SMP_SCENE_LAVA_2                  = 350; // Note: this and 349 are both SCENE_LAVA in the 2da.
const int SMP_SCENE_WATER                   = 401;
const int SMP_SCENE_GRASS                   = 402;
const int SMP_SCENE_FORMIAN1                = 404;
const int SMP_SCENE_FORMIAN2                = 405;
const int SMP_SCENE_PITTRAP                 = 406;
const int SMP_SCENE_ICE                     = 426;
const int SMP_SCENE_MFPillar                = 427;
const int SMP_SCENE_MFWaterfall             = 428;
const int SMP_SCENE_MFGroundCover           = 429;
const int SMP_SCENE_MFGroundCover_2         = 430;// This was the same name as 429. Made _2.
const int SMP_SCENE_MF6                     = 431;
const int SMP_SCENE_MF7                     = 432;
const int SMP_SCENE_MF8                     = 433;
const int SMP_SCENE_MF9                     = 434;
const int SMP_SCENE_MF10                    = 435;
const int SMP_SCENE_MF11                    = 436;
const int SMP_SCENE_MF12                    = 437;
const int SMP_SCENE_MF13                    = 438;
const int SMP_SCENE_MF14                    = 438;
const int SMP_SCENE_MF15                    = 440;
const int SMP_SCENE_MF16                    = 441;
const int SMP_SCENE_ICE_CLEAR               = 442;
const int SMP_SCENE_EVIL_CASTLE_WALL        = 443;
const int SMP_SCENE_BUILDING                = 449;
const int SMP_SCENE_BURNED_RUBBLE           = 450;
const int SMP_SCENE_BURNING_HALF_HOUSE      = 451;
const int SMP_SCENE_RUINED_ARCH             = 452;
const int SMP_SCENE_SOLID_ARCH              = 453;
const int SMP_SCENE_BURNED_RUBBLE_2         = 454;
const int SMP_SCENE_MARKET_1                = 455;
const int SMP_SCENE_MARKET_2                = 456;
const int SMP_SCENE_GAZEBO                  = 457;
const int SMP_SCENE_WAGON                   = 458;
// These were mixed up - SCENE_SEWER_WATER was referenced under VFX_IMP_PULSE_HOLY_SILENT :-P
const int SMP_SCENE_SEWER_WATER             = 461;
const int SMP_SCENE_BLACK_TILE              = 506;

// These 6 mainly used in Shadows of Ultrentide (city collapsing, winds, city rumbling
// and so on)
const int SMP_VFX_IMP_LEAF                  = 132;
const int SMP_VFX_IMP_CLOUD                 = 133;
const int SMP_VFX_IMP_WIND                  = 134;
const int SMP_VFX_IMP_ROCKEXPLODE           = 135;
const int SMP_VFX_IMP_ROCKEXPLODE2          = 136;
const int SMP_VFX_IMP_ROCKSUP               = 137;

// Some unique ones added for HotU, but unused as so they are added here.
const int SMP_VFX_FNF_SPELL_FAIL_HEAD       = 292;
const int SMP_VFX_FNF_SPELL_FAIL_HAND       = 293;
const int SMP_VFX_FNF_HIGHLIGHT_FLASH_WHITE = 294;
const int SMP_VFX_DUR_GHOSTLY_PULSE_QUICK   = 295;
const int SMP_VFX_COM_BLOOD_REG_WIMPY       = 296;
const int SMP_VFX_COM_BLOOD_LRG_WIMPY       = 297;
const int SMP_VFX_COM_BLOOD_CRT_WIMPY       = 298;
const int SMP_VFX_COM_BLOOD_REG_WIMPG       = 299;
const int SMP_VFX_COM_BLOOD_LRG_WIMPG       = 300;
const int SMP_VFX_COM_BLOOD_CRT_WIMPG       = 301;
const int SMP_VFX_IMP_DESTRUCTION_LOW       = 302;

// Arrows and darts are normally from the traps
const int SMP_NORMAL_ARROW                  = 357;
const int SMP_NORMAL_DART                   = 359;

// Extra "normal" visuals, unique, new, or just without sounds. These
// are in order of what type they are.
const int SMP_VFX_BEAM_FLAME                = 444;
const int SMP_VFX_BEAM_DISINTEGRATE         = 447;

const int SMP_VFX_COM_BLOOD_CRT_RED_HEAD    = 491;
const int SMP_VFX_COM_BLOOD_CRT_GREEN_HEAD  = 492;
const int SMP_VFX_COM_BLOOD_CRT_YELLOW_HEAD = 493;

const int SMP_VFX_CONJ_MIND                 = 466;
const int SMP_VFX_CONJ_FIRE                 = 467;

const int SMP_VFX_DUR_BARD_SONG_EVIL        = 507;
const int SMP_VFX_DUR_CONECOLD_HEAD         = 490;
const int SMP_VFX_DUR_BARD_SONG_SILENT      = 468;
const int SMP_VFX_DUR_PROT_ACIDSHIELD       = 448;

const int SMP_VFX_FNF_DRAGBREATHGROUND      = 494;
const int SMP_VFX_FNF_HELLBALL              = 464;
const int SMP_VFX_FNF_SCREEN_SHAKE2         = 356;
const int SMP_VFX_FNF_TELEPORT_IN           = 471;
const int SMP_VFX_FNF_TELEPORT_OUT          = 472;

const int SMP_VFX_IMP_PULSE_HOLY_SILENT_CORRECT = 462;// It IS 462, not 461! nwscript.nss has this as 461
const int SMP_VFX_IMP_PULSE_BOMB            = 469;
const int SMP_VFX_IMP_SILENCE_NO_SOUND      = 470;

// A placable well! And other placables as VFX's
const int SMP_VFX_DUR_WELL                  = 358;
const int SMP_VFX_DUR_UNSUPPORTED_CAGE      = 508;
const int SMP_VFX_DUR_UNSUPPORTED_ANIMAL_CAGE = 509;
const int SMP_VFX_DUR_UNSUPPORTED_FLAME_L   = 510;


// Visual effect constants for SMP

// NEW ONES - SMP_
const int SMP_VFX_FNF_AWAKEN                = 761;
const int SMP_VFX_FNF_CHAOS_HAMMER          = 762;
const int SMP_VFX_IMP_DIMENSION_DOOR_DISS   = 777;
const int SMP_VFX_IMP_DIMENSION_DOOR_APPR   = 776;
const int SMP_VFX_IMP_DISINTEGRATION        = 780;
const int SMP_VFX_FNF_FREEZING_SPHERE       = 763;
const int SMP_VFX_FNF_GLITTERDUST           = 783;
const int SMP_VFX_FNF_IMPRISONMENT          = 785;
const int SMP_VFX_IMP_INSANITY              = 784;
const int SMP_VFX_FNF_MAZE                  = 764;
const int SMP_VFX_FNF_PWBLIND               = 752;
const int SMP_VFX_DUR_PROTECTION_ARROWS     = 768;
const int SMP_VFX_DUR_PROTECTION_ENERGY     = 786;
const int SMP_VFX_IMP_SHOCKING_GRASP        = 760;

// Not used
const int SMP_VFX_DUR_ELEMENTAL_SHIELD_WARM = 147;// Default VFX_DUR_ELEMENTAL_SHIELD
const int SMP_VFX_DUR_ELEMENTAL_SHIELD_COOL = 147;// New one

const int SMP_VFX_DUR_PROTECTION_FROM_SPELLS= 422;// VFX_DUR_GLOW_WHITE

const int SMP_VFX_IMP_INFLICTING_S = 1;
const int SMP_VFX_IMP_INFLICTING_M = 1;
const int SMP_VFX_IMP_INFLICTING_L = 1;
const int SMP_VFX_IMP_INFLICTING_G = 1;


const int SMP_VFX_FNF_GAS_EXPLOSION_MIST = 1; // Like Acid fog blast of similar name

const int SMP_VFX_FNF_QUENCH_WATER  = 1;
const int SMP_VFX_IMP_QUENCH_IMPACT = 1;

const int SMP_VFX_FNF_METEOR_SWARM = 1; // Meteor Swarm big blast effect
const int SMP_VFX_IMP_FLAME_M_SILENT = 1;// Silent Flame (Medium) for Meteor Swarm

const int SMP_VFX_DUR_FLOATING_DISK = 1;// Floating Disk duration. A floating disk! (For null human)

const int SMP_VFX_DUR_SHIELD_OF_FAITH = 1; // Shield of Faith duration. Shimmering Shield.

const int SMP_VFX_DUR_SHIELD_OTHER = 1; // Only for target of the shield other. A shield?

const int SMP_VFX_FNF_ORDERS_WRATH = 1; // Like Chaos Hammer, special VFX.
const int SMP_VFX_FNF_HOLY_SMITE = 1;// Like chaos hammer, special VFX.

const int SMP_VFX_FNF_BLASPHEMY = 1; // AOE visual for Blashpemy (Evil). 13.33M radius.
const int SMP_VFX_FNF_DICTUM = 1;// AOE visual for Dictum (Lawful). 13.33M radius.
const int SMP_VFX_FNF_HOLY_WORD = 1;// AOE for Holy Word. (Good). 13.33M radius.
const int SMP_VFX_FNF_WORD_OF_CHAOS = 1;// AOE for Word of Chaos (Chaotic). 13.33M radius.

const int SMP_VFX_DUR_ENTROPIC_SHIELD = 1;// Targeted. A magical field glowing with a chaotic blast of multicolored hues.

const int SMP_VFX_FNF_FAERIE_FIRE = 1; // AOE visual for Faerie Fire. Might not need..

const int SMP_VFX_DUR_DISPEL_CHAOS = 1;// constant, blue, lawful energy,
const int SMP_VFX_DUR_DISPEL_EVIL = 1;// Shimmering, white, holy energy surrounds you.Shimmering, white, holy energy surrounds you.
const int SMP_VFX_DUR_DISPEL_GOOD = 1;// dark, wavering, unholy energy,
const int SMP_VFX_DUR_DISPEL_LAW = 1;// flickering, yellow, chaotic energy


const int SMP_VFX_FNF_FIRESTORM_15 = 1; // Biggest (Cube) of Firestorm.
const int SMP_VFX_FNF_FIRESTORM_12 = 1; // Medium (Cube) of Firestorm.
const int SMP_VFX_FNF_FIRESTORM_09 = 1; // Smallest (Cube) of Firestorm.

const int SMP_VFX_FNF_FORBIDDANCE = 1;// AOE visual - the AOE is a 60M cube.

const int SMP_VFX_FNF_FORCECAGE = 1;// AOE visual impact for the forcecage.

const int SMP_VFX_DUR_TEMPORAL_STASIS = 0;// Duration effect for Temporal Stasis. Nothing specfic.

const int SMP_VFX_IMP_HIDEOUS_LAUGHTER = 1;// Impact visual - a joke sound? Some sparks?

const int SMP_VFX_IMP_IRRESISTIBLE_DANCE = 1;// Impact for Dancing spell, needs a nice sound.

const int SMP_VFX_IMP_BALEFUL_POLYMORPH = 1;// Impact for Baleful polymorph.

const int SMP_VFX_DUR_BLACK_TENTACLE = 1;// Big black, constricting, tentacle.


const int SMP_VFX_FNF_EARTHQUAKE_INSIDE_NATURAL = 1;// Inside effect of earthquake - collapsing roof.
const int SMP_VFX_FNF_EARTHQUAKE_INSIDE_NOT_NATURAL = 1;// Inside effect of earthquake - no collapsing.
const int SMP_VFX_FNF_EARTHQUAKE_OUTSIDE = 1;// Outside earthquake - no roof, more ground.
const int SMP_VFX_IMP_EARTHQUAKE_FISSURE = 1;// Fissure for outside earthquake effect


const int SMP_VFX_FNF_CHILL_METAL = 1;// AOE burst for Chill metal. 10M radius.
const int SMP_VFX_FNF_HEAT_METAL = 1;// AOE burst for heat metal, like chill metal, but, well, hotter.

const int SMP_VFX_DUR_PROTECTION_LAW_MAJOR = 1;// We have what we are protected by. So this protects against chaotic spells. *Shield of Law*
const int SMP_VFX_DUR_PROTECTION_CHAOS_MAJOR = 1;// We have what we are protected by. So this protects against lawful spells. *Cloak of Chaos*
const int SMP_VFX_DUR_PROTECTION_LAW_MINOR = 1;// Like Protection from Evil, but white and lawful (We are protected BY law)
const int SMP_VFX_DUR_PROTECTION_CHAOS_MINOR = 1;// Like Protection from Evil, but pink and chaotic (We are protected BY chaos)

const int SMP_VFX_IMP_ERASE = 1;// Impact for erase - even if it didn't erase anything.


const int SMP_VFX_IMP_MAGIC_FANG = 1;// Magic fang impact VFX. Natural weapon +1 enchantment.
const int SMP_VFX_IMP_MAGIC_FANG_GREATER = 1;// Magic fang Greater impact VFX. Natural weapon +1 enchantment.

const int SMP_VFX_IMP_MAGIC_STONE = 1;// Impact for Magic Stone
const int SMP_VFX_IMP_MAGIC_VESTMENT = 1;// Impact for Magic Vestment, AC increase.
const int SMP_VFX_IMP_MAGIC_WEAPON = 1;// Impact for Magic Weapon.
const int SMP_VFX_IMP_MAGIC_WEAPON_GREATER = 1;// Impact for Greater Magic Weapon.

const int SMP_VFX_IMP_MARK_OF_JUSTICE = 1;// Mark of justice impact
const int SMP_VFX_IMP_MARK_OF_JUSTICE_CURSE = 1;// Mark of justice impact - when they have the curse finally applied.

const int SMP_VFX_DUR_IRONSKIN = 1;// Reskinned stoneskin. This is iron, however.

const int SMP_VFX_IMP_MODIFY_MEMORY = 1;// Modify Memory impact if it suceeds.

const int SMP_VFX_IMP_MOMENT_OF_PRESCIENCE_APPLY = 1;// When we cast the spell, this is the impact.
const int SMP_VFX_IMP_MOMENT_OF_PRESCIENCE_USE = 1;// When we use the +25 to a bonus save or AC, this is the impact.

const int SMP_VFX_DUR_PHASE_DOOR = 1;// The actual phased door. Shimmering passage..
const int SMP_VFX_FNF_PYROTECHNICS = 1;// Fireworks, over the target location.

const int SMP_VFX_FNF_SCINTILLATING_PATTERN = 193;// 10M radius burst of pretty colours. Currently LOS normal 30ft

const int SMP_VFX_IMP_WARP_WOOD_WARP = 1;// Warped a weapon of the target
const int SMP_VFX_IMP_WARP_WOOD_UNWARP = 1;// Unwarped a previously warped weapon


const int SMP_VFX_FNF_LOS_HOLY_40 = 1;// 40ft (13.33M) version of LOS_HOLY_10
const int SMP_VFX_FNF_LOS_HOLY_50 = 1;// 50ft (15M) version of LOS_HOLY_10
const int SMP_VFX_FNF_LOS_NORMAL_40 = 1;// 40ft (13.33M) version of LOS_NORMAL_10
const int SMP_VFX_FNF_LOS_NORMAL_50 = 1;// 50ft (15M) version of LOS_NORMAL_10
const int SMP_VFX_FNF_LOS_EVIL_40 = 1;// 40ft (13.33M) version of LOS_EVIL_10
const int SMP_VFX_FNF_LOS_EVIL_50 = 1;// 50ft (15M) version of LOS_EVIL_10

const int SMP_VFX_DUR_RESILIENT_SPHERE = 1;// Resiliant sphere. Needs to enclose creature. "A globe of shimmering force encloses a creature".
const int SMP_VFX_DUR_TELEKINETIC_SPHERE = 1;// Telekinetic sphere, similar to above, but can move the person held around the area.

const int SMP_VFX_IMP_RUSTING_GRASP = 1;// Shocking grasp like.

const int SMP_VFX_IMP_RIGHTEOUS_MIGHT = 1;// Righteous Might

const int SMP_VFX_FNF_STORM_VENGANCE_HAIL = 1;// Storm of Vengance: Hail stones, Massive VFX

// "XXX", user made up spells, for now here
const int SMP_VFX_IMP_GEM_EXPLODE = 1;// Call of Chaos, gems explode around a target.
const int SMP_VFX_IMP_ALL_WILL_BE_DUST = 1;// Impact for "All will be dust", old age.
const int SMP_VFX_FNF_CORROSIVE_BLAST = 1;// Corrosive blast - an acidic blust of acid. Like fireball kinda.
const int SMP_VFX_IMP_DRAGONBLAST = 1;// Impact for Dragonblast.
const int SMP_VFX_IMP_ADVENTURERS_LUCK = 1;// Impact for Adventurers Luck.
const int SMP_VFX_DUR_ABSOLUTE_IMMUNITY = 1;// Absolute immunity, 4 rounds duration, 60 resistance.
const int SMP_VFX_DUR_GUARDIAN_MANTLE_GREATER = 1;// Greater of below, 4 rounds duration, 40 resistance.
const int SMP_VFX_DUR_GUARDIAN_MANTLE = 1;// Guardian mantal. 4 rounds of 20 damage resistance.
const int SMP_VFX_FNF_CALL_CHAOS = 1;// 20M radius, chaotic burst. Does random effects
const int SMP_VFX_FNF_VITAE_GRENADE = 1;// 6.67M radius. "Upon impact, the vial and blood crystals detonate"


// Special: For a mishap effect of casting a too-high-level spell scroll.
const int SMP_VFX_DUR_SCROLL_MISHAP = 1;
// Speical: as above: but is aimed at the target location, and is instant.
const int SMP_VFX_FNF_SCROLL_MISHAP = 1;

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
