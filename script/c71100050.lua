--宝物猎人☆撤退
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100050
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
local code3=0x7d2 --V城
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--th
	local e2=bm.b.ce(c,bm.hint.th,CATEGORY_TOHAND,EFFECT_TYPE_IGNITION,EVENT_FREE_CHAIN,{1,m+2},sz,nil,nil,cm.rhtg,cm.rhop)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e2)
	--Negate
	local e3=bm.b.ce(c,nil,CATEGORY_NEGATE+CATEGORY_DESTROY,EFFECT_TYPE_QUICK_O,EVENT_CHAINING,{1,m},sz,cm.necon,cm.necost,cm.netg,cm.neop)
	c:RegisterEffect(e3)
end
function cm.spcf(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL) and bm.c.pos(c) and c:IsControler(tp)
end
function cm.thf(g,tp)
	return g:IsExists(cm.spcf,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(cm.spcf,tp,mz,0,1,nil,tp) and Duel.IsExistingTarget(aux.TRUE,tp,0,of,1,nil) end
	local og=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,mz,of,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=og:SelectSubGroup(tp,cm.thf,false,2,2,tp)
	Duel.SetTargetCard(g)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,mz)
end
function cm.rhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,bm.re.e)
	end
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_DRAGON))
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and #tg==1 and tg:IsExists(cm.cfilter,1,nil) and Duel.IsChainNegatable(ev) and rp~=tp
end
function cm.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end