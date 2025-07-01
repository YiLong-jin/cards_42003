--关于V城的记忆碎片
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100053
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
function cm.initial_effect(c)
	local e1=bm.b.ce(c,bm.hint.th,CATEGORY_SEARCH+CATEGORY_TOHAND,EFFECT_TYPE_ACTIVATE,EVENT_FREE_CHAIN,{1,m+EFFECT_COUNT_CODE_OATH},nil,bm.b.con,bm.cost,cm.tg,cm.op)
	c:RegisterEffect(e1)
end
function cm.thfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return c:IsSetCard(code1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
