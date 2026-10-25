--堕落水晶骑士-月
function c9879470.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_WARRIOR) and c:IsAttack(500) end,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c9879470.hspcon)
	e1:SetTarget(c9879470.hsptg)
	e1:SetOperation(c9879470.hspop)
	c:RegisterEffect(e1)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e12:SetValue(1)
	c:RegisterEffect(e12)
	--reflect battle damage
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	--des
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetTarget(c9879470.destg)
	e2:SetOperation(c9879470.desop)
	c:RegisterEffect(e2)
end
function c9879470.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(9879464) and c:GetEquipCount()>0 and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0 
end
function c9879470.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9879470.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c9879470.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9879470.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c9879470.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c9879470.seqfil(c) 
	return c:GetEquipTarget()~=nil  
end 
function c9879470.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local sg=Duel.GetMatchingGroup(c9879470.seqfil,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if chk==0 then return g:GetCount()>0 and sg:GetCount()>=2 end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9879470.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c9879470.seqfil,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if sg:GetCount()>=2 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then 
		local dg=g:Select(tp,1,3,nil)
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end




