--蜕变于刹那芳华
function c10701434.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10701434.condition)
	e1:SetCost(c10701434.cost)
	e1:SetTarget(c10701434.target)
	e1:SetOperation(c10701434.activate)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701434,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10701434.sptg)
	e2:SetOperation(c10701434.spop)
	c:RegisterEffect(e2) 
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c10701434.handcon)
	c:RegisterEffect(e3)  
	if c10701434.counter==nil then
		c10701434.counter=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c10701434.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_DECK)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c10701434.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c10701434.spfilter(c,e,tp)
	return c:IsSetCard(0x7cc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701434.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701434.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10701434.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10701434.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10701434.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	  e1:SetValue(0)
	  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	  tc:RegisterEffect(e1)
	  tc:RegisterFlagEffect(10701434,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	  local e2=Effect.CreateEffect(c)
	  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	  e2:SetRange(LOCATION_MZONE)
	  e2:SetCode(EVENT_PHASE+PHASE_END)
	  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	  e2:SetCountLimit(1)
	  e2:SetOperation(c10701434.desop)
	  Duel.RegisterEffect(e2,tp)
	end
end
function c10701434.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10701434.cfilter(c,tp)
	return c:IsControler(tp)
end
function c10701434.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsControler(1-tp) then
			c10701434.counter=c10701434.counter+1
		end
		tc=eg:GetNext()
	end
end
function c10701434.clear(e,tp,eg,ep,ev,re,r,rp)
	c10701434.counter=0
end
function c10701434.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsSetCard(0x7cc)end,tp,LOCATION_MZONE,0,1,nil)
end
function c10701434.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10701434.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(c10701434.sumlimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e3:SetTarget(c10701434.sumlimit)
	c:RegisterEffect(e3)
end
function c10701434.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x7cc)
end
function c10701434.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return (h1<h2 and Duel.IsPlayerCanDraw(tp,h2-h1)) or h1>h2 end
end
function c10701434.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if h1<h2 and Duel.IsPlayerCanDraw(tp,h2-h1) then
		Duel.Draw(tp,h2-h1,REASON_EFFECT)
	end
	if h1>h2 then
		Duel.DiscardHand(tp,nil,h1-h2,h1-h2,REASON_EFFECT+REASON_DISCARD)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e1:SetValue(c10701434.atkval)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c10701434.atkval(e,c)
	return c:GetBaseAttack()/-2
end
function c10701434.handcon(e,tp,eg,ep,ev,re,r,rp)
	return c10701434.counter>=3
end