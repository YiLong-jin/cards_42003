--水晶骑士救世主-月&莉薇儿
function c9879471.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_WARRIOR) and c:IsAttack(500) and c:IsType(TYPE_FUSION) end,2,true)
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
	e1:SetCondition(c9879471.hspcon)
	e1:SetTarget(c9879471.hsptg)
	e1:SetOperation(c9879471.hspop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
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
	--sr
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetCost(c9879471.thcost)
	e2:SetTarget(c9879471.thtg)
	e2:SetOperation(c9879471.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9879471,ACTIVITY_CHAIN,c9879471.chainfilter)
end
function c9879471.chainfilter(re,tp,cid)
	local rc=re:GetHandler() 
	return not (re:IsActiveType(TYPE_MONSTER) and not rc:IsRace(RACE_WARRIOR))
end
function c9879471.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(9879464,9879466) and c:GetEquipCount()>0 and c:IsAbleToGraveAsCost() 
end
function c9879471.spgck(g,e,tp) 
	return aux.dncheck(g) and Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0  
end 
function c9879471.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c9879471.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	return g:CheckSubGroup(c9879471.spgck,2,2,e,tp)
end
function c9879471.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9879471.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c9879471.spgck,false,2,2,e,tp)
	if sg~=nil and sg:GetCount()>0 then 
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c9879471.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c9879471.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetCustomActivityCount(9879471,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9879471.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end   
function c9879471.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsRace(RACE_WARRIOR)
end
function c9879471.seqfil(c) 
	return c:GetEquipTarget()~=nil  
end 
function c9879471.thfil(c)  
	return c:IsAbleToHand() and c:IsRace(RACE_WARRIOR) and c:IsAttack(500) 
end 
function c9879471.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local sg=Duel.GetMatchingGroup(c9879471.seqfil,tp,LOCATION_ONFIELD,0,nil) 
	if chk==0 then return sg:GetCount()>=2 and Duel.IsExistingMatchingCard(c9879471.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879471.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c9879471.seqfil,tp,LOCATION_ONFIELD,0,nil) 
	if sg:GetCount()>=2 then
		local x=Duel.SendtoGrave(sg,REASON_EFFECT)
		if x>0 and Duel.IsExistingMatchingCard(c9879471.thfil,tp,LOCATION_DECK,0,1,nil) then 
			local rg=Duel.SelectMatchingCard(tp,c9879471.thfil,tp,LOCATION_DECK,0,1,x,nil)
			Duel.SendtoHand(rg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,rg)  
		end 
	end 
end





