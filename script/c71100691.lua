--归还与乐园的追忆
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(this.condition)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(this.con)
	e2:SetOperation(this.operation)
	c:RegisterEffect(e2)
end
function this.tgopchkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7d2) and c:IsType(TYPE_MONSTER)
end
function this.tgopchk(tp)
	return Duel.IsExistingMatchingCard(this.tgopchkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end 
function this.condition(e,tp,eg,ep,ev,re,r,rp)
	return this.tgopchk(tp) and Duel.GetFlagEffect(tp,id)==0 
end
function this.filter1(c,chk)
	local tp=c:GetControler()
	return c:IsSetCard(0x7d2) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(this.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c,chk)
end 
function this.filter2(c,sc,chk) 
	local tp=c:GetControler()
	local sg=Group.FromCards(c,sc)
	return c:IsSetCard(0x7d7) and c:IsAbleToHand() and (chk~=0 or Duel.IsExistingMatchingCard(this.filter3,tp,LOCATION_GRAVE,0,1,sg))
end
function this.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() 
end 
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	if not this.tgopchk(tp) then return end 
	Duel.RegisterFlagEffect(tp,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,this.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1)
	if #g1<1 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,this.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,g1,g1:GetFirst(),1)
	if #g2<1 then return end 
	g1:Merge(g2)
	if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,this.filter3,tp,LOCATION_GRAVE,0,1,99,nil)
		if #g<1 then return end 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end 
end
function this.con(e,tp,eg,ep,ev,re,r,rp)
	return this.tgopchk(tp) and Duel.GetFlagEffect(tp,id+1)==0 
end
function this.acttg(e,c)
	return c:GetType()==TYPE_TRAP
end
function this.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+1)~=0 then return end
	if not this.tgopchk(tp) then return end 
	Duel.RegisterFlagEffect(tp,id+1,0,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetTarget(this.acttg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
