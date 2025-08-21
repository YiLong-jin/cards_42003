--神秘怪兽 情怀
function c9990990.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,c9990990.syncheck(c))
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990990,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9990990)
	e1:SetCondition(c9990990.con)
	e1:SetCost(c9990990.cost)
	e1:SetTarget(c9990990.tg)
	e1:SetOperation(c9990990.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9990990,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9990990)
	e2:SetTarget(c9990990.tftg)
	e2:SetOperation(c9990990.tfop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9990990,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,9990991)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9990990.drtg)
	e3:SetOperation(c9990990.drop)
	c:RegisterEffect(e3)
end
function c9990990.cfiltersss(c,syncard)
	return (c:IsType(TYPE_PENDULUM) or c:IsAttack(1550)) and c:IsNotTuner(syncard)
end
function c9990990.syncheck(syncard)
	return  function(g)
				return g:IsExists(c9990990.cfiltersss,1,nil,syncard)
			end
end
function c9990990.scfilter(c)
	return c:IsLinkMarker(LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP+LINK_MARKER_TOP_RIGHT+LINK_MARKER_RIGHT+LINK_MARKER_BOTTOM_RIGHT+LINK_MARKER_BOTTOM+LINK_MARKER_BOTTOM_LEFT+LINK_MARKER_LEFT) and c:IsFaceup()
end
function c9990990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9990990.scfilter,tp,LOCATION_ONFIELD,0,nil,nil)
	if chk==0 then return #g>0 end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return false end
	local lm=0
	if tc:IsLinkMarker(LINK_MARKER_TOP_LEFT) then lm=lm+0x040 end
	if tc:IsLinkMarker(LINK_MARKER_TOP) then lm=lm+0x080 end
	if tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then lm=lm+0x100 end
	if tc:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x020 end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x004 end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x002 end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x001 end
	if tc:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x008 end
	if lm==0 then return false end
	local off=1
	local ops={}
	local opval={}
	if tc:IsLinkMarker(LINK_MARKER_TOP_LEFT) then
		ops[off]=aux.Stringid(9990990,1)
		opval[off-1]=1
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_TOP) then
		ops[off]=aux.Stringid(9990990,2)
		opval[off-1]=2
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then
		ops[off]=aux.Stringid(9990990,3)
		opval[off-1]=3
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_RIGHT) then
		ops[off]=aux.Stringid(9990990,4)
		opval[off-1]=4
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then
		ops[off]=aux.Stringid(9990990,5)
		opval[off-1]=5
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM) then
		ops[off]=aux.Stringid(9990990,6)
		opval[off-1]=6
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then
		ops[off]=aux.Stringid(9990990,7)
		opval[off-1]=7
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_LEFT) then
		ops[off]=aux.Stringid(9990990,8)
		opval[off-1]=8
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		lm=lm-0x040
	elseif sel==2 then
		lm=lm-0x080
	elseif sel==3 then
		lm=lm-0x100
	elseif sel==4 then
		lm=lm-0x020
	elseif sel==5 then
		lm=lm-0x004
	elseif sel==6 then
		lm=lm-0x002
	elseif sel==7 then
		lm=lm-0x001
	elseif sel==8 then
		lm=lm-0x008
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(lm)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_SZONE)
	tc:RegisterEffect(e2)
end
function c9990990.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9990990.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c9990990.op(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
----------------------------------------------------------------------------------------------------------------
function c9990990.cfilter(c)
	return c:IsCode(9991000) or c:IsCode(9991010) and c:IsAbleToHand()
end
function c9990990.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990990.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9990990.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9990990.cfilter,tp,LOCATION_DECK,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
----------------------------------------------------------------------------------------------------------------
function c9990990.drfilter(c)
	return c:IsAbleToDeck()
end
function c9990990.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c9990990.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c9990990.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9990990.drfilter),p,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local sg=g:Select(p,1,5,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g3=Duel.GetOperatedGroup()
		if g3:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then Duel.ShuffleDeck(p) end
		local ct=g3:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.Draw(p,1,REASON_EFFECT)
		end
	end
end
