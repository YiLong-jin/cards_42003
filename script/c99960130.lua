--真魔法·魔神诵
local s,id,o=GetID()
dofile("expansions/script/c99960010.lua")
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,99960130+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(shenqi_Savior.spellcost2)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	if not shenqi_Savior.global_check then
		shenqi_Savior.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(shenqi_Savior.aclimit)
		Duel.RegisterEffect(ge1,0)
	end
end
s.Savior_shenqi=true
function s.dfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.sfilter(c,p,seq,loc)
	local sseq=c:GetSequence()
	if c:IsControler(1-p) then
		return loc==LOCATION_MZONE and c:IsLocation(LOCATION_MZONE)
			and (sseq==5 and seq==3 or sseq==6 and seq==1)
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and (sseq==seq or loc==LOCATION_SZONE and math.abs(sseq-seq)==1)
	end
	if sseq<5 then
		return sseq==seq or loc==LOCATION_MZONE and math.abs(sseq-seq)==1
	else
		return loc==LOCATION_MZONE and (sseq==5 and seq==1 or sseq==6 and seq==3)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,s.dfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	local g=Duel.GetMatchingGroup(s.sfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc:GetControler(),tc:GetSequence(),tc:GetLocation())
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetChainLimit(s.chainlimit)
end
function s.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.sfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,tc:GetControler(),tc:GetSequence(),tc:GetLocation())
		g:AddCard(tc)
		Duel.Destroy(g,REASON_EFFECT)
	end
end










