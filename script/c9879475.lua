--堕落水晶骑士-牧羊人
function c9879475.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_WARRIOR) and c:IsAttack(500) and c:IsFusionType(TYPE_SYNCHRO) end,2,true)
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
	e1:SetCondition(c9879475.hspcon)
	e1:SetTarget(c9879475.hsptg)
	e1:SetOperation(c9879475.hspop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--des
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetTarget(c9879475.sptg)
	e2:SetOperation(c9879475.spop)
	c:RegisterEffect(e2)
end
function c9879475.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(9879460) and c:GetEquipCount()>0 and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0 
end
function c9879475.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9879475.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c9879475.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9879475.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c9879475.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c9879475.seqfil(c) 
	return c:GetEquipTarget()~=nil  
end 
function c9879475.spfil(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_WARRIOR) and c:IsAttack(500) 
end 
function c9879475.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local sg=Duel.GetMatchingGroup(c9879475.seqfil,tp,LOCATION_ONFIELD,0,nil) 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	if chk==0 then return sg:GetCount()>=2 and ft>0 and Duel.IsExistingMatchingCard(c9879475.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9879475.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c9879475.seqfil,tp,LOCATION_ONFIELD,0,nil) 
	if sg:GetCount()>=2 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then 
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
		if ft>2 then ft=2 end 
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1 then ft=1 end 
		if ft>0 and Duel.IsExistingMatchingCard(c9879475.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) then 
			local rg=Duel.SelectMatchingCard(tp,c9879475.spfil,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
			Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
end




