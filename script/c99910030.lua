--RWBY Blake Belladonna
local m=99910030
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	--special summon cost
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.spop)
	--c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.limcoun)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.limcoun) 
	--effect change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.ectg)
	e3:SetOperation(cm.ecop)
 --   e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
   --effect change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.ectg2)
	e4:SetOperation(cm.ecop)
	c:RegisterEffect(e4)


	local e15=aux.AddLinkProcedure(c,nil,1,1,cm.MatFilter2)
	e15:SetDescription(aux.Stringid(99910010,4))
	e15:SetCountLimit(1,99910000)
end
function cm.lckeckm2(c)
	return c:IsLinkType(TYPE_LINK) and c:IsSetCard(0x679)
end
function cm.MatFilter2(g,c)
	return g:IsExists(cm.lckeckm2,1,nil)
end


function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99910090) or c:IsCode(99910091)
end


function cm.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x679)
end
function cm.limcoun(c)
	return c:IsSetCard(0x679)
end
function cm.mfilter(c)
	return c:IsLinkType(TYPE_SPELL) or c:IsLinkType(TYPE_TRAP)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsSetCard(0x679) and c:IsAbleToHand()
end
function cm.setfilter(c)
	return c:IsSetCard(0x679) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(99910031,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.tgcon)
		e1:SetOperation(cm.tgop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(99910031)==e:GetLabel()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function cm.costfilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_MONSTER) or c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.ectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then   
	return not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil)
	end
end
function cm.ectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then   
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil)
	end
end
function cm.ecop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.RegisterFlagEffect(tp,99910030,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
end