--放置少女-快乐圣诞
local m=9875409
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.otcon)
	e1:SetTarget(cm.ottg)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.csuspcost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98754090)
	e4:SetCost(cm.csuspcost)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.counterfilter)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end

function cm.counterfilter(c)
	return c:IsSetCard(0x2eab)
end

function cm.csuspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.csusplimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function cm.csusplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2eab)
end

function cm.otfilter(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end

function cm.otfilter2(c,e,tp)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and Duel.GetMZoneCount(tp,c)>0
end

function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	return c:IsLevelAbove(5) and c:IsSetCard(0x2eab)
		and ((mi==1 and Duel.IsExistingMatchingCard(cm.otfilter,tp,0,LOCATION_MZONE,1,nil,e) and (Duel.GetMZoneCount(tp)>0 or (ma~=1 and Duel.IsExistingMatchingCard(cm.otfilter2,tp,LOCATION_MZONE,0,1,nil,e))))
		or (mi==2 and Duel.IsExistingMatchingCard(cm.otfilter2,tp,LOCATION_MZONE,0,1,nil,e) and Duel.IsExistingMatchingCard(cm.otfilter,tp,0,LOCATION_MZONE,1,nil,e)))
end

function cm.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi>=1 and mi<=2
end

function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	local g1=Group.CreateGroup()
	local g2=g1
	if mi==1 and ma==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(tp,cm.otfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	elseif mi==1 and ma==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(tp,cm.otfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
		if Duel.GetMZoneCount(tp)<=0 or Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g2=Duel.SelectMatchingCard(tp,cm.otfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		end
	elseif mi==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(tp,cm.otfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g2=Duel.SelectMatchingCard(tp,cm.otfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	end
	if #g2>0 then g1:Merge(g2) end
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	c:SetMaterial(nil)
end

function cm.filter(c)
	return c:IsSetCard(0x2eab) and c:IsFaceup() and c:IsAbleToHand()
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,nil)
end

function cm.rett2filter(c)
	return c:IsSetCard(0x2eab) and c:IsSummonable(true,nil)
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.rett2filter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.rett2filter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function cm.thtgfilter(c)
	return c:IsSetCard(0x2eab) and c:IsAbleToHand()
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thtgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.thtgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end