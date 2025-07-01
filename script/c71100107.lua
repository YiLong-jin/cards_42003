--死者的捕食
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100107
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--counter 
	local e1=bm.b.ce(c,bm.hint.sps,CATEGORY_COUNTER,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},sz,bm.b.con,cm.cost(4),cm.sptar,cm.spop)
	c:RegisterEffect(e1)
	--set 
	local e2=bm.b.ce(c,bm.hint.set,nil,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},ga,cm.setcon,aux.bfgcost,cm.settg,cm.setop)
	e2:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e2)
end
function cm.f(c,tp,ct)
	return c:IsCanRemoveCounter(tp,code3,ct,bm.re.c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function cm.cost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil,tp,ct)
		if chk==0 then return #tg>0 end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		tc:RemoveCounter(tp,code3,ct,REASON_COST)
	end
end
function cm.sf(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(code1,0xf3) and bm.c.go(c,sz,e,tp,bm.re.e)
end
function cm.sptar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.sf,dk,0,nil):GetCount()>0 end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.sf,tp,dk,0,1,1,nil)
	local tc=g:GetFirst()
	if Duel.SSet(tp,tc)~=0 and c:GetColumnGroup():FilterCount(bm.c.npos,nil,m-3)then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.setf(c,e,tp)
	return bm.c.go(c,sz,e,tp,bm.re.e) and c:IsSetCard(code1)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.setf,dk,0,nil,e,tp):GetCount()>0 end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,dk,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end








