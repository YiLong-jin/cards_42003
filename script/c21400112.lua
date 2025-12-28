--卢瑟哈肯的密室
function c21400112.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(21400112)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c21400112.dicecon)
	e2:SetOperation(c21400112.diceop)
	c:RegisterEffect(e2)
end
function c21400112.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return true 
end
function c21400112.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid,te=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID,CHAININFO_TRIGGERING_EFFECT)
	if te:GetHandler():IsSetCard(0xb210) then
		Duel.Hint(HINT_CARD,0,21400112) 
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=(ev&0xff)+(ev>>16&0xff)
		for i=1,ct do 
			--choose the index of results
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21400112,2))
			local val,idx=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
			dc[i]=val  
		end
		Duel.SetDiceResult(table.unpack(dc))
	end
end
