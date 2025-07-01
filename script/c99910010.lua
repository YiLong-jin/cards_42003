--RWBY Ruby Rose
local m=99910010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1,1)

	--special summon cost
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
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
function cm.thcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsSetCard(0x679) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
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
	Duel.RegisterFlagEffect(tp,99910010,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
end