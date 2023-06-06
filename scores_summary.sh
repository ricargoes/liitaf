#!/bin/sh

count_alexei () {
	count_np=$(grep -c '1685713217-366' $1)
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Axx: $1 self_np_refs: $count_np pp_refs: $count_pp cp_refs: $count_cp
}
alexei_scenes=$(grep -l 'A[0-9]\{2\}' dialogic/timelines/*)
for scene in $alexei_scenes; do
	count_alexei $scene
done

count_roxxane () {
	count_np=$(grep -c '1685713226-146' $1)
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Rxx: $1 self_np_refs: $count_np pp_refs: $count_pp cp_refs: $count_cp
}
roxxane_scenes=$(grep -l 'R[0-9]\{2\}' dialogic/timelines/*)
for scene in $roxxane_scenes; do
	count_roxxane $scene
done

count_sharon () {
	count_np=$(grep -c '1685713237-918' $1)
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Sxx: $1 self_np_refs: $count_np pp_refs: $count_pp cp_refs: $count_cp
}
sharon_scenes=$(grep -l 'S[0-9]\{2\}' dialogic/timelines/*)
for scene in $sharon_scenes; do
	count_sharon $scene
done

count_zachary () {
	count_np=$(grep -c '1685713245-483' $1)
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Zxx: $1 self_np_refs: $count_np pp_refs: $count_pp cp_refs: $count_cp
}
zachary_scenes=$(grep -l 'Z[0-9]\{2\}' dialogic/timelines/*)
for scene in $zachary_scenes; do
	count_zachary $scene
done

count_waiting () {
	count_np=$(grep -c '1685713256-970' $1)
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Wxx: $1 self_np_refs: $count_np pp_refs: $count_pp cp_refs: $count_cp
}
waiting_scenes=$(grep -l 'W[0-9]\{2\}' dialogic/timelines/*)
for scene in $waiting_scenes; do
	count_waiting $scene
done

count_study () {
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Sxx: $1 pp_refs: $count_pp cp_refs: $count_cp
}
study_scenes=$(grep -l 'T[0-9]\{2\}' dialogic/timelines/*)
for scene in $study_scenes; do
	count_study $scene
done

count_informant () {
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Ixx: $1 pp_refs: $count_pp cp_refs: $count_cp
}
informant_scenes=$(grep -l 'I[0-9]\{2\}' dialogic/timelines/*)
for scene in $informant_scenes; do
	count_informant $scene
done

count_ending () {
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Exx: $1 pp_refs: $count_pp cp_refs: $count_cp
}
ending_scenes=$(grep -l 'E[0-9]\{2\}' dialogic/timelines/*)
for scene in $ending_scenes; do
	count_ending $scene
done

count_narration () {
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Nxx: $1 pp_refs: $count_pp cp_refs: $count_cp
}
narration_scenes=$(grep -l 'N[0-9]\{2\}' dialogic/timelines/*)
for scene in $narration_scenes; do
	count_narration $scene
done

count_mix () {
	count_ap=$(grep -c '1685713217-366' $1)
	count_rp=$(grep -c '1685713226-146' $1)
	count_sp=$(grep -c '1685713237-918' $1)
	count_zp=$(grep -c '1685713245-483' $1)
	count_wp=$(grep -c '1685713256-970' $1)
	count_pp=$(grep -c '1685480190-265' $1)
	count_cp=$(grep -c '1685713211-787' $1)
	echo Xxx/Pxx: $1 self_np_refs: \(a:$count_ap r:$count_rp s:$count_sp z:$count_zp w:$count_wp\) pp_refs: $count_pp cp_refs: $count_cp
}
x_scenes=$(grep -l 'X[0-9]\{2\}' dialogic/timelines/*)
for scene in $x_scenes; do
	count_mix $scene
done

p_scenes=$(grep -l 'P[0-9]\{2\}' dialogic/timelines/*)
for scene in $p_scenes; do
	count_mix $scene
done
