--宝物猎人☆行动
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100047
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
local code3=0x7d2 --V城
function cm.initial_effect(c)
	local e1=bm.b.ce(c,bm.hint.sps,CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_GRAVE_SPSUMMON,EFFECT_TYPE_ACTIVATE,EVENT_FREE_CHAIN,{1,m+EFFECT_COUNT_CODE_OATH},nil,bm.b.con,bm.b.cost,cm.tg,cm.op)
	c:RegisterEffect(e1)
end
function cm.mf1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL) and bm.c.pos(c)
end
function cm.mf2(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(1) and c:IsType(TYPE_EFFECT) and bm.c.pos(c)
end
function cm.of1(c,e,tp)
	return cm.mf1(c) and Duel.IsExistingMatchingCard(cm.mf2,tp,mz,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function cm.of2(c,e,tp)
	return cm.mf2(c) and Duel.IsExistingMatchingCard(cm.mf1,tp,mz,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function cm.mixf(c,e,tp)
	return cm.of1(c,e,tp) or cm.of2(c,e,tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mixf,tp,ha+dk+ga,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,ha+dk+ga)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.mixf,tp,ha+dk+ga,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end