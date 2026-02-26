--渴·望骑士-救世主情怀
function c9879369.initial_effect(c)
	c:SetSPSummonOnce(9879369)
	aux.AddCodeList(c,9879202)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9879369.ffilter,2,false)
	aux.AddContactFusionProcedure(c,c9879369.ffilter1,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9879369,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetCountLimit(1)
	e4:SetCondition(c9879369.drcon)
	e4:SetTarget(c9879369.drtg)
	e4:SetOperation(c9879369.drop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	
	local e21=Effect.CreateEffect(c) 
	e21:SetDescription(aux.Stringid(9879369,1))
	e21:SetCategory(CATEGORY_DESTROY) 
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e21:SetCode(EVENT_SUMMON_SUCCESS) 
	e21:SetProperty(EFFECT_FLAG_DELAY) 
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1)  
	e21:SetCondition(c9879369.descon)
	e21:SetTarget(c9879369.destg) 
	e21:SetOperation(c9879369.desop) 
	c:RegisterEffect(e21) 
	local e31=e21:Clone() 
	e31:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e31) 
	
end
function c9879369.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x1661) and c:IsType(TYPE_MONSTER) 
end
function c9879369.ffilter1(c,fc,sumtype,tp)
	return aux.IsCodeListed(c,9879202) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end


function c9879369.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x1661) and c:IsType(TYPE_MONSTER) 
end
function c9879369.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879369.cfilter,1,nil,tp)
end
function c9879369.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9879369.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


function c9879369.cfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and aux.IsCodeListed(c,9879202) and c:IsType(TYPE_MONSTER) 
end
function c9879369.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879369.cfilter1,1,nil,tp)
end
function c9879369.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c9879369.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0  then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 