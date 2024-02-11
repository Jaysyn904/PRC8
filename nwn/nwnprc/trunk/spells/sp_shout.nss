/*
    sp_shout.nss

    Shout
    Evocation [Sonic]
    Level: Brd 4, Sor/Wiz 4
    Components: V
    Casting Time: 1 standard action
    Range: 30 ft.
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: Fortitude partial or Reflex negates (object); see text
    Spell Resistance: Yes (object)
    You emit an ear-splitting yell that deafens and damages creatures in its
        path. Any creature within the area is deafened for 2d6 rounds and takes
        5d6 points of sonic damage. A successful save negates the deafness and
        reduces the damage by half. Any exposed brittle or crystalline object or
        crystalline creature takes 1d6 points of sonic damage per caster level
        (maximum 15d6). An affected creature is allowed a Fortitude save to reduce
        the damage by half, and a creature holding fragile objects can negate damage
        to them with a successful Reflex save.
    A shout spell cannot penetrate a silence spell.

    Shout, Greater
    Evocation [Sonic]
    Level: Brd 6, Sor/Wiz 8
    Components: V, S, F
    Range: 60 ft.
    Saving Throw: Fortitude partial or Reflex negates (object); see text
    This spell functions like shout, except that the cone deals 10d6 points of sonic
        damage (or 1d6 points of sonic damage per caster level, maximum 20d6, against
        exposed brittle or crystalline objects or crystalline creatures). It also causes
        creatures to be stunned for 1 round and deafened for 4d6 rounds. A creature in
        the area of the cone can negate the stunning and halve both the damage and the
        duration of the deafness with a successful Fortitude save. A creature holding
        vulnerable objects can attempt a Reflex save to negate the damage to those objects.
    Arcane Focus: A small metal or ivory horn.

    By: Flaming_Sword
    Created: Sept 9, 2006
    Modified: Sept 9, 2006

      Label                                                     Name     IconResRef          School Range VS   MetaMagic TargetType ImpactScript         Bard Cleric Druid Paladin Ranger Wiz_Sorc Innate ConjTime ConjAnim ConjHeadVisual  ConjHandVisual   ConjGrndVisual  ConjSoundVFX    ConjSoundMale    ConjSoundFemale  CastAnim CastTime CastHeadVisual  CastHandVisual CastGrndVisual  CastSound        Proj ProjModel        ProjType     ProjSpwnPoint ProjSound        ProjOrientation ImmunityType   ItemImmunity SubRadSpell1 SubRadSpell2 SubRadSpell3 SubRadSpell4 SubRadSpell5 Category Master UserType SpellDesc  UseConcentration SpontaneouslyCast AltMessage HostileSetting FeatID    Counter1 Counter2 HasProjectile
25    Cone_of_Cold                                              775      is_ConeCold         V      S     vs   0x3d      0x3E       NW_S0_ConeCold       **** ****   ****  ****    ****   5        5      1500     hand     vco_swar3blue   ****             ****            sco_swar3blue   vs_chant_evoc_hm vs_chant_evoc_hf out      1700     ****            var_conecold   ****            sar_conecold     0    ****             ****         ****          ****             path            Cold           0            ****         ****         ****         ****         ****         11       ****   1        6121       1                0                 ****       1              ****      ****     ****     1
167   Sound_Burst                                               917      is_SndBurst         V      L     vs   0x3c      0x2E       NW_S0_SndBurst       2    2      ****  ****    ****   ****     2      1500     hand     ****            vco_mehansonc01  ****            sco_mehansonc01 vs_chant_evoc_lm vs_chant_evoc_lf out      1000     ****            ****           ****            ****             1    vpr_los          accelerating hand          spr_los          path            Sonic          1            ****         ****         ****         ****         ****         11       ****   1        6260       1                0                 ****       1              ****      ****     ****     1
135   Prismatic_Spray                                           885      is_PrisSpray        V      S     vs   0x38      0x2E       NW_S0_PrisSpray      **** ****   ****  ****    ****   7        7      1500     hand     ****            vco_mehanmind03  ****            sco_mehanmind03 vs_chant_evoc_hm vs_chant_evoc_hf out      1700     ****            var_conepris   ****            sar_conepris     0    ****             homing       hand          ****             path            ****           1            ****         ****         ****         ****         ****         11       ****   1        6229       1                0                 ****       1              ****      ****     ****     1
307   BARBARIAN_RAGE                                            1062     ife_rage            V      P     s    0x00      0x09       NW_S1_BarbRage       **** ****   ****  ****    ****   ****     1      500      head     ****            ****             ****            ****            ****             ****             out      500      ****            ****           ****            ****             0    ****             ****         ****          ****             ****            ****           1            ****         ****         ****         ****         ****         16       ****   3        ****       0                0                 53207      0              293       ****     ****     0

1953  Shout                                                     16828892 is_SndBurst         V      S     v    0x1d      0x3E       sp_shout             4    ****   ****  ****    ****   4        4      1500     hand     ****            vco_smhansonc01  ****            sco_mehansonc01 vs_chant_evoc_lm vs_chant_evoc_lf out      1700     ****            vca_conesonc01 ****            sff_howlmind     0    ****             ****         ****          ****             path            Sonic          1            ****         ****         ****         ****         ****         11       ****   1        16828893   1                0                 ****       1              ****      ****     ****     1
1954  Greater_Shout                                             16828894 is_SndBurst         V      M     vs   0x3d      0x3E       sp_shout             6    ****   ****  ****    ****   8        6      1500     hand     ****            vco_mehansonc01  ****            sco_mehansonc01 vs_chant_evoc_hm vs_chant_evoc_hf out      1700     ****            vca_conesonc01 ****            sff_howlmind     0    ****             ****         ****          ****             path            Sonic          1            ****         ****         ****         ****         ****         11       ****   1        16828895   1                0                 ****       1              ****      ****     ****     1

*/

