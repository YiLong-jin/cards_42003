--宝物猎人☆目标
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100048
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
local code3=0x7d2 --V城
function cm.initial_effect(c)
	local e1=bm.b.ce(c,bm.hint.th,CATEGORY_SEARCH+CATEGORY_TOHAND,EFFECT_TYPE_ACTIVATE,EVENT_FREE_CHAIN,{1,m+EFFECT_COUNT_CODE_OATH},nil,bm.b.con,bm.b.cost,cm.tg,cm.op)
	c:RegisterEffect(e1)
end
function cm.mf(c)
	return bm.c.pos(c) and ((c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL)) or c:IsSetCard(code2))
end
function cm.sf(c,tp)
	if not c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsCode(m) or not c:IsAbleToHand(tp) then return false end
	if Duel.IsExistingMatchingCard(cm.mf,tp,mz,0,1,nil) then return c:IsSetCard(code1,code3) end
	return c:IsCode(m+3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sf,tp,dk,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,dk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.sf,tp,dk,0,1,1,nil,tp)
	if #g>0 and Duel.SendtoHand(g,tp,bm.re.e)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end