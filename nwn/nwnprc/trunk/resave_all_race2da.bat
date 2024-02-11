@echo off

SETLOCAL

echo ------------------------------------------------------------------------
echo - This script resaves 2da files. The purpose is to keep whitespace     -
echo - uniform, thus preventing lines where just whitespace changed being   -
echo - marked as changed in a later CVS commit.                             -
echo -                                                                      -
echo - If the tool you use for 2da editing does not create similar          -
echo - whitespace as prc.jar 2da utility does, please run this before       -
echo - committing.                                                          -
echo -                                                                      -
echo - All the files are assumed to be located under race2das\                  -
echo ------------------------------------------------------------------------

:start

java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_aas.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_agen.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_aqelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_arcdw.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_arch.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_asabi.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_ashrat.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_avar.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_ayuan.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_azer.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_azurin.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_baaz.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_bari.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_bhuka.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_bldlng.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_blue.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_bozak.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_bral.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_brecht.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_browni.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_bugb.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_buom.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_catfk.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_cent.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_chaond.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_chit.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_chnglg.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_crucia.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_ddwar.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_deep.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dhalf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dkin.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_doppel.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_drider.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_drom.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_drow.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dsdwar.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dself.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dsgian.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dshalf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dshe.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_duerg.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dusklg.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_dwarf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_egen.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_elan.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_extam.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_feyri.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_fgen.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_fgnome.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_firedw.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_flind.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_forelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_frost.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_frstbd.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gargun.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gdwa.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gfolk.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_ghalf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gldwar.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gloam.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gltter.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gnoll.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gobl.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_goelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gol.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gorc.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_grelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_grig.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gyank.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_gzer.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_hadzee.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_hagsp.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_half.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_hdro.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_hobgo.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_hogre.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_hybsil.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_illith.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_imask.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_irda.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_kag.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_kalash.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_kapak.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_karsit.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_kend.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_khaas.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_khogre.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_killor.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_kminot.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_kobo.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_koro.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_krinth.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_lizar.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_maen.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_marrul.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_marrus.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_minot.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_mongrl.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_mul.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_nathri.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_naztha.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_neand.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_neandr.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_neraph.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_nezu.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_nixie.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_nymph.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_ogre.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_orc.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_orog.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_pdusk.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_phgian.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_pixie.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_pteran.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_pyuan.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_raks.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_rgnome.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_rilkan.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_satyr.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_scro.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_shalf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_shara.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_shiftr.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_sidhe.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_skarn.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_skulk.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_slvrbw.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_snelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_spiker.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_spirit.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_stelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_stnchd.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_stngnm.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_sunsco.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_svelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_svirf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_swyft.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_taer.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tanar.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tasloi.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tgn.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tgnome.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_thalf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tief.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tnhalf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_trog.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_troll.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_tuladh.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_uldra.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_underf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_urdin.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_vana.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_varag.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_volod.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_vtooth.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_warchr.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_warf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_wdwarf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_wemic.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_wgen.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_wgnome.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_wielf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_woelf.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_xeph.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_yuan.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_zakya.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_zenyth.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\racialappear.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\racialtypes.2da
java -Xmx200m -jar tools\prc.jar 2da -r DevNotes\cls_feat_allBaseClasses.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_wildrn.2da
java -Xmx200m -jar tools\prc.jar 2da -r race2das\race_feat_reth.2da

:end

ENDLOCAL