#include "prc_sp_func"
#include "prc_add_spell_dc"
void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    location lTargetLocation = PRCGetSpellTargetLocation();
    object oTarget;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fDelay;
    float fSize = FeetToMeters((nSpellID == SPELL_SHOUT_GREATER) ? 60.0 : 30.0);
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_SONIC);

    int nDC;

    int nDamageDice = (nSpellID == SPELL_SHOUT_GREATER) ? 10 : 5;
    int nDeafenedDice = (nSpellID == SPELL_SHOUT_GREATER) ? 4 : 2;
    int nDamage;
    int nDuration;

    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fSize, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));
                fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
                if(!PRCDoResistSpell(oCaster, oTarget, nCasterLevel, fDelay) && (oTarget != oCaster))
                {
                    nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                    nDamage = d6(nDamageDice);
                    nDuration = d6(nDeafenedDice);
                    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                    {
                         nDamage = 6 * nDamageDice;
                    }
                    if ((nMetaMagic & METAMAGIC_EMPOWER))
                    {
                         nDamage += (nDamage/2);
                    }
                    nDamage += SpellDamagePerDice(OBJECT_SELF, nDamageDice);
                    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget,
                                        PRCGetSaveDC(oTarget, oCaster, nSpellID),
                                        SAVING_THROW_TYPE_SONIC))
                    {
                        nDamage /= 2;
                        if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                            nDamage = 0;
                        else if(nSpellID == SPELL_SHOUT_GREATER)
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, RoundsToSeconds(nDuration/2)));
                    }
                    else
                    {
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, RoundsToSeconds(nDuration)));
                        if(nSpellID == SPELL_SHOUT_GREATER)
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0));
                    }
                    if(nDamage > 0)
                    {
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, EleDmg), oTarget));
                        PRCBonusDamage(oTarget);
                    }
                }
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fSize, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    PRCSetSchool();
}