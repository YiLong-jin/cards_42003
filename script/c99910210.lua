--蜃缚之V 湮
local m=99910210
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)


	--special summon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--remove overlay replace
	--To Hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_RELEASE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m+1)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.activate)
	--c:RegisterEffect(e6)
	local e4=e6:Clone()
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(cm.atkcon)
	c:RegisterEffect(e4) 
	--effect rice use
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,m)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.operation1)
	c:RegisterEffect(e5)
		if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end

end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_EXTRA)>0 then
	   Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.gyfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x167a) and not c:IsCode(m)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.IsExistingMatchingCard(cm.gyfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26237713,0))
	local g1=Duel.SelectMatchingCard(tp,cm.gyfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoExtraP(g1,nil,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)==0 
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_LINK)
end




function cm.filter11(c)
	return c:IsFaceup() and c:IsSetCard(0x167a) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter11,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter11,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end










function cm.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,3,nil,tp) and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function cm.spfilter1(c,tp)
	return c:IsSetCard(0x167a) and c:IsFusionType(TYPE_PENDULUM) and not c:IsCode(m) and c:IsFaceup()
end
function cm.spfilter2(c,tp)
	return c:IsSetCard(0x167a) and c:IsFusionType(TYPE_PENDULUM) and not c:IsCode(m) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_EXTRA,0,2,2,nil,tp)
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg>=2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=pg:SelectSubGroup(tp,aux.dncheck,false,2,2)
	local tc1=g1:GetFirst()
	local tc2=g1:GetNext()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g3=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
		Duel.SendtoDeck(g3,nil,nil,REASON_SPSUMMON)
		pg:Clear()
	end 
end

