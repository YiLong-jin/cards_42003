--永火死亡枪手
function c10700977.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10700977)
	e1:SetTarget(c10700977.thtg)
	e1:SetOperation(c10700977.thop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700977,4))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,10700977)
	e3:SetCost(c10700977.thcost)
	e3:SetTarget(c10700977.thtg)
	e3:SetOperation(c10700977.thop)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700977,6))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10700977.damcon)
	e2:SetCountLimit(1,10700978)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700977.damtg)
	e2:SetOperation(c10700977.damop)
	c:RegisterEffect(e2)	
end
function c10700977.dfilter(c)
	return c:IsDiscardable()
end
function c10700977.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c10700977.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c10700977.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c10700977.thfilter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10700977.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c10700977.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c10700977.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10700977.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	   Duel.SSet(tp,tc)
	end
end
function c10700977.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function c10700977.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function c10700977.damop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(10700977,1),aux.Stringid(10700977,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(10700977,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(10700977,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
		local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
		if tg:GetCount()>0 then
		   Duel.SendtoGrave(tg,REASON_EFFECT)
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_FIELD)
		   e1:SetCode(EFFECT_CHANGE_DAMAGE)
		   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e1:SetTargetRange(1,0)
		   e1:SetLabel(cid)
		   e1:SetValue(c10700977.damval)
		   e1:SetReset(RESET_CHAIN)
		   Duel.RegisterEffect(e1,tp)
		end
   else
	   if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	   local op=Duel.AnnounceType(1-tp)
	   Duel.ConfirmDecktop(tp,1)
	   local g=Duel.GetDecktopGroup(tp,1)
	   local tc=g:GetFirst()
	   if not ((op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP))) then
		  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700977,3))
		  local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		  local tc=sg:GetFirst()
		  local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
		  if tc then
			 Duel.ShuffleDeck(tp)
			 Duel.MoveSequence(tc,0)
			 Duel.ConfirmDecktop(tp,1)
			 local e2=Effect.CreateEffect(e:GetHandler())
			 e2:SetType(EFFECT_TYPE_FIELD)
			 e2:SetCode(EFFECT_REFLECT_DAMAGE)
			 e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			 e2:SetTargetRange(1,0)
			 e2:SetLabel(cid)
			 e2:SetValue(c10700977.refcon)
			 e2:SetReset(RESET_CHAIN)
			 Duel.RegisterEffect(e2,tp)
		  end
	   end
	end
end
function c10700977.damval(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return val end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return val end
	return 0
end
function c10700977.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end