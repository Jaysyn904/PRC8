<file:open KRAGUS 'C:\Games\NeverwinterNights\NWN\localvault\trollbarbarian.bic'>
<var:iBuild=18>
\<html\>\n
\n
\<style\>\n
p {\n
  font-family: "Verdana";\n
  font-size: 8pt;\n
  color: white;\n
}\n
label1 {\n
  color: red;\n
}\n
td {\n
  font-family: "Verdana";\n
  font-size: 8pt;\n
  color: white;\n
  border: 1pt solid rgb(50,50,50);\n
}\n
table {\n
  border-collapse: collapse;\n
}\n
.label1 {\n
  color: gray;\n
}\n
.title1 {\n
  font-family: "Times New Roman";\n
  font-size: 16pt;
}\n
.title2 {\n
  background-color: rgb(50,50,50);\n
}\n


.title3 {\n
  background-color: rgb(20,20,20);\n
}\n


\n
\</style\>\n
\n
\<body bgcolor=black\>\n
\n
\<table cellpadding=5 cellspacing=0\>\n
<#: Title Info>
\<tr\>\<td class='title1' colspan=3\><Firstname> <Lastname>

\</td\>\</tr\>\n
\<tr\>\<td colspan=3\><lq:{xql="racialtypes[i=<Race>]:."}>, 

<if:<GoodEvil> lt 50>
  Evil
<else>
  Good
</if>

, <lq:{xql="gender[i=<Gender>]:."}>
\</td\>\</tr\>\n
\<tr\>\<td colspan=3\>

<#: List Class Totals>
<for:field 'ClassList'>
  <lq:{xql="classes[i=<~/Class>]:."}> (<~/ClassLevel>)



<if:<~/School> == "">
  &nbsp;
<else>
  &nbsp;&nbsp;[School: <lq:{xql="Schools[i=<~/School>]:."}>]
</if>

<if:<~/Domain1> == "">
  &nbsp;
<else>
  &nbsp;&nbsp;[Domain1: <lq:{xql="Domains[i=<~/Domain1>]:."}>]
</if>

<if:<~/Domain2> == "">
  &nbsp;
<else>
  &nbsp;&nbsp;[Domain2: <lq:{xql="Domains[i=<~/Domain2>]:."}>]
</if>




\<br\>\n

</for>
\</td\>\</tr\>\n

\<tr\>\<td valign=top align=center width=32%\>\n

\n
\<table cellpadding=3 cellspacing=0\>\n

<#: Attribute & Stats table>


<var:iStr=<Str>>
<var:iDex=<Dex>>
<var:iCon=<Con>>
<var:iInt=<Int>>
<var:iWis=<wis>>
<var:iCha=<Cha>>
<var:iStr=0+<var:iStr>+<lq:{xql="racialtypes[i=<Race>]:stradjust"}>>
<var:iDex=0+<var:iDex>+<lq:{xql="racialtypes[i=<Race>]:dexadjust"}>>
<var:iCon=0+<var:iCon>+<lq:{xql="racialtypes[i=<Race>]:conadjust"}>>
<var:iInt=0+<var:iInt>+<lq:{xql="racialtypes[i=<Race>]:intadjust"}>>
<var:iWis=0+<var:iWis>+<lq:{xql="racialtypes[i=<Race>]:wisadjust"}>>
<var:iCha=0+<var:iCha>+<lq:{xql="racialtypes[i=<Race>]:chaadjust"}>>
<var:iStrb=<Str>>
<var:iDexb=<Dex>>
<var:iConb=<Con>>
<var:iIntb=<Int>>
<var:iWisb=<wis>>
<var:iChab=<Cha>>
<var:iStrb=0+<var:iStrb>+<lq:{xql="racialtypes[i=<Race>]:stradjust"}>>
<var:iDexb=0+<var:iDexb>+<lq:{xql="racialtypes[i=<Race>]:dexadjust"}>>
<var:iConb=0+<var:iConb>+<lq:{xql="racialtypes[i=<Race>]:conadjust"}>>
<var:iIntb=0+<var:iIntb>+<lq:{xql="racialtypes[i=<Race>]:intadjust"}>>
<var:iWisb=0+<var:iWisb>+<lq:{xql="racialtypes[i=<Race>]:wisadjust"}>>
<var:iChab=0+<var:iChab>+<lq:{xql="racialtypes[i=<Race>]:chaadjust"}>>


<for:field 'LvlStatList'>

