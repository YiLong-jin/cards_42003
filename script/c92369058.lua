--追寻起源之路·灾祸延续之兽
local m=92369058
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetCode(EFFECT_SPSUMMON_PROC)
	e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e21:SetRange(LOCATION_EXTRA)
	e21:SetCondition(cm.spcon)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	--Effect 2
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCountLimit(1,m+100)
	e12:SetCondition(cm.todcon)
	e12:SetTarget(cm.todtg)
	e12:SetOperation(cm.todop)
	c:RegisterEffect(e12)  
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
end
--special summon rule
function cm.spfilter3(c)
	return c:GetOriginalLevel()==9 
		and c:IsFaceup()
		and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x4a49)
		and c:IsAbleToGraveAsCost()
end
function cm.tunfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsLevel(1) and c:IsFaceup()
		and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
		and Duel.IsExistingMatchingCard(cm.spfilter3,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tunfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 and #g1>0 then
		g:Merge(g1)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--Effect 1
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCountLimit(2)
	e4:SetCondition(cm.negcon)
	e4:SetOperation(cm.negop)
	e4:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e4,tp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp) --rp==1-tp and
	return rp==1-tp and Duel.IsChainDisablable(ev) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler()
	if aux.nbcon(tp,re) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		if  rc:IsRelateToEffect(re) and not rc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--Effect 2
function cm.todcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(1-tp,m)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and ct>=3
end
function cm.todtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.todop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end