<if:<~/LvlStatAbility> ne "">
  <if:<~/LvlStatAbility> eq 0>
      <var:iStr=<var:iStr>-1>
  </if>

  <if:<~/LvlStatAbility> eq 1>
      <var:iDex=<var:iDex>-1>
  </if>

  <if:<~/LvlStatAbility> eq 2>
      <var:iCon=<var:iCon>-1>
  </if>

  <if:<~/LvlStatAbility> eq 3>
      <var:iInt=<var:iInt>-1>
  </if>

  <if:<~/LvlStatAbility> eq 4>
      <var:iWis=<var:iwis>-1>
  </if>

  <if:<~/LvlStatAbility> eq 5>
      <var:iCha=<var:iCha>-1>
  </if>
</if>
  <for:field '~/FeatList'>
    <if:<~/Feat> eq 764><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 765><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 766><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 767><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 768><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 769><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 770><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 771><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 772><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 773><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 774><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 775><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 776><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 777><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 778><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 779><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 780><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 781><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 782><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 783><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 784><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 785><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 786><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 787><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 788><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 789><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 790><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 791><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 792><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 793><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 794><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 795><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 796><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 797><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 798><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 799><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 800><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 801><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 802><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 803><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 804><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 805><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 806><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 807><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 808><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 809><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 810><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 811><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 812><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 813><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 814><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 815><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 816><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 817><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 818><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 819><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 820><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 821><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 822><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 823><var:iStr=<var:iStr>-1></if>
  </for>
</for>




\<tr\>\<td COLSPAN=3 nowrap class=title2\>Starting Stats\</td\>\<td COLSPAN=3 nowrap class=title2\>Ending Stats\</td\>\n
\<tr\>\<td width=30%\>STR\</td\>\<td width=10%\><var:iStr>\</td\>\<td width=10% nowrap\><math:floor((<var:iStr>-10)/2)>\</td\>\<td width=30%\>STR\</td\>\<td width=10%\><var:iStrb>\</td\>\<td width=10% nowrap\><math:floor((<var:iStrb>-10)/2)>\</td\>\</tr\>\n
\<tr\>\<td\>DEX\</td\>\<td\><var:iDex>\</td\>\<td nowrap\><math:floor((<var:iDex>-10)/2)>\</td\>\<td\>DEX\</td\>\<td\><var:iDexb>\</td\>\<td nowrap\><math:floor((<var:iDexb>-10)/2)>\</td\>\</tr\>\n
\<tr\>\<td\>CON\</td\>\<td\><var:iCon>\</td\>\<td nowrap\><math:floor((<var:iCon>-10)/2)>\</td\>\<td\>CON\</td\>\<td\><var:iConb>\</td\>\<td nowrap\><math:floor((<var:iConb>-10)/2)>\</td\>\</tr\>\n
\<tr\>\<td\>INT\</td\>\<td\><var:iInt>\</td\>\<td nowrap\><math:floor((<var:iInt>-10)/2)>\</td\>\<td\>INT\</td\>\<td\><var:iIntb>\</td\>\<td nowrap\><math:floor((<var:iIntb>-10)/2)>\</td\>\</tr\>\n
\<tr\>\<td\>WIS\</td\>\<td\><var:iWis>\</td\>\<td nowrap\><math:floor((<var:iWis>-10)/2)>\</td\>\<td\>WIS\</td\>\<td\><var:iWisb>\</td\>\<td nowrap\><math:floor((<var:iWisb>-10)/2)>\</td\>\</tr\>\n
\<tr\>\<td\>CHA\</td\>\<td\><var:iCha>\</td\>\<td nowrap\><math:floor((<var:iCha>-10)/2)>\</td\>\<td\>CHA\</td\>\<td\><var:iChab>\</td\>\<td nowrap\><math:floor((<var:iChab>-10)/2)>\</td\>\</tr\>\n
\<tr\>\<td COLSPAN=3\>AC <ArmorClass>\<br\>HP <MaxHitPoints>\</td\>
\<td COLSPAN=3 nowrap\>Experience: <Experience>\<br\>Next Level: <lq:{xql="exptable[level=<math:1+<LvlStatList?count>>]:xp"}>\</td\>\</tr\>\n
\<tr\>\<td COLSPAN=6\>
\<span class='label1'\>Fortitude:\</span\> <FortSaveThrow>\<br\>\n
\<span class='label1'\>Reflex:\</span\> <RefSaveThrow>\<br\>\n
\<span class='label1'\>Will:\</span\> <WillSaveThrow>\<br\>\n
\<span class='label1'\>BAB:\</span\> <BaseAttackBonus>\<br\>\n
\<span class='label1'\>SR:\</span\> <CombatInfo/SpellResistance>\<br\>\n
\<span class='label1'\>Gold:\</span\> <Gold>\</td\>\</tr\>\n
\</table\>\n\n


\</td\>\<td valign=top align=center width=15%\>\n


<#: Current Skill Totals>

\<table cellpadding=3 cellspacing=0\>\n
\<tr\>\<td nowrap class=title2\>Skill Totals\</td\>\<td class=title2\>\</td\>\</tr\>\n
  <for:field '~/SkillList'>
    <unless:<~/Rank>><next></unless>
    \<tr\>\<td\><lq:{xql="skills[i=<~?index>]:."}>\</td\>\<td\><~/Rank>\</td\>\</tr\>\n
  </for>
\</table\>\n


\</td\>\<td valign=top align=center\>\n


<#: Feats Listing>

\<table cellpadding=3 cellspacing=0\>\n
\<tr\>\<td class=title2\>Feats\</td\>\</tr\>\n
  \<tr\>\<td\>
  <var:strFeatList="">
  <for:field 'FeatList'>
    <if: <?index> eq <=:<FeatList?count>-1>>
      <var:strFeatList=<var:strFeatList> + <lq:{xql="feat[i=<~/Feat>]:."}>>
    <else:>
      <var:strFeatList=<var:strFeatList> + <lq:{xql="feat[i=<~/Feat>]:."}> + ", ">
    </if>
  </for>
  <var:strFeatList>
  \</td\>\</tr\>\n
\</table\>\n


\</td\>\</tr\>\n
\n

<#: Per level choices>

\<tr\>\<td colspan=3\>\<table cellpadding=3 cellspacing=0\>\n

\<tr class=title2\>\<td\>Lvl\</td\>\<td \>Class\</td\>\<td \>HP\</td\>\<td\>Ability\</td\>\<td nowrap\>[Unused] Skills (Total)\</td\>\<td \>Feats\</td\>\<td\>Spells\</td\>\</tr\>\n







<var:i=0>
<for:field 'LvlStatList'>
<var:i=<math:<var:i>=<var:i>+1>>

<#: Level>
<if: <var:i>%2=0>
  \<tr class=title3\>\<td valign=top\><=:<~?index> + 1>\</td\>\n
<else>
  \<tr\>\<td valign=top\><=:<~?index> + 1>\</td\>\n
</if>
<var: i=<var:i>+1>


<#: Class>
  \<td nowrap valign=top\><lq:{xql="classes[i=<~/LvlStatClass>]:."}>\</td\>\n

<#: HP>
  \<td valign=top\><~/LvlStatHitDie>\</td\>\n

<#: Ability increases>
  \<td valign=top center\>

<if:<~/LvlStatAbility> == "">
  &nbsp;
<else>
  +<lq:{xql="abilities[i=<~/LvlStatAbility>]:."}>
</if>

\</td\>\n

<#: Skills>
  \<td valign=top\>[<~/SkillPoints>] <for:field '~/SkillList'>
    <unless:<~/Rank>><next></unless>
    <var:totals[<~?index>]=0+<var:totals[<~?index>]>+<~/Rank>>
    <lq:{xql="skills[i=<~?index>]:."}> <~/Rank> (<var:totals[<~?index>]>)\<br\>
  </for>
  \</td\>

<#: Feats>
  \<td valign=top\><for:field '~/FeatList'>
    <lq:{xql="feat[i=<~/Feat>]:."}>\<br\>
  </for>
  \</td\>

<#: Spells>
  \<td valign=top\><for:field '~/KnownList0'>
    L0: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList1'>
    L1: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList2'>
    L2: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList3'>
    L3: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList4'>
    L4: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList5'>
    L5: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList6'>
    L6: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList7'>
    L7: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList8'>
    L8: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList9'>
    L9: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  \</td\>
\</tr\>\n\n
</for>
\</td\>\</tr\>\n
\</table\>\</td\>\</tr\>\n
\</table\>\n
\<p\>Build <var:iBuild> of the NWN character export script by \<a href="mailto:kragus_nwn@hotmail.com"\>Kragus\</a\>.  Thanks to \<a href="http://weathersong.infopop.cc/"\>dragonsong\</a\> for the \<a href="http://sourceforge.net/projects/leto" target="_blank"\>Leto\</a\> family of products that this script uses... and his help making this script possible.\</p\>
\</body\>\n
\</html\